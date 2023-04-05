%Test to measure overhead of converting HaCOO tensor to COO tensor.

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab


NUMTRIALS = 1;
fileWrite = 1; %toggle writing to a file
htns_elapsed = 0;
tt_elapsed = 0;
htns_cpu = 0;
tt_cpu = 0;
file = 'uber_hacoo.mat';

if fileWrite
    fileID = fopen('4.5_convert_uber.txt','w');
    fprintf(fileID,"Reporting averages for converting %s HaCOO tensor to COO over %d trials.\n",file,NUMTRIALS);
end

%Load the tensor
H = load_htns(file);

for trials = 1:NUMTRIALS
        tic
        tStart = cputime;
        HS = sptensor(H.all_subs(),H.all_vals());
        htns_elapsed = htns_elapsed + toc;
        tEnd = cputime - tStart;
        htns_cpu = htns_cpu + tEnd;
end

htns_elapsed = htns_elapsed/NUMTRIALS;
htns_cpu = htns_cpu/NUMTRIALS;

if fileWrite
    fprintf(fileID,"Averages calculated over %d trials.\n",NUMTRIALS);
    fprintf(fileID,"Average elapsed time using HaCOO: %f\n",htns_elapsed);
    fprintf(fileID,"Average CPU time using HaCOO: %f\n",htns_cpu);
    fclose(fileID);
end