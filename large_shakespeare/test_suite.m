%Suite of tests to compare document tensor building with sptensor
% and htensor.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

%Run constrained tests
%time_build('numTrials',10,'constraint',600,'outFile',"3_3con_lg_shakespeare");

%Run unconstrainted tests
time_build('numTrials',10,'outFile',"3_3uncon_lg_shakespeare");