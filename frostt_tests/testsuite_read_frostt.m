%testing out tensor toolbox's extract function

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

%Get the first line using fgetl to figure out how many modes
file = "lbnl-network.txt";
outFileName = strcat("frostt_results_",file);
outFile = fopen(outFileName,'w');
NUMTRIALS = 10;
NNZ = 10000; 
htns_elapsed = 0;
htns_cpu = 0;
tt_elapsed = 0;
tt_cpu = 0;

fprintf(outFile,"Reading first %d nonzeros.\n",NNZ);

fprintf("COO times:\n")
for i=1:NUMTRIALS
    [walltime,cpu_time] = time_read_frostt(file, NNZ, "sptensor")
    tt_elapsed = tt_elapsed + walltime;
    tt_cpu = tt_cpu + cpu_time;
    fprintf("Trial number: %d\n",i);
end

fprintf("HaCOO times:\n");
for i=1:NUMTRIALS
    [walltime,cpu_time] = time_read_frostt(file,NNZ,"htensor")
    htns_elapsed = htns_elapsed + walltime;
    htns_cpu = htns_cpu + cpu_time;
    fprintf("Trial number: %d\n",i);
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