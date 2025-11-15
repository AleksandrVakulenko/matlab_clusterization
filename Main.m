
%% Find all names
clc

Folder = 'Data';
Tif_files = find_tif_files(Folder);
clearvars Folder

%% Load image
% Full image in col 1 of Images cell
clc

N = numel(Tif_files);
Images = cell(N, 1);
for i = 1:N

filename = Tif_files(i).full_path;
[Image_Data, Tiff_obj] = load_image(filename);
Images{i} = Image_Data;

end

clearvars i N filename Image_Data Tiff_obj
clearvars Tif_files

%% Create stencils
% Stencil in col 2 of Images cell
clc

N = size(Images, 1);
for i = 1:N
    Image_Data = Images{i, 1};
    Stencil = create_stencil(Image_Data);
    Images{i, 2} = Stencil;
end

clearvars i N Image_Data Stencil


%% Find mean of all layers and Normalize

Mean_of_layer = find_mean_of_all_layers(Images);
Images = Normalize_data(Images, Mean_of_layer);

clearvars Mean_of_layer


%% Layers preview (12 layers)
% clc
% 
Image_num = 6;
Draw_image_layers(Images, Image_num);
clearvars Image_num


%% Data reshape and cut by stencil
% Data_sparse in col 3 of Images cell
% Rand_index in col 4 of Images cell

N = size(Images, 1);
for i = 1:N
    disp([num2str(i) '/' num2str(N)]);
    Image_Data = Images{i, 1};
    Stencil = Images{i, 2};
    [Data, Initial_indexes] = extract_data_from_image(Image_Data, Stencil);
%     Images{i, 3} = Data;
%     Images{i, 4} = Initial_indexes;
    Z = create_linkage(Data);
    Clasters = cluster(Z, maxclust=20);

    % Sparse data
    Part_size = 0.1;
    [Data_sparse, Rand_index] = sparse_data(Data, Clasters, Initial_indexes, Part_size);
    Images{i, 3} = Data_sparse;
    Images{i, 4} = Rand_index;

end
clearvars N i Image_Data Data Stencil Initial_indexes



%%
% Original images in col 1 of Images2 cell
% Claster numbers in col 2 of Images2 cell
% Initial_indexes in col 3 of Images2 cell
% Rand_index in col 4 of Images2 cell
clc

N = size(Images, 1);
Images2 = Images;
Images2(:, 4) = [];
for i = 1:N
    disp([num2str(i) '/' num2str(N)]);
    Image_Data = Images{i, 1};
    Stencil = Images{i, 2};
    [Data, Initial_indexes] = extract_data_from_image(Image_Data, Stencil);
    Data_size = size(Data, 1);
    Common_data = create_common_data(Images(:, 3), i);
    Data_union = [Data; Common_data];

    Linkage_data = create_linkage(Data_union, false);
%     Clasters = cluster(Linkage_data, "maxclust", 10);
    Clasters = cluster(Linkage_data, "cutoff", 0.1);
    disp(['Unique clasters ' numel(numel(unique(Clasters))) ' ----']);
    Clasters = Clasters(1:Data_size);

    Images2{i, 2} = Clasters;
    Images2{i, 3} = Initial_indexes;
    Images2{i, 4} = Linkage_data;

    dendrogram(Linkage_data, 360);
    drawnow
end






%%

Image_num = 17;

Image_Data = Images{Image_num, 1};
Stencil = Images{Image_num, 2};

LN = size(Image_Data, 3);
if LN > 12
    error("more than 12 layers on image")
end

figure('Position', [510 100 768 550])
for iL = 1:LN
% i = 5
    Layer = Image_Data(:, :, iL);
    M = mean(Layer(Stencil), 'all');
    Layer(~Stencil) = M;

    Ind = Images{Image_num, 4};
    Layer(Ind) = 0;

    subplot(3, 4, iL);
    imagesc(Layer);
    axis equal
    colormap gray
    set(gca, 'YDir', 'normal')
    title(['Layer ' num2str(iL)])
end
















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





























