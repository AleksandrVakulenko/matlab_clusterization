function plot_clasters_sizes(Clasters)
    Claster_sizes = find_claster_sizes(Clasters);
    bar(Claster_sizes);
end