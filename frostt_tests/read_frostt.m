%read a frostt tensor line by line into a COO sptensor or
% HaCOO htensor data structure.

function [walltime,cpu_time] = read_frostt(varargin)
%% Set up params
params = inputParser;
params.addParameter('file','@',@isstring);
params.addParameter('format','@',@isstring);
params.parse(varargin{:});

%% Copy from params object
file = params.Results.file;
format = params.Results.format;

walltime = 0;
cpu_time = 0;

fid = fopen(file);
tline = fgetl(fid);hdr = fgetl(fid);
num = numel(regexp(hdr,' ','split'));

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

while ischar(tline)
    idx = str2num(tline);
    idx = idx(:,1:length(idx)-1); %trim the value

    tic
    tStart = cputime;

    if fmtNum == 2 %If using HaCOO format
        %Search if index already exists in tensor
        [k,j] = tns.search(idx);

        if j == -1 %if it doesnt exist yet, set new entry w/ value of 1
            tns.table{k} = {idx 1};
        else
            %else, update the entry's val
            tns.table{k}{j,2} = tns.table{k}{j,2} + 1;
            %fprintf('Existing entry has been updated.\n')
        end
    %If using COO format
    elseif fmtNum == 1
        %Check if this index is larger than the sptensor size
        updateModes = idx > size(tns);

        if any(updateModes) %if any index modes are larger, just insert
            tns(idx) = 1;
        else
            %update the entry's val
            tns(idx) = tns(idx) + 1;
        end
    end
    walltime = walltime + toc;
    tEnd = cputime - tStart;
    cpu_time = cpu_time + tEnd;
    tline = fgetl(fid); %get the next line

end

fclose(fid);
end
