% Build tensors from a directory of .txt files using Tensor Toolbox's
% sptensor class and functions.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

%HaCOO tests
tic
htns_doctns('constraint',600); % handle to function
fprintf("Wall Clock time (tictoc) using HaCOO: ")
toc

%COO tests
tic
tt_doctns('constraint',600); % handle to function
fprintf("Wall Clock time (tictoc) using Tensor Toolbox: ")
toc