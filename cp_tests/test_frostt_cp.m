%Timing updates for FROSTT tesnors

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

files = ["shuf_uber.txt" "shuf_nell-2.txt" "shuf_enron.txt" "shuf_chicago.txt" "shuf_nips.txt" "shuf_lbnl.txt"];

NUMTRIALS = 10;
NNZ = 75000;
limit = NNZ;

while NNZ <= limit
    for f=1:length(files)
        
        %Get the first line using fgetl to figure out how many modes
        file = files(f)
        cooFile = erase(file, ".txt");
        cooFile = strcat(cooFile,'_coo.txt');
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
            [walltime,cpu_time] = time_read_frostt(file, NNZ, "sptensor");
            tt_elapsed = tt_elapsed + walltime;
            tt_cpu = tt_cpu + cpu_time;
            
            %make a COO tensor from the file we just wrote
            [tns,walltime,cpu_time] = read_coo(cooFile);

            %run Toolbox's CP ALS algorithm with 50 components
            func = @()cp_als(tns, 50);
            
            tt_elapsed = tt_elapsed + timeit(func);
            tt_cpu = tt_cpu + cpu_time;
        end

        fprintf("HaCOO times:\n");
        for i=1:NUMTRIALS
            fprintf("Trial number: %d\n",i);
            [walltime,cpu_time] = time_read_frostt(file,NNZ,"htensor");
            htns_elapsed = htns_elapsed + walltime;
            htns_cpu = htns_cpu + cpu_time;

            %make a COO tensor from the file we just wrote
            [tns,walltime,cpu_time] = read_coo(cooFile);

            %run Toolbox's CP ALS algorithm with 50 components
            func = @()cp_als(tns, 50);
            
            tt_elapsed = tt_elapsed + timeit(func);
            tt_cpu = tt_cpu + cpu_time;
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

    end
    NNZ = NNZ * 10
end