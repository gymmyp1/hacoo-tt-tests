% Build tensors from a directory of .txt files using Tensor Toolbox's
% sptensor class and functions.

%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

files = dir('*.TXT');
NUMTRIALS = 10;
constraint = 600;
htns_elapsed = 0;
tt_elapsed = 0;
htns_cpu = 0;
tt_cpu = 0;
fileID = fopen('con_conference.txt','w');

fprintf(fileID,"Building Conference corpus with constrained %i word vocabulary .\n",constraint);

for i = 1:length(files)
    fid1 = files(i).name;
    fprintf(fileID,"%s\n",fid1);
end

for i=0:NUMTRIALS
    %HaCOO tests
    tStart = cputime;
    f = @() htns_doctns('constraint',constraint); % handle to function
    %fprintf("Wall Clock time using HaCOO: ")
    temp = timeit(f);
    htns_elapsed = htns_elapsed + temp;

    %fprintf("Total CPU time using HaCOO: ")
    tEnd = cputime - tStart;
    htns_cpu = htns_cpu + tEnd;

    %COO tests
    tStart = cputime;
    f = @() tt_doctns('constraint',constraint); % handle to function
    %fprintf("Wall Clock time using Tensor Toolbox: ")
    temp = timeit(f);
    tt_elapsed = tt_elapsed + temp;

    %fprintf("Total CPU time using Tensor Toolbox: ")
    tEnd = cputime - tStart;
    tt_cpu = tt_cpu + tEnd;

end

htns_elapsed = htns_elapsed/NUMTRIALS;
tt_elapsed = tt_elapsed/NUMTRIALS;

htns_cpu = htns_cpu/NUMTRIALS;
tt_cpu = tt_cpu/NUMTRIALS;

fprintf(fileID,"Averages calculated over %d trials.\n",NUMTRIALS);
fprintf(fileID,"Average elapsed time using HaCOO: %f\n",htns_elapsed);
fprintf(fileID,"Average CPU time using HaCOO: %f\n",htns_cpu);
fprintf(fileID,"Average elapsed time using Tensor Toolbox: %f\n",tt_elapsed);
fprintf(fileID,"Average CPU time using Tensor Toolbox: %f\n",tt_cpu);

fclose(fileID);
