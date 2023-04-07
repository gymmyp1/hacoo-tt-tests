%File to measure performance of HaCOO's MTTKRP function.

%addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

%file = "uber_trim.txt";
%T = read_htns(file);

file = 'uber_hacoo.mat';
%Load the tensor
T = load_htns(file);

NUMTRIALS = 1;
fileWrite = 1; %toggle writing to a file
htns_elapsed = 0;
tt_elapsed = 0;
htns_cpu = 0;
tt_cpu = 0;
<<<<<<< HEAD

outFileName = strcat("mttkrp_avg_",file);
fileID = fopen(outFileName,'w');
fprintf(fileID,"Reporting averages for MTTKRP for %s over all modes over %d trials.\n",file,NUMTRIALS);


%Set up Tensor Toolbox sptensor
table = readtable('uber.txt');
idx = table(:,1:end-1);
vals = table(:,end);
idx = table2array(idx);
vals = table2array(vals);
=======
file = 'uber_hacoo.mat';

if fileWrite
    fileID = fopen('4.5_uber_mttkrp_avg.txt','w');
    fprintf(fileID,"Reporting averages for MTTKRP for %s over all modes over %d trials.\n",file,NUMTRIALS);
end

%Load the tensor
H = load_htns(file);

%Set up Tensor Toolbox sptensor
idx= T.all_subs();
vals = T.all_vals();
>>>>>>> b0e4af59d2ca45f2f67061beb96a85b4f5f79ce4
X = sptensor(idx,vals);

%Set up U
N = T.nmodes;
dimorder = 1:N;
Uinit = cell(N,1);

%this shold correspond to the number of components in the decomposition
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
<<<<<<< HEAD
    fprintf("Calculating HaCOO MTTKRP\n");
=======
    HS = sptensor(H.all_subs(),H.all_vals());
>>>>>>> b0e4af59d2ca45f2f67061beb96a85b4f5f79ce4
    for n = 1:T.nmodes
        fprintf("Trial %d",n);

        tStart = cputime;
<<<<<<< HEAD
        f = @() htns_mttkrp(T,U,n); %<--matricize with respect to dimension n.
        temp = timeit(f);
        htns_elapsed = htns_elapsed + temp;
=======
        f = @() htns_coo_mttkrp(HS,U,n); %<--matricize with respect to dimension n.
        htns_elapsed = htns_elapsed + timeit(f);
>>>>>>> b0e4af59d2ca45f2f67061beb96a85b4f5f79ce4
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
    for n = 1:T.nmodes
<<<<<<< HEAD
        fprintf("Trial %d",n);
=======
>>>>>>> b0e4af59d2ca45f2f67061beb96a85b4f5f79ce4
        tStart = cputime;
        f = @() mttkrp(X,U,n); %<--matricize with respect to dimension i
        tt_elapsed = tt_elapsed + timeit(f);
        tEnd = cputime - tStart;
        tt_cpu = tt_cpu + tEnd;

    end
end


tt_elapsed = tt_elapsed/NUMTRIALS;
tt_cpu = tt_cpu/NUMTRIALS;

<<<<<<< HEAD
fprintf(fileID,"Average elapsed time using Tensor Toolbox: %f\n",tt_elapsed);
fprintf(fileID,"Average CPU time using Tensor Toolbox: %f\n",tt_cpu);

fclose(fileID);
=======
if fileWrite
    fprintf(fileID,"Averages calculated over %d trials.\n",NUMTRIALS);
    fprintf(fileID,"Average elapsed time using HaCOO: %f\n",htns_elapsed);
    fprintf(fileID,"Average CPU time using HaCOO: %f\n",htns_cpu);
    fprintf(fileID,"Average elapsed time using Tensor Toolbox: %f\n",tt_elapsed);
    fprintf(fileID,"Average CPU time using Tensor Toolbox: %f\n",tt_cpu);
    fclose(fileID);
end
>>>>>>> b0e4af59d2ca45f2f67061beb96a85b4f5f79ce4
