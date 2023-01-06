%Build tensors from a directory of .txt files using HaCOO.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

%test cpu time
tStart = cputime;

% Builds unconstrained vocabulary by default
f = @() htns_doctns(); % handle to function
fprintf("Wall Clock time using HaCOO: ")
timeit(f)

%f = @() htns_doctns('constraint',600); % handle to function
%fprintf("Wall Clock time using HaCOO: ")
%timeit(f)

fprintf("Total CPU time using HaCOO: ")
tEnd = cputime - tStart