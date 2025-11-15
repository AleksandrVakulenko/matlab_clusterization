

function Mean_of_layer = find_mean_of_all_layers(Images)

clc
LN = size(Images{1, 1}, 3); % num of layers
N = size(Images, 1); % num of images

Mean_of_layer = zeros(LN, 1);
for i = 1:LN
    Full_layer_data = [];
    for im_ind = 1:N
        Image = Images{im_ind, 1}; % get j's image
        Stencil = Images{im_ind, 2}; % get its stencil
        Layer = Image(:, :, i); % get i's layer of j's image
        Layer = Layer(Stencil); % cut layer
        Full_layer_data = [Full_layer_data; Layer]; % append layer data
    end
    Mean_of_layer(i) = mean(Full_layer_data);
end


end
