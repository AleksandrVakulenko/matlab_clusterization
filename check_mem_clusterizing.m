

function check_mem_clusterizing(Data_size)

N = Data_size;
size_Gb = (0.5*N^2 * 4)/1024^3;

[~, systemview] = memory;
PM = systemview.PhysicalMemory;
Mem_av_Gb = PM.Available/1024^3;

if size_Gb > Mem_av_Gb*0.8
    error(['Out of memory:' newline 'Data size: ' num2str(size_Gb, '%0.2f')...
        ' Gb' newline 'Avalable: ' num2str(Mem_av_Gb, '%0.2f') ' Gb']);
end
end




