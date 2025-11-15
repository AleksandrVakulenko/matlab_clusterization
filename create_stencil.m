% Stencil is equal to true there no one of pixel layers is not zero

% function Stencil = create_stencil(Image_Data)
%     
%     Stencil = false(size(Image_Data, [1,2]));
%     for i = 1:size(Image_Data, 3)
%         Layer = Image_Data(:, :, i);
%     
%         range = Layer ~= 0;
% %         M = mean(Layer(range));
% %         Layer(~range) = M;
% %         Image_Data(:, :, i) = Layer;
%     
%         Stencil(range) = true;
%     end
% 
% end

function Stencil = create_stencil(Image_Data)
    
    Stencil = true(size(Image_Data, [1,2]));
    for i = 1:size(Image_Data, 3)
        Layer = Image_Data(:, :, i);
    
        range = Layer == 0;
%         M = mean(Layer(range));
%         Layer(~range) = M;
%         Image_Data(:, :, i) = Layer;
    
        Stencil(range) = false;
    end

end