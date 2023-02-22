% Report time required to update a sparse tensor by reading FROSTT data
% line by line.

function [walltime,cputime] = read_frostt(filename)

fid = fopen(filename);
tline = fgetl(fid);
while ischar(tline)
    disp(tline)
    tline = fgetl(fid);
end
fclose(fid);

end