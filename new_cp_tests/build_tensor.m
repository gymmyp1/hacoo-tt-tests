%{
Function to build a HaCOO/COO tensor line by line.
    Parameters:
        file - COO file to read from
        nnz - number of nonzeros to read (since doing this for all nnz takes
        a LONG time
        format - the format of tensor you want to build (sptensor,htensor)
    Returns:
        t - Built COO/HaCOO tensor

%}
function t = build_tensor(file,nnz,format)

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

frewind(fid); %put first line back
sizeA = [num nnz]; %for larger tensors, limit the number of nnz
tdata = fscanf(fid,fmt,sizeA);
tdata = tdata';
fclose(fid);

idx = tdata(:,1:num-1);
vals = tdata(:,end);

%Check if tensor format is valid
if strcmp(format,"sptensor")
    fmtNum = 1;
    t = sptensor(ones(1,num-1));
elseif strcmp(format,"htensor")
    fmtNum = 2;
    t = htensor();
else
    printf("Tensor format invalid.\n");
    return
end

for i=1:size(idx,1)
    %iterate over each idx and insert
    if fmtNum == 1
        t(idx(i,:)) = vals(i); %if using COO format
    elseif fmtNum == 2 %If using HaCOO format
        t = t.set(idx(i,:),vals(i));
    end
end
