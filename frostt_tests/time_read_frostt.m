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

if strcmp(file,"shuf_enron.txt") || strcmp(file,"shuf_nell-2.txt") || strcmp(file,"shuf_lbnl.txt")
    fmt = repmat('%d',1,num-1); %to read files with decimal values (enron, nell-2,lbnl)
    fmt = strcat(fmt,'%f');
else
    fmt = repmat('%d',1,num); %to read files with no decimal values
end

%sizeA = [num Inf];
sizeA = [num nnz]; %for larger tensors
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
        tns(idx(i,:)) = vals(i);
    elseif fmtNum == 2 %If using HaCOO format
        tns = tns.set(idx(i,:),vals(i));
    end
    walltime = walltime + toc;
    tEnd = cputime - tStart;
    cpu_time = cpu_time + tEnd;
end