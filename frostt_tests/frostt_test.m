%Test for timing frostt tensors

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

file = "uber_trim.txt";
format = "sptensor";

[walltime,cpu_time] = read_frostt('file', file,'format',format)