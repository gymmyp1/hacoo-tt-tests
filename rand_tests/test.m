%Test for timing n random accesses on a HaCOO sptensor.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

n = 1000;
modes = [1000 1000 1000];
nnz = 10000; %number of nonzeros in the random sptensor
NUMTRIALS = 10;
htns_elapsed = 0;
tt_elapsed = 0;
htns_cpu = 0;
tt_cpu = 0;
fileID = fopen('rand_access_test.txt','w');
increment = n;

while n<=1000000
fprintf(fileID,"Testing %d random accesses...\n", n);

for i=0:NUMTRIALS

%HaCOO tests
tStart = cputime;
%fprintf("HaCOO random access elapsed time: ")
f = @() htns_rand(n,modes,nnz); % handle to function
temp = timeit(f);
htns_elapsed = htns_elapsed + temp;
%fprintf("HaCOO random access cpu time: ")
tEnd = cputime - tStart;
htns_cpu = htns_cpu + tEnd;


%COO tests
tStart = cputime;
%fprintf("COO random access elapsed time: ")
f = @() coo_rand(n,modes,nnz); % handle to function
temp = timeit(f);
tt_elapsed = tt_elapsed + temp;
%fprintf("COO random access cpu time: ")
tEnd = cputime - tStart;
tt_cpu = tt_cpu + tEnd;

end

htns_elapsed = htns_elapsed/NUMTRIALS;
tt_elapsed = tt_elapsed/NUMTRIALS;

htns_cpu = htns_cpu/NUMTRIALS;
tt_cpu = tt_cpu/NUMTRIALS;

fprintf(fileID,"Average elapsed time using HaCOO: %f\n",htns_elapsed);
fprintf(fileID,"Average CPU time using HaCOO: %f\n",htns_cpu);
fprintf(fileID,"Average elapsed time using Tensor Toolbox: %f\n",tt_elapsed);
fprintf(fileID,"Average CPU time using Tensor Toolbox: %f\n",tt_cpu);

n = n*10;

end

fclose(fileID);