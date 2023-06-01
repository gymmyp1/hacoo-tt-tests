%File to measure performance of HaCOO's MTTKRP function.

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

%file = "uber_trim.txt";
%T = read_htns(file);

%Load the tensor
file = 'uber_hacoo.mat';
T = load_htns(file);
fprintf("max chain depth: %d\n",T.max_chain_depth);

%Set up U
N = T.nmodes;
dimorder = 1:N;
Uinit = cell(N,1);

%this should correspond to the number of components in the decomposition
col_sz = 2; 

for n = 1:N
    Uinit{n} = rand(T.modes(n),col_sz);
end

U = Uinit;

spv_htns_mttkrp(T,U,1);