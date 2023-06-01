%File to measure performance of HaCOO's MTTKRP function.

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

file = "uber.txt";
T = read_htns(file);

%will need to create new mat files since table struct changed
%file = 'uber_hacoo.mat';
%file = 'enron_hacoo.mat';
%Load the tensor
%T = load_htns(file);

NUMTRIALS = 1;
fileWrite = 1; %toggle writing to a file
htns_elapsed = 0;
tt_elapsed = 0;
htns_cpu = 0;
tt_cpu = 0;

if fileWrite
    fileNameTrim = erase(file,".mat");
    fileID = strcat(fileNameTrim, '_mttkrp_avg.txt');
    fileID = fopen(fileID,'w');
    fprintf(fileID,"Reporting averages for MTTKRP for %s over all modes over %d trials.\n",file,NUMTRIALS);
end

%Set up Tensor Toolbox sptensor
table = readtable('uber.txt');
idx = table(:,1:end-1);
vals = table(:,end);
idx = table2array(idx);
vals = table2array(vals);
X = sptensor(idx,vals);

%Set up U
N = T.nmodes;
dimorder = 1:N;
Uinit = cell(N,1);

%this should correspond to the number of components in the decomposition
col_sz = 10; 

for n = 1:N
    Uinit{n} = rand(T.modes(n),col_sz);
end

U = Uinit;

%Error check
%if (length(U) ~= N)
%    error('Cell array is the wrong length');
%end

for trials = 1:NUMTRIALS
    fprintf("Calculating HaCOO MTTKRP\n");
    fprintf("Trial %d\n",n);
    for n = 1:T.nmodes
        fprintf("Calc over mode %d\n",n);
        tStart = cputime;
        f = @() spv_htns_mttkrp(T,U,n); %<--matricize with respect to dimension n.
        htns_elapsed = htns_elapsed + timeit(f);
        tEnd = cputime - tStart;
        htns_cpu = htns_cpu + tEnd;
    end
end

htns_elapsed = htns_elapsed/NUMTRIALS;
htns_cpu = htns_cpu/NUMTRIALS;
fprintf(fileID,"Averages calculated over %d trials.\n",NUMTRIALS);
fprintf(fileID,"Average elapsed time using HaCOO: %f\n",htns_elapsed);
fprintf(fileID,"Average CPU time using HaCOO: %f\n",htns_cpu);

for trials = 1:NUMTRIALS
    fprintf("Calculating COO MTTKRP\n");
    fprintf("Trial %d\n",n);
    for n = 1:T.nmodes
        fprintf("Calc over mode %d\n",n);
        tStart = cputime;
        f = @() mttkrp(X,U,n); %<--matricize with respect to dimension i
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
