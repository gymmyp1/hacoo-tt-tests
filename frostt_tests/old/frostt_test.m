%Test for timing frostt tensors

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

file = "uber.txt";
outFileName = strcat("frostt_",file);
outFile = fopen(outFileName,'w');
NUMTRIALS = 1;
htns_elapsed = 0;
htns_cpu = 0;
tt_elapsed = 0;
tt_cpu = 0;
walltime = 0;
cpu_time = 0;

fprintf("HaCOO times:\n");
for i=1:NUMTRIALS
    [walltime,cpu_time] = read_frostt('file', file,'format',"htensor")
    tt_elapsed = tt_elapsed + walltime;
    tt_cpu = tt_cpu + cpu_time;
end

fprintf("COO times:\n")
for i=1:NUMTRIALS
    [walltime,cpu_time] = read_frostt('file', file,'format',"sptensor")
    tt_elapsed = tt_elapsed + walltime;
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
    