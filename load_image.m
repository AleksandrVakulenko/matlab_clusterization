

function [Image_Data, Tiff_obj] = load_image(filename)

disp(['Opening: '  filename newline 'in progress ...'])

Tiff_obj = Tiff(filename);

tic
Image_Data = read(Tiff_obj);
Time = toc;

disp(['File ready (' num2str(Time, '%0.2f') ' s).' newline]);

end
