function Common_data = create_common_data(Cell, num)

Common_data = [];
for i = 1:numel(Cell)
    if i ~= num
        Common_data = [Common_data; Cell{i}];
    end
end

end