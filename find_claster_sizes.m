function Claster_sizes = find_claster_sizes(Clasters)
    
    c_un = unique(Clasters);
    N = numel(c_un);
    
    Claster_sizes = zeros(1, N);
    for i = 1:N
        Claster_sizes(i) = numel(find(Clasters == c_un(i)));
    end

end