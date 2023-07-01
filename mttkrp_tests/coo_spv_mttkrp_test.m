%File to measure performance of COO using basic SPV MTTKRP. This takes an
%extremely long time, so this was avandoned.

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

%Set up Tensor Toolbox sptensor
X = read_coo("uber.txt");

NUMTRIALS = 1;
fileWrite = 1; %toggle writing to a file
time_mode = 1;
htns_elapsed = 0;
tt_elapsed = 0;
htns_cpu = 0;
tt_cpu = 0;

if fileWrite
    fileNameTrim = erase(file,".txt");
    fileID = strcat(fileNameTrim, '_mttkrp_avg.txt');
    fileID = fopen(fileID,'w');
    fprintf(fileID,"Reporting averages for MTTKRP for %s over all modes over %d trials.\n",file,NUMTRIALS);
end

%Set up U
N = size(X.size,2);
dimorder = 1:N;
Uinit = cell(N,1);

%this should correspond to the number of components in the decomposition
col_sz = 10; 

for n = 1:N
    Uinit{n} = rand(X.size(n),col_sz);
end

U = Uinit;

%Error check
%if (length(U) ~= N)
%    error('Cell array is the wrong length');
%end

for trials = 1:NUMTRIALS
    fprintf("Calculating COO MTTKRP\n");
    fprintf("Trial %d\n",trials);
    for n = 1:size(X.size,2)
        fprintf("Calc over mode %d\n",n);
        tStart = cputime;
        f = @() spv_coo_mttkrp(X,U,n); %<--matricize with respect to dimension i
        tt_elapsed = tt_elapsed + timeit(f);
        tEnd = cputime - tStart;
        tt_cpu = tt_cpu + tEnd;

    end
end

tt_elapsed = tt_elapsed/NUMTRIALS;
tt_cpu = tt_cpu/NUMTRIALS;
fprintf(fileID,"Average elapsed time using Tensor Toolbox: %f\n",tt_elapsed);
fprintf(fileID,"Average CPU time using Tensor Toolbox: %f\n",tt_cpu);

fclose(fileID);
