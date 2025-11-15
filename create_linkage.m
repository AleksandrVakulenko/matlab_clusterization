


function Linkage_data = create_linkage(Data, Cache_active)
arguments
    Data
    Cache_active logical = true
end

if Cache_active
    [Data_exist, Linkage_data] = find_hash(Data);
    if ~Data_exist
        Linkage_data = linkage_calc(Data);
        save_temp_data(Data, Linkage_data);
    else
        disp('Linkage loaded from cache');
    end
else
    Linkage_data = linkage_calc(Data);
end

end


function Linkage_data = linkage_calc(Data)
    data_size = size(Data, 1);
    check_mem_clusterizing(data_size);

    disp("Linkage in progress ...")
    tic
    Linkage_data = linkage(Data, "ward");
    Time = toc;
    disp(['Linkage ended in ' num2str(Time, '%0.1f') ' s' newline])
end

function save_temp_data(Data_in, Temp_data)
    temp_folder_name = "temp";
    create_temp_folder(temp_folder_name);

    Hash = get_hash(Data_in);
    Filename = [char(Hash) '.mat'];
    full_path = [char(temp_folder_name) '/' Filename];
    save(full_path, "Temp_data");
end

function [Data_exist, Temp_data] = find_hash(Data)
    temp_folder_name = "temp";
    create_temp_folder(temp_folder_name);
    
    Hash = get_hash(Data);
    Filename = [char(Hash) '.mat'];
    File_exist = find_file_in_folder(Filename);
    
    Temp_data = [];
    Data_exist = false;
    if File_exist
        full_path = [char(temp_folder_name) '/' Filename];
        matObj = matfile(full_path);
        if isprop(matObj, 'Temp_data')
            load(full_path, 'Temp_data');
            Data_exist = true;
        end
    end
end

function Exist = find_file_in_folder(Filename)
    temp_folder_name = "temp";
    content = dir(temp_folder_name);
    Exist = false;
    for i = 1:numel(content)
        if ~content(i).isdir
            if string(content(i).name) == string(Filename)
                Exist = true;
            end
        end
    end
end

function create_temp_folder(temp_folder_name)
    content = dir;
    Exist = false;
    for i = 1:numel(content)
        if content(i).isdir
            if string(content(i).name) == string(temp_folder_name)
                Exist = true;
            end
        end
    end
    if ~Exist
        mkdir(temp_folder_name);
    end
end

function hash = get_hash(data)
    import java.security.*;
    import java.math.*;
    byte_stream = getByteStreamFromArray(data); % serialization
    MD = MessageDigest.getInstance('MD5'); % java magic
    hash = MD.digest(byte_stream);
    number = BigInteger(1, hash);
    hash = string(number.toString(16)); % string output
end

function check_mem_clusterizing(Data_size)

N = Data_size;
size_Gb = (0.5*N^2 * 4)/1024^3;

[~, systemview] = memory;
PM = systemview.PhysicalMemory;
Mem_av_Gb = PM.Available/1024^3;

if size_Gb > Mem_av_Gb*0.95
    error(['Out of memory:' newline 'Data size: ' num2str(size_Gb, '%0.2f')...
        ' Gb' newline 'Avalable: ' num2str(Mem_av_Gb, '%0.2f') ' Gb']);
end
end