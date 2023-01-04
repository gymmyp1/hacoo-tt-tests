% Build tensors from a directory of .txt files using Tensor Toolbox's
% sptensor class and functions.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

% Builds unconstrained vocabulary by default
%f = @() tt_doctns(); % handle to function
%timeit(f)

f = @() tt_doctns('constraint',600); % handle to function
timeit(f)