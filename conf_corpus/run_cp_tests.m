%Suite of tests to compare document tensor building with sptensor
% and htensor.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

NUMTRIALS = 1;

%Run constrained tests
time_cp_build('numTrials',NUMTRIALS,'constraint',600,'outFile',"7.2_conf_buildtimes");

%Run unconstrainted tests
%time_cp_build('numTrials',NUMTRIALS,'outFile',"4.19conf_uncon");