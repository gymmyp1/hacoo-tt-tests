% Timing how long it takes to build HaCOO/COO tensors, then perform CP ALS.
%Tensor Toolbox uses their methods, HaCOO uses its methods.

function build_cp(file, num_trials, nnz, format)

NUMTRIALS = num_trials;
NNZ = nnz;

%Check if tensor format is valid
if strcmp(format,"sptensor") || strcmp(format,"coo")
    fmtNum = 1;
elseif strcmp(format,"htensor") || strcmp(format,"hacoo")
    fmtNum = 2;
else
    printf("Tensor format invalid.\n");
    return
end

if fmtNum == 2
    for i=1:NUMTRIALS
        fprintf("Trial number: %d\n",i);

        %build the tensor from scratch, write COO file
        t = build_tensor(file, NNZ, "htensor");

        %run HaCOO's CP ALS algorithm with 50 components
        htns_cp_als(t, 50);
    end
end

if fmtNum == 1
    for i=1:NUMTRIALS
        fprintf("Trial number: %d\n",i);

        t = build_tensor(file, NNZ, "sptensor");

        %run Toolbox's CP ALS algorithm with 50 components
        cp_als(t, 50);
    end
end


end