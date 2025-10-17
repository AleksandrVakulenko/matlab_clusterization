
%% Load image
clc

% filename = '2024021_1.1.tif';
filename = 'total buffers.tif';
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


































