%Timing updates for FROSTT tesnors

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

files = ["uber.txt" "nell-2.txt" "enron.txt" "chicago.txt" "nips.txt" "lbnl-network.txt"];

NNZ = 1000;
while NNZ < 10000000
    for f=1:length(files)

        %Get the first line using fgetl to figure out how many modes
        file = files(f)
        outFileName = strcat(string(NNZ),"frostt_results_",file);
        outFile = fopen(outFileName,'w');
        NUMTRIALS = 10;
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
        end

        fprintf("HaCOO times:\n");
        for i=1:NUMTRIALS
            fprintf("Trial number: %d\n",i);
            [walltime,cpu_time] = time_read_frostt(file,NNZ,"htensor");
            htns_elapsed = htns_elapsed + walltime;
            htns_cpu = htns_cpu + cpu_time;
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