function Clasters = sort_clasters(Clasters)

    c_un = unique(Clasters);
    N = numel(c_un);
    Free_number = N+1;
    
    Claster_sizes = find_claster_sizes(Clasters);
    [~, ind] = sort(Claster_sizes);
    
    for i = 1:N
        %disp(['Swap (' num2str(i) ') - (' num2str(ind(i)) ')'])
        range = Clasters == ind(i);
        Clasters(range) = Free_number + i;
    end
    Clasters = Clasters - Free_number;

end