function Data_sparse = sparse_data(Data, Clasters, Part_size)

c_un = unique(Clasters);
N = numel(c_un);

Data_sparse = [];
for i = 1:N
    range = Clasters == i;

    
    Data_part = Data(range, :);
    Data_part_size = size(Data_part, 1);

    Rand_index = randperm(Data_part_size);
    Number_of_sparse_data = ceil(Data_part_size*Part_size);
    Rand_index(Number_of_sparse_data+1:end) = [];

    Data_part_sparse = Data_part(Rand_index, :);
    Data_sparse = [Data_sparse; Data_part_sparse];
end

end