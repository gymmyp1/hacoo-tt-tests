% Timing how long it takes to build HaCOO/COO tensors, then perform CP ALS.
% After inserting all elements, HaCOO tensor gets written to file in COO
% format to use Tensor Toolbox's cp_als function.

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

%files = ["shuf_uber.txt" "shuf_nell-2.txt" "shuf_enron.txt" "shuf_chicago.txt" "shuf_nips.txt" "shuf_lbnl.txt"];
%going to try this on only one tensor at a time...

NUMTRIALS = 10;
NNZ = 10000;
limit = 100000;
file = 'uber.txt';
shufFile = strcat('shuf_',file);

while NNZ < limit

        
        outFileName = strcat(string(NNZ),"cp_results_",file);
        outFile = fopen(outFileName,'w');
        
        htns_elapsed = 0;
        htns_cpu = 0;
        tt_elapsed = 0;
        tt_cpu = 0;

        fprintf(outFile,"Reading first %d nonzeros.\n",NNZ);

        fprintf("COO times:\n")
        for i=1:NUMTRIALS
            fprintf("Trial number: %d\n",i);
            tic
            tStart = cputime;
            %build the tensor from scratch
            read_export(file, NNZ, "sptensor");

            %read the tensor and make it in MATLAB
            coo_tns = read_coo(file);
            %run Toolbox's CP ALS algorithm with 50 components
            cp_als(coo_tns, 50);

            tt_elapsed = tt_elapsed + toc;
            tEnd = cputime - tStart;
            tt_cpu = tt_cpu + tEnd;
        end

        fprintf("HaCOO times:\n");
        for i=1:NUMTRIALS
            fprintf("Trial number: %d\n",i);
            tic
            tStart = cputime;
            %build the tensor from scratch
            read_export(file, NNZ, "htensor");

            %read the tensor and make it in MATLAB
            hacoo_tns = read_coo(shufFile);
            %run Toolbox's CP ALS algorithm with 50 components
            cp_als(hacoo_tns, 50);

            htns_elapsed = htns_elapsed + toc;
            tEnd = cputime - tStart;
            htns_cpu = htns_cpu + tEnd;
        end


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
    NNZ = NNZ * 10;
end