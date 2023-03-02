%File to measure performance of HaCOO's MTTKRP function.

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab


NUMTRIALS = 10;
htns_elapsed = 0;
tt_elapsed = 0;
htns_cpu = 0;
tt_cpu = 0;
file = 'uber_hacoo.mat';
fileID = fopen('uber_mttkrp_avg.txt','w');
fprintf(fileID,"Reporting averages for MTTKRP for %s over all modes over %d trials.\n",file,NUMTRIALS);

%Load the tensor
T = load_htns(file);

%Set up Tensor Toolbox sptensor
idx= T.all_subs();
vals = T.all_vals();
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
        [walltime,cpu_time] = htns_coo_mttkrp(T,U,n); %<--matricize with respect to dimension n.
        htns_elapsed = htns_elapsed + walltime;
        htns_cpu = htns_cpu + cpu_time;
    end


    for n = 1:T.nmodes
        [walltime,cput_time] = mttkrp(X,U,n); %<--matricize with respect to dimension i
        tt_elapsed = tt_elapsed + walltime;
        tt_cpu = tt_cpu + cpu_time;

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