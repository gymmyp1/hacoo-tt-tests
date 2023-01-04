%Test for timing n random accesses on a HaCOO sptensor.

addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab
%addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

n = 1000;
modes = [1000 1000 1000];
nnz = 100000; %number of nonzeros in the random sptensor

f = @() htns_rand(n,modes); % handle to function
timeit(f)