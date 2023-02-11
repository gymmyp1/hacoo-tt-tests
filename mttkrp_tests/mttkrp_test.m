%File to measure performance of HaCOO's MTTKRP function.

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab


NUMTRIALS = 10;
htns_elapsed = 0;
tt_elapsed = 0;
htns_cpu = 0;
tt_cpu = 0;
file = 'nips_hacoo.mat';
fileID = fopen('nips_mttkrp_avg.txt','w');
fprintf(fileID,"Reporting averages for MTTKRP for %s over all modes over %d trials.\n",file,NUMTRIALS);

%Load the tensor
T = load_htns(file);

%Set up Tensor Toolbox sptensor
table = readtable('nips.txt');
idx = table(:,1:end-1);
vals = table(:,end);
idx = table2array(idx);
vals = table2array(vals);
X = sptensor(idx,vals);

%Set up U
N = T.nmodes;
dimorder = 1:N;
Uinit = cell(N,1);

%this shold correspond to the number of components in the decomposition
col_sz = 50; 

for n = 1:N
    Uinit{n} = rand(T.modes(n),col_sz);
end

U = Uinit;

%Error check
%if (length(U) ~= N)
%    error('Cell array is the wrong length');
%end


for trials = 1:NUMTRIALS
    for n = 1:T.nmodes
        %HaCOO tests
        tStart = cputime;
        f = @() htns_coo_mttkrp(T,U,n); %<--matricize with respect to dimension n.
        %fprintf("Wall Clock time using HaCOO: ")
        temp = timeit(f);
        htns_elapsed = htns_elapsed + temp;

        %fprintf("Total CPU time using HaCOO: ")
        tEnd = cputime - tStart;
        htns_cpu = htns_cpu + tEnd;
    end


    for n = 1:T.nmodes
        %COO tests
        tStart = cputime;
        f = @() mttkrp(X,U,n); %<--matricize with respect to dimension i
        temp = timeit(f);
        tt_elapsed = tt_elapsed + temp;

        tEnd = cputime - tStart;
        tt_cpu = tt_cpu + tEnd;

    end
end


htns_elapsed = htns_elapsed/NUMTRIALS;
tt_elapsed = tt_elapsed/NUMTRIALS;

htns_cpu = htns_cpu/NUMTRIALS;
tt_cpu = tt_cpu/NUMTRIALS;

fprintf(fileID,"Averages calculated over %d trials.\n",NUMTRIALS);
fprintf(fileID,"Average elapsed time using HaCOO: %f\n",htns_elapsed);
fprintf(fileID,"Average CPU time using HaCOO: %f\n",htns_cpu);
fprintf(fileID,"Average elapsed time using Tensor Toolbox: %f\n",tt_elapsed);
fprintf(fileID,"Average CPU time using Tensor Toolbox: %f\n",tt_cpu);

fclose(fileID);