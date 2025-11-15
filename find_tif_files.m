function names_out = find_tif_files(folder_name)

% find all *.mat files in folder
content = {dir(folder_name).name};
if isempty(content)
    error(['Wrong path: "' folder_name '"'])
end
content(1:2) = [];
names = string(content);


is_tif = strfind(names, ".tif");
if class(is_tif) ~= "cell" % NOTE: case of single file
    is_tif = {is_tif};
end
is_tif = ~cellfun(@isempty, is_tif);
names = names(is_tif);


range = false(size(names));
for i = 1:numel(names)
    disp([num2str(i) '/' num2str(numel(names)) ' : ' char(names(i))]);
    full_path = [char(folder_name) '/' char(names(i))];
    filename = names(i);
    names_out(i).full_path = full_path;
    names_out(i).filename = filename;
end

end