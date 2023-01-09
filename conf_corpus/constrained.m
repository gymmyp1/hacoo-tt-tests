% Build tensors from a directory of .txt files using Tensor Toolbox's
% sptensor class and functions.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

fprintf("Building cofrence corpus with constrained vocabulary.\n")

NUMTRIALS = 10;
htns_elapsed = 0;
tt_elapsed = 0;
htns_cpu = 0;
tt_cpu = 0;

for i=0:NUMTRIALS
    %HaCOO tests
    tStart = cputime;
    f = @() htns_doctns('constraint',600); % handle to function
    %fprintf("Wall Clock time using HaCOO: ")
    temp = timeit(f);
    htns_elapsed = htns_elapsed + temp;

    %fprintf("Total CPU time using HaCOO: ")
    tEnd = cputime - tStart;
    htns_cpu = htns_cpu + tEnd;

    %COO tests
    tStart = cputime;
    f = @() tt_doctns('constraint',600); % handle to function
    %fprintf("Wall Clock time using Tensor Toolbox: ")
    temp = timeit(f);
    tt_elapsed = tt_elapsed + temp;

    %fprintf("Total CPU time using Tensor Toolbox: ")
    tEnd = cputime - tStart;
    tt_cpu = tt_cpu + tEnd;

end

htns_elapsed = htns_elapsed/NUMTRIALS;
tt_elapsed = tt_elapsed/NUMTRIALS;

htns_cpu = htns_cpu/NUMTRIALS;
tt_cpu = tt_cpu/NUMTRIALS;

fprintf("Average elapsed time using HaCOO: ")
htns_elapsed
fprintf("Average CPU time using HaCOO: ")
htns_cpu

fprintf("Average elapsed time using Tensor Toolbox: ")
tt_elapsed
fprintf("Average CPU time using Tensor Toolbox: ")
tt_cpu