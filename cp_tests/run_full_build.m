% Timing how long it takes to build HaCOO/COO tensors, then perform CP ALS.
% After inserting all elements, HaCOO tensor gets written to file in COO
% format to use Tensor Toolbox's cp_als function.

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

NUMTRIALS = 10;
NNZ = 50000;
limit = 50000;

files = ["shuf_uber.txt" "shuf_nell-2.txt" "shuf_enron.txt" "shuf_chicago.txt" "shuf_nips.txt" "shuf_lbnl.txt"];

while NNZ <= limit
    for f=1:length(files)
        htns_elapsed = 0;
        htns_cpu = 0;
        tt_elapsed = 0;
        tt_cpu = 0;
       
        file = files(f)
        outFileName = strcat(string(NNZ),"cp_results_",file);
        outFile = fopen(outFileName,'w');

        fprintf(outFile,"Reading first %d nonzeros.\n",NNZ);

        fprintf("HaCOO times:\n");

        tStart = cputime;
        %build the tensor from scratch, write COO file
        t = @() build_cp(file, NUMTRIALS, NNZ, "htensor");
        htns_elapsed = htns_elapsed + timeit(t);

        tEnd = cputime - tStart;
        htns_cpu = htns_cpu + tEnd;


        fprintf(outFile,"Averages calculated over %d trials.\n",NUMTRIALS);
        htns_elapsed = htns_elapsed/NUMTRIALS;
        htns_cpu = htns_cpu/NUMTRIALS;
        fprintf(outFile,"Average elapsed time using HaCOO: %f\n",htns_elapsed);
        fprintf(outFile,"Average CPU time using HaCOO: %f\n",htns_cpu);

        fprintf("COO times:\n")
        tStart = cputime;   %start timimg cpu

        %run Toolbox's CP ALS algorithm with 50 components
        t = @() build_cp(file,NUMTRIALS,NNZ,"sptensor");
        tt_elapsed = tt_elapsed + timeit(t);

        tEnd = cputime - tStart; %stop timing cpu
        tt_cpu = tt_cpu + tEnd; %add to cumulative cpu time

        %tt_elapsed= tt_elapsed/NUMTRIALS;
        %tt_cpu = tt_cpu/NUMTRIALS;


        fprintf(outFile,"Average elapsed time using Tensor Toolbox: %f\n",tt_elapsed);
        fprintf(outFile,"Average CPU time using Tensor Toolbox: %f\n",tt_cpu);

        fclose(outFile);
    end
    NNZ = NNZ * 10;
end