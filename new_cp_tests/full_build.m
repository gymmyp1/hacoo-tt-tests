% Timing how long it takes to build HaCOO/COO tensors, then perform CP ALS.
% After inserting all elements, HaCOO tensor gets written to file in COO
% format to use Tensor Toolbox's cp_als function.

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

NUMTRIALS = 1;
NNZ = 10000;
limit = 10000;


files = ["shuf_uber.txt"];

%files = ["shuf_uber.txt" "shuf_nell-2.txt" "shuf_enron.txt" "shuf_chicago.txt" "shuf_nips.txt" "shuf_lbnl.txt"];

while NNZ <= limit
    for f=1:length(files)
        htns_elapsed = 0;
        htns_cpu = 0;
        tt_elapsed = 0;
        tt_cpu = 0;
       
        file = files(f)
        outFileName = strcat(string(NNZ),"cp_results_",file);
        
        fprintf("HaCOO times:\n");
        
        %build the tensor from scratch and caluclate CP decomposition
        t = @() build_cp(file, NUMTRIALS, NNZ, "htensor");
        tStart = cputime;
        htns_elapsed = htns_elapsed + timeit(t);

        tEnd = cputime - tStart;
        htns_cpu = htns_cpu + tEnd;

        fprintf("COO times:\n")
        
        %same for Toolbox
        t = @() build_cp(file,NUMTRIALS,NNZ,"sptensor");
        tStart = cputime;
        tt_elapsed = tt_elapsed + timeit(t);

        tEnd = cputime - tStart; %stop timing cpu
        tt_cpu = tt_cpu + tEnd; %add to cumulative cpu time

        outFile = fopen(outFileName,'w');
        fprintf(outFile,"Reading first %d nonzeros.\n",NNZ);
       
        htns_elapsed = htns_elapsed/NUMTRIALS;
        htns_cpu = htns_cpu/NUMTRIALS;
        tt_elapsed= tt_elapsed/NUMTRIALS;
        tt_cpu = tt_cpu/NUMTRIALS;

        fprintf(outFile,"Averages calculated over %d trials.\n",NUMTRIALS);        
        fprintf(outFile,"Average elapsed time using HaCOO: %f\n",htns_elapsed);
        fprintf(outFile,"Average CPU time using HaCOO: %f\n",htns_cpu);
        fprintf(outFile,"Average elapsed time using Tensor Toolbox: %f\n",tt_elapsed);
        fprintf(outFile,"Average CPU time using Tensor Toolbox: %f\n",tt_cpu);

        fclose(outFile);
    end
    NNZ = NNZ * 10;
end