%Build tensors from a directory of .txt files using HaCOO structure.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

% Builds unconstrained vocabulary by default
f = @() htns_doctns(); % handle to function
timeit(f)

%f = @() htns_doctns('constraint',600); % handle to function
%timeit(f)
