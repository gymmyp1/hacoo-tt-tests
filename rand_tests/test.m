%Test for timing n random accesses on a HaCOO sptensor.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

n = 1000;
modes = [1000 1000 1000];
nnz = 100000; %number of nonzeros in the random sptensor

%HaCOO tests
tStart = cputime;
fprintf("HaCOO random access elapsed time: ")
f = @() htns_rand(n,modes,nnz); % handle to function
timeit(f)
fprintf("HaCOO random access cpu time: ")
tEnd = cputime - tStart


%COO tests
tStart = cputime;
fprintf("COO random access elapsed time: ")
f = @() coo_rand(n,modes,nnz); % handle to function
timeit(f)
fprintf("COO random access cpu time: ")
tEnd = cputime - tStart