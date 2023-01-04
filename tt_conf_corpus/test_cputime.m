% Build tensors from a directory of .txt files using Tensor Toolbox's
% sptensor class and functions.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

%test cpu time
tStart = cputime;

%tt_doctns(); %run test with unconstrained vocab
tt_doctns('constraint',600); % run test with constrained vocab

tEnd = cputime - tStart