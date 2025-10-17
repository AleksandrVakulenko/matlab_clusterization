


rng(0,"twister") % For reproducibility
X = rand(30000, 12);

tic

Z = linkage(X, "ward");



c = cluster(Z, Cutoff=0.1);
% scatter(X(:,1), X(:,2), 10, c)


toc

%%


Clasters = unique(c);


for i = 1:numel(Clasters)

Bin{i} = find(c == Clasters(i));



end





