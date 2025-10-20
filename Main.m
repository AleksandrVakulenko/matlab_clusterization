
%% Load image
clc

filename = '2024021_1.1.tif';
% filename = 'total buffers.tif';
disp(['Opening:' newline filename newline 'in progress ...'])

Tiff_obj = Tiff(filename);

Image_Data = read(Tiff_obj);

disp('File ready.');

% clearvars Tiff_obj filename


%% Create circle stencil

Normalize = false;

clc
Stencil = false(size(Image_Data, [1,2]));
for i = 1:size(Image_Data, 3)

    Layer = Image_Data(:, :, i);

    range = Layer ~= 0;
    M = mean(Layer(range));
    Layer(~range) = M;
    if Normalize
        Image_Data(:, :, i) = Layer/M;
    else
        Image_Data(:, :, i) = Layer;
    end
    Stencil(range) = true;

end

clearvars i Layer M range

imagesc(Stencil)
axis equal

%% Image part

range_y = 6392:6645;
range_x = 1623:1945;
Image_Data = Image_Data(range_y, range_x, :);
Stencil = Stencil(range_y, range_x);

%% Layers preview
clc

figure('Position', [510 100 768 550 ])
for i = 1:12
    subplot(3, 4, i);
    imagesc(Image_Data(:, :, i));
    axis equal
    colormap gray
    set(gca, 'YDir', 'normal')
    title(['Layer ' num2str(i)])
end

clearvars i

%% Data reshape and cut by stencil

H = size(Image_Data, 1);
K = size(Image_Data, 2);
L = size(Image_Data, 3);
Data = reshape(Image_Data, [H*K L]);
Initial_sz1 = H;
Initial_sz2 = K;

H = size(Stencil, 1);
K = size(Stencil, 2);
L = 1;
Stencil_linear = reshape(Stencil, [H*K, L]);

Data = Data(Stencil_linear, :);

Initial_indexes = find(Stencil);

clearvars H K L Stencil_linear


%% Clusterization
clc
N = size(Data, 1);
check_mem_clusterizing(N);

disp("Linkage in progress ...")
tic
Z = linkage(Data, "ward");
Time = toc;
disp(['Linkage ended in ' num2str(Time, '%0.1f') ' s'])
%%
Clasters = cluster(Z, maxclust=20);
toc


%% Claster sort

clc

Clasters = sort_clasters(Clasters);
Claster_sizes = find_claster_sizes(Clasters);

plot_clasters_sizes(Clasters);

%% Bin splitter

c_un = unique(Clasters);
Bin = {};
for i = 1:numel(c_un)
    Bin{i} = find(Clasters == c_un(i));
end


% Claster image

N = numel(Bin);
Image_c = zeros(Initial_sz1, Initial_sz2);
for i = 1:numel(Bin)
    
    ind = Bin{i};
    ind = Initial_indexes(ind);
    Image_c(ind) = i;

end

imagesc(Image_c)
axis equal
set(gca, 'YDir', 'normal')
caxis([0.9 N])
set(gca, 'Colormap', load_colormap())



%% Sparse data

Part_size = 0.1;
Data_sparse = sparse_data(Data, Clasters, Part_size);




%% Image save

% TODO: add pixed data type control

% Image_file_Data(:,:,1) = single(Image_Data_output_Forest);
% Image_file_Data(:,:,2) = 2;
% Image_file_Data(:,:,3) = 3;
% Image_file_Data(:,:,4) = 4;
% Image_file_Data(:,:,5) = 5;
% Image_file_Data(:,:,6) = 6;
% Image_file_Data(:,:,7) = 7;
% Image_file_Data(:,:,8) = 8;
% Image_file_Data(:,:,9) = 9;


Image_file_Data(:,:,1) = single(Image_c);
folder_output = '.';
filename_output = 'TEST_OUTPUT.TIF';
file_addr = [folder_output '/' filename_output];


numrows = size(Image_file_Data, 1);
numcols = size(Image_file_Data, 2);
SamplesPerPixel = size(Image_file_Data, 3);

Tiff_obj2 = Tiff(file_addr, 'w');
disp('Tiff file created')

setTag(Tiff_obj2, "Photometric",Tiff.Photometric.LinearRaw)
setTag(Tiff_obj2, "Compression",Tiff.Compression.None)

setTag(Tiff_obj2, "BitsPerSample", 32)
setTag(Tiff_obj2, "SamplesPerPixel", SamplesPerPixel)
% setTag(Tiff_obj2, "SampleFormat", Tiff.SampleFormat.UInt)
setTag(Tiff_obj2, "SampleFormat", Tiff.SampleFormat.IEEEFP)
setTag(Tiff_obj2, "ExtraSamples", Tiff.ExtraSamples.Unspecified)
setTag(Tiff_obj2, "ImageLength", numrows)
setTag(Tiff_obj2, "ImageWidth", numcols)
setTag(Tiff_obj2, "TileLength", 32)
setTag(Tiff_obj2, "TileWidth", 32)
setTag(Tiff_obj2, "PlanarConfiguration", Tiff.PlanarConfiguration.Chunky)

try
    write(Tiff_obj2, Image_file_Data);
    disp('Tiff file writeing end')
    
    close(Tiff_obj2)
    disp('Tiff file closed')
catch e
    close(Tiff_obj2)
    rethrow(e);
end





























