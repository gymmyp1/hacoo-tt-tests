%{
Function to time how long it takes to build a COO tensor line by line
    Parameters:
        file - COO file to read from
        nnz - number of nonzeros to read (since doing this for all nnz takes
        a LONG time
        outFile - file to save results to
%}
function [walltime, cpu_time] = time_read_frostt(file, nnz, format)

walltime = 0;
cpu_time = 0;

%Get the first line using fgetl to figure out how many modes
fid = fopen(file,'rt');
hdr = fgetl(fid);
num = numel(regexp(hdr,' ','split'));
fmt = repmat('%d',1,num);
sizeA = [num Inf];
tdata = fscanf(fid,fmt,sizeA);
tdata = tdata';
fclose(fid);

idx = tdata(:,1:num-1);
vals = tdata(:,end);

%Check if tensor format is valid
if strcmp(format,"sptensor")
    fmtNum = 1;
    tns = sptensor(ones(1,num-1));
elseif strcmp(format,"htensor")
    fmtNum = 2;
    tns = htensor();
else
    printf("Tensor format invalid.\n");
    return
end

%iterate over each idx and insert
for i=1:nnz
    tic
    tStart = cputime;

    %If using COO format
    if fmtNum == 1
        tns(idx) = vals(i);
    elseif fmtNum == 2 %If using HaCOO format
        %Search if index already exists in tensor
        [k,j] = tns.search(idx);

        %if j == -1 %if it doesnt exist yet, set new entry w/ value of 1
            tns.table{k} = {idx 1};
        %else (This is commented out b/c COO assumes no duplicate indices
            %else, update the entry's val
            %tns.table{k}{j,2} = tns.table{k}{j,2} + 1;
            %fprintf('Existing entry has been updated.\n')
        %end
    end
    walltime = walltime + toc;
    tEnd = cputime - tStart;
    cpu_time = cpu_time + tEnd;
end