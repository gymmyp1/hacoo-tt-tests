% Timing how long it takes to build HaCOO/COO tensors, then perform CP ALS.
% After inserting all elements, HaCOO tensor gets written to file in COO
% format to use Tensor Toolbox's cp_als function.

function build_cp(file, num_trials, nnz, format)

NUMTRIALS = num_trials;
NNZ = nnz;

%Check if tensor format is valid
if strcmp(format,"sptensor") || strcmp(format,"coo")
    fmtNum = 1;
elseif strcmp(format,"htensor") || strcmp(format,"hacoo")
    fmtNum = 2;
    cooFile = erase(file, ".txt");
    cooFile = strcat(cooFile,'_coo.txt');
else
    printf("Tensor format invalid.\n");
    return
end

if fmtNum == 2
    fprintf("HaCOO times:\n");
    for i=1:NUMTRIALS
        fprintf("Trial number: %d\n",i);

        %build the tensor from scratch, write COO file
        read_export(file, NNZ, "htensor");

        %make a COO tensor from the file we just wrote
        t = read_coo(cooFile);

        %run Toolbox's CP ALS algorithm with 50 components
        cp_als(t, 50);
    end
end

if fmtNum == 1
    fprintf("COO times:\n")
    for i=1:NUMTRIALS
        fprintf("Trial number: %d\n",i);

        t = read_export(file, NNZ, "sptensor");

        %run Toolbox's CP ALS algorithm with 50 components
        cp_als(t, 50);
    end
end


end