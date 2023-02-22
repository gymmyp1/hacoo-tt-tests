%Measure elapsed and cpu time required to build document tensors using
%Tensor Toolbox sptensor and HaCOO htensor.

function time_build(varargin)
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

fprintf(fileID,"Building Conference corpus with %i word vocabulary.\n",constraint);

for i = 1:length(files)
    fid1 = files(i).name;
    fprintf(fileID,"%s\n",fid1);
end

for i=0:NUMTRIALS
    %HaCOO tests
    [walltime,cpu_time] = doctns('tns_format',"htensor",'constraint',constraint); % handle to function
    htns_elapsed = htns_elapsed + walltime;
    htns_cpu = htns_cpu + cpu_time;

    %COO tests
    [walltime,cpu_time] = doctns('tns_format',"sptensor",'constraint',constraint); % handle to function
    tt_elapsed = tt_elapsed + walltime;
    tt_cpu = tt_cpu + cpu_time;

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
