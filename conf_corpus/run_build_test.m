%Run tests to compare how long it takes to build all document tensors.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

%Run constrained tests
time_build('numTrials',1,'constraint',600,'outFile',"7.3_conference_constrained");

%Run unconstrainted tests
%time_build('numTrials',10,'outFile',"3_2conf");