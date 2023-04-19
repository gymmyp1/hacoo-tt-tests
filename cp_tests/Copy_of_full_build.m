% Timing how long it takes to build HaCOO/COO tensors, then perform CP ALS.
% After inserting all elements, HaCOO tensor gets written to file in COO
% format to use Tensor Toolbox's cp_als function.

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

%files = ["shuf_uber.txt" "shuf_nell-2.txt" "shuf_enron.txt" "shuf_chicago.txt" "shuf_nips.txt" "shuf_lbnl.txt"];
%going to try this on only one tensor at a time...

NUMTRIALS = 1;
NNZ = 10000;
%limit = 1000000;
limit = NNZ;
file = 'shuf_uber.txt';
%file = 'shuf_nips.txt';
%files = ["shuf_uber.txt" "shuf_nell-2.txt" "shuf_enron.txt" "shuf_chicago.txt" "shuf_nips.txt" "shuf_lbnl.txt"];
cooFile = erase(file, ".txt");
cooFile = strcat(cooFile,'_coo.txt');

while NNZ <= limit
    %for f=1:length(files)
        %file = files(f);
        outFileName = strcat(string(NNZ),"cp_results_",file);
        outFile = fopen(outFileName,'w');

        htns_elapsed = 0;
        htns_cpu = 0;
        tt_elapsed = 0;
        tt_cpu = 0;

        fprintf(outFile,"Reading first %d nonzeros.\n",NNZ);

        fprintf("HaCOO times:\n");
        for i=1:NUMTRIALS
            fprintf("Trial number: %d\n",i);

            tStart = cputime;
            
            %build the tensor from scratch, write COO file
            f = @() read_export(file, NNZ, "htensor");
            htns_elapsed = htns_elapsed + timeit(f);
            
            tEnd = cputime - tStart;
            htns_cpu = htns_cpu + tEnd;

            %time the function but stop timing cpu time until we get to
            %next step
            f = @() read_coo(cooFile);
            
            tStart = cputime;
            htns_elapsed = htns_elapsed + timeit(f);

            %make a COO tensor from the file we just wrote
            tns = read_coo(cooFile);
            
            %run Toolbox's CP ALS algorithm with 50 components
            f = @() cp_als(tns, 50);
            htns_elapsed = htns_elapsed + timeit(f);
            tEnd = cputime - tStart;
            htns_cpu = htns_cpu + tEnd;
        end

        fprintf(outFile,"Averages calculated over %d trials.\n",NUMTRIALS);
        htns_elapsed = htns_elapsed/NUMTRIALS;
        htns_cpu = htns_cpu/NUMTRIALS;
        fprintf(outFile,"Average elapsed time using HaCOO: %f\n",htns_elapsed);
        fprintf(outFile,"Average CPU time using HaCOO: %f\n",htns_cpu);

        fprintf("COO times:\n")
        for i=1:NUMTRIALS
            fprintf("Trial number: %d\n",i);
            
            tStart = cputime;   %start timimg cpu
        
            f = @() read_export(file, NNZ, "sptensor");
            tt_elapsed = tt_elapsed + timeit(f);
            tEnd = cputime - tStart; %end timing cpu
            tt_cpu = tt_cpu + tEnd;

            %----------- don't time this
            %build the tensor from scratch
            coo_tns = read_export(file, NNZ, "sptensor");
            %-----------
            tStart = cputime; %start timing cpu again

            %run Toolbox's CP ALS algorithm with 50 components
            f = @() cp_als(coo_tns, 50); %time function
            tt_elapsed = tt_elapsed + timeit(f);
            %-------------
            tEnd = cputime - tStart; %stop timing cpu
            tt_cpu = tt_cpu + tEnd; %add to cumulative cpu time
        end

        tt_elapsed= tt_elapsed/NUMTRIALS;
        tt_cpu = tt_cpu/NUMTRIALS;

        
        fprintf(outFile,"Average elapsed time using Tensor Toolbox: %f\n",tt_elapsed);
        fprintf(outFile,"Average CPU time using Tensor Toolbox: %f\n",tt_cpu);

        fclose(outFile);
    %end
    NNZ = NNZ * 10;
end