
clc

Data = [1 2 111 4 111 6 7 111 9 10];

Stencil = Data < 100;

Data_2 = Data(Stencil);


ind  = find(Data_2 == 4)

Initial_indexes = find(Stencil);

Initial_indexes(ind)


%%

clc

[row,col] = ind2sub([201 201], [98 98+201])


