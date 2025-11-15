function Draw_image_layers(Images, Image_num)

Image_Data = Images{Image_num, 1};
Stencil = Images{Image_num, 2};

LN = size(Image_Data, 3);
if LN > 12
    error("more than 12 layers on image")
end

figure('Position', [510 100 768 550 ])
for i = 1:LN
    Layer = Image_Data(:, :, i);
    M = mean(Layer(Stencil), 'all');
    Layer(~Stencil) = M;

    subplot(3, 4, i);
    imagesc(Layer);
    axis equal
    colormap gray
    set(gca, 'YDir', 'normal')
    title(['Layer ' num2str(i)])
end

end