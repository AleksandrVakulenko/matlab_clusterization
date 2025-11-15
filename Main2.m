
clc
load('save2.mat')
% Images2(:, 4) = [];

%%

% Original images in col 1 of Images2 cell
% Claster numbers in col 2 of Images2 cell
% Initial_indexes in col 3 of Images2 cell


%%

imN = size(Images2, 1);

k = 0;
Final_table = zeros(1, 14);
for Image_num = 1:1%:imN
    
    Image = Images2{Image_num, 1};
    Clusters = Images2{Image_num, 2};
    Initial_indexes = Images2{Image_num, 3};
    
    uC = unique(Clusters);

    Layer_mean = [];
    for j = 1:numel(uC)
        Cluster_num = uC(j);
        ind = Clusters == Cluster_num;
        Initial_indexes_at_cluster = Initial_indexes(ind);
        
        Layer_part = [];
        for iL = 1:12
            Layer = Image(:, :, iL);
            Layer_part(:, iL) = Layer(Initial_indexes_at_cluster);
            
%             if iL == 1
%                 Stencil = Images{Image_num, 2};
%                 Layer2print = Layer;
%                 M = mean(Layer2print(Stencil));
%                 Layer2print(~Stencil) = M;
%                 Layer2print(Initial_indexes_at_cluster) = 0;
%                 imagesc(Layer2print)
%                 title([num2str(j) ' ' num2str(iL)])
%                 drawnow
%                 pause(0.75)
%             end
        end
        Layer_mean(j, :) = mean(Layer_part, 1);

        k = k + 1;
        Final_table(k, 1) = Image_num;
        Final_table(k, 2) = j;
        Final_table(k, 3:3+12-1) = Layer_mean(j, :);
    end

end

%% Cluster rename

clc

Data = Final_table(:, 3:14);

Linkage_data = linkage(Data, "ward");


% cutoff = median([Linkage_data(end-9,3) Linkage_data(end-8,3)]);
% dendrogram(Linkage_data,ColorThreshold=cutoff)
dendrogram(Linkage_data)

%%


% Data = [0.0, 0.0
%         2.0, 0.0
%         0.0, 1.0
%         2.0, 1.1
%         0.5, 0.5];

% Data = [0.0, 0.0
%         1.0, 0.0
%         0.0, 1.0
%         1.0, 1.0];

Data = [0.0, 0.0
        0.1, 0.0
        0.0, 0.1
        0.05, 0
        0.0, 0.05
        1.0, 0.0
        2.0, 0.0];

Linkage_data = linkage(Data, "weighted");



dendrogram(Linkage_data)


%%

clc
Delta = zeros(124, 124);
for i = 1:size(Final_table, 1)
for j = 1:size(Final_table, 1)
vec1 = Final_table(i, 3:14);
vec2 = Final_table(j, 3:14);
% vec1 = Data(i, :);
% vec2 = Data(j, :);

Delta(i,j) = sqrt(sum((vec1-vec2).^2));


end
end

%%

figure
imagesc(Delta)

max(Delta, [], 'all')
