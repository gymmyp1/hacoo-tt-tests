% Build tensors from a directory of .txt files using Tensor Toolbox's
% sptensor class and functions.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

%HaCOO tests
tStart = cputime;
f = @() htns_doctns(); % handle to function
fprintf("Wall Clock time using HaCOO: ")
timeit(f)

fprintf("Total CPU time using HaCOO: ")
tEnd = cputime - tStart

%COO tests
tStart = cputime;
f = @() tt_doctns(); % handle to function
fprintf("Wall Clock time using Tensor Toolbox: ")
timeit(f)

fprintf("Total CPU time using Tensor Toolbox: ")
tEnd = cputime - tStart