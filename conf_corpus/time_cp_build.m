%Measure elapsed and cpu time required to build document tensors 
% & cp als using Tensor Toolbox and HaCOO.
% Parameters:
%       numTrials - number of trials to average over
%       constraint - vocabulary constraint
%       outFile - file to write results to
%
% Returns:
%   nothing

function time_cp_build(varargin)
%% Set up params
params = inputParser;
params.addParameter('numTrials',10,@isscalar);
params.addParameter('constraint',10e4,@isscalar);
params.addParameter('outFile','tns_build_file',@isstring);
params.parse(varargin{:});

%% Copy from params object
NUMTRIALS = params.Results.numTrials;
constraint = params.Results.constraint;
outFile = params.Results.outFile;
%%

files = dir('*.TXT');
htns_elapsed = 0;
tt_elapsed = 0;
htns_cpu = 0;
tt_cpu = 0;
fileID = fopen(outFile,'w');

fprintf(fileID,"Building corpus with %i word vocabulary.\n",constraint);

for i = 1:length(files)
    fid1 = files(i).name;
    fprintf(fileID,"%s\n",fid1);
end

[N,words,wordToIndex,newFileNames] = build_vocab('constraint',constraint);

fprintf("HaCOO Tests\n");
for i=1:NUMTRIALS
    %HaCOO tests
    fprintf("Trial %d\n",i);
    tic
    tStart = cputime;
    t = cp_doctns(N,words,wordToIndex,newFileNames,'format',"htensor");

    %decompose tensor into rank-1 components
    cp_als(t,50);

    htns_elapsed = htns_elapsed + toc;
    tEnd = cputime - tStart;
    htns_cpu = htns_cpu + tEnd;
end

htns_elapsed = htns_elapsed/NUMTRIALS;
htns_cpu = htns_cpu/NUMTRIALS;
fprintf(fileID,"Averages calculated over %d trials to build and perform CP ALS decomposition.\n",NUMTRIALS);
fprintf(fileID,"Average elapsed time using HaCOO: %f\n",htns_elapsed);
fprintf(fileID,"Average CPU time using HaCOO: %f\n",htns_cpu);

fprintf("COO Tests\n");
for i=1:NUMTRIALS
    %COO tests
    fprintf("Trial %d\n",i);
    tic
    tStart = cputime;
    t = cp_doctns(N,words,wordToIndex,newFileNames,'format',"sptensor");

    %decompose tensor into rank-1 components
    cp_als(t,50);

    tt_elapsed = tt_elapsed + toc;
    tEnd = cputime - tStart;
    tt_cpu = tt_cpu + tEnd;

end

tt_elapsed = tt_elapsed/NUMTRIALS;
tt_cpu = tt_cpu/NUMTRIALS;

fprintf(fileID,"Average elapsed time using Tensor Toolbox: %f\n",tt_elapsed);
fprintf(fileID,"Average CPU time using Tensor Toolbox: %f\n",tt_cpu);

fclose(fileID);
