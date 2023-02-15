%Suite of tests to compare document tensor building with sptensor
% and htensor.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

%Run constrained tests
time_build('numTrials',1,'constraint',600,'outFile',"2_15con_conf.txt");

%Run unconstrainted tests
%run(time_build,'numTrials',1,'outFile',"2_15uncon_conf.txt");