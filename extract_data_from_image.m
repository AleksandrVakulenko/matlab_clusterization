function [Data, Initial_indexes] = extract_data_from_image(Image_Data, Stencil)

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

end