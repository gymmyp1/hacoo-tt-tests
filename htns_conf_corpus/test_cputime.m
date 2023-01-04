%Build tensors from a directory of .txt files using HaCOO structure.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

%test cpu time
tStart = cputime;

%htns_doctns(); %run with unconstrained vocab
%htns_doctns('constraint',600); % run test

tEnd = cputime - tStart
