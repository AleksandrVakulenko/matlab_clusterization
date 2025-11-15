function [Data_sparse, Rand_index_out] = sparse_data(Data, Clasters, Initial_indexes, Part_size)

c_un = unique(Clasters);
N = numel(c_un);

Data_sparse = [];
Rand_index_out = [];
for i = 1:N
    range = Clasters == i;

    
    Data_at_cluster = Data(range, :);
    Initial_indexes_at_cluster = Initial_indexes(range);
    Data_at_cluster_size = size(Data_at_cluster, 1);

    Rand_index = randperm(Data_at_cluster_size);
    Number_of_sparse_data = ceil(Data_at_cluster_size*Part_size);
    Rand_index(Number_of_sparse_data+1:end) = [];

%     disp(['   ' num2str(Number_of_sparse_data)])

    Data_at_cluster_sparse = Data_at_cluster(Rand_index, :);
    Initial_indexes_at_cluster_sparse = Initial_indexes_at_cluster(Rand_index);
    Data_sparse = [Data_sparse; Data_at_cluster_sparse];
    Rand_index_out = [Rand_index_out; Initial_indexes_at_cluster_sparse];
end

end