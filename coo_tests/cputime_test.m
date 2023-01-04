%Test for timing n random accesses on a Tensor Toolbox COO sptensor.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

n = 1000;
modes = [1000 1000 1000];
nnz = 100000; %number of nonzeros in the random sptensor

tStart = cputime;

coo_rand(n,modes,nnz); %run test

tEnd = cputime - tStart