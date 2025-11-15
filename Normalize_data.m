function Images = Normalize_data(Images, Mean_of_layer)

clc
LN = size(Images{1, 1}, 3); % num of layers
N = size(Images, 1); % num of images

for im_ind = 1:N
    Image = Images{im_ind, 1};
    Stencil = Images{im_ind, 2};

    for i = 1:LN
        Layer = Image(:, :, i);
        Layer(Stencil) = Layer(Stencil)/Mean_of_layer(i);
        Image(:, :, i) = Layer;
    end

    Images{im_ind, 1} = Image;
end

end