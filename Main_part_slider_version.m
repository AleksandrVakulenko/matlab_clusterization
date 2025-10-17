






%%

figure


slider = uicontrol('style','slider')

Hsize = 400;
slider.InnerPosition = [20 20 Hsize 20];



while true

    NN = round(slider.Value*20)+1;

Clasters = cluster(Z, maxclust=NN);


c_un = unique(Clasters);
N = numel(c_un);
Free_number = N+1;

Claster_sizes = zeros(1, N);
for i = 1:N
    Claster_sizes(i) = numel(find(Clasters == c_un(i)));
end

[~, ind] = sort(Claster_sizes);

% range = zeros(N, N);
for i = 1:N
%     disp(['Swap (' num2str(i) ') - (' num2str(ind(i)) ')'])

%     range_1 = Clasters == i;
    range_2 = Clasters == ind(i);
%     Clasters(range_1) = ind(i);
    Clasters(range_2) = Free_number + i;

end
Clasters = Clasters - Free_number;

for i = 1:N
    Claster_sizes(i) = numel(find(Clasters == c_un(i)));
end








Bin = {};
for i = 1:numel(c_un)

    Bin{i} = find(Clasters == c_un(i));

end


N = numel(Bin);
Image_c = zeros(Initial_sz1, Initial_sz2);
for i = 1:numel(Bin)
    
    ind = Bin{i};
    ind = Initial_indexes(ind);
    Image_c(ind) = i;

end

imagesc(Image_c)
axis equal
set(gca, 'YDir', 'normal')
caxis([0.9 N])
set(gca, 'Colormap', load_colormap())
title(num2str(NN))
drawnow
end
%% Claster stat


Number = zeros(1, numel(Bin));
for i = 1:numel(c_un)
    Number(i) = numel(Bin{i});
end


stem(Number)










