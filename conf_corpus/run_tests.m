%Suite of tests to compare document tensor building with sptensor
% and htensor.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

%Run constrained tests
time_build('numTrials',1,'constraint',600,'outFile',"7.3catdog");

%Run unconstrainted tests
%time_build('numTrials',10,'outFile',"3_2conf");