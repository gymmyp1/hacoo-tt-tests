% Build tensors from a directory of .txt files using Tensor Toolbox's
% sptensor class and functions.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

%test cpu time
tStart = cputime;,

% Builds unconstrained vocabulary by default
%f = @() tt_doctns(); % handle to function
%fprintf("Wall Clock time using Tensor Toolbox: ")
%timeit(f)

f = @() tt_doctns('constraint',600); % handle to function
fprintf("Wall Clock time using Tensor Toolbox: ")
timeit(f)

fprintf("Total CPU time using Tensor Toolbox: ")
tEnd = cputime - tStart