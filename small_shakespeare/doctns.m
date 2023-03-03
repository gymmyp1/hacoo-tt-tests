%{
 File: htns_doctnns.m
 Purpose: Report time required to update all document tensors (times
    index insertion only).

Parameters:
    tns_format - which tensor format to use (sptensor or htensor)
    ngram - set the number of consecutive words when building tensor
    save - save document tensors as .mat files

Returns:
    walltime - accumulated elapsed time required to build all document
    tensors
    cputime - accumulated cpu time required to build all document
    tensors
%}

function [walltime,cpu_time] = doctns(N,words,wordToIndex,newFileNames,varargin)
params = inputParser;
params.addParameter('format','default',@isstring);
params.addParameter('ngram',3,@isscalar);
params.addParameter('mat_save',0,@isscalar);
params.parse(varargin{:});

%% Copy from params object
formatmt = params.Results.format;
ngram = params.Results.ngram;
mat_save = params.Results.mat_save;
%%

%Check if tensor format is valid
if strcmp(formatmt,"sptensor")
    fmtNum = 1;
elseif strcmp(formatmt,"htensor")
    fmtNum = 2;
else 
    fprintf("Tensor format invalid.\n");
    return
end

walltime = 0;
cpu_time = 0;

% construct the document tensors
for doc=1:N %for every doc
    %If using HaCOO format
    if fmtNum == 2
        tns = htensor();
    elseif fmtNum == 1 %else use COO format
        tns = sptensor(ones(1,ngram));
    end
    
    curr_doc = words{doc}; %word list for current doc
    i = 1;
    limit = length(curr_doc) - ngram;
    % count the ngrams
    while i < limit+2
        gram = curr_doc(i:i+ngram-1);
        idx = zeros(1,ngram);

        % build the index
        for w=1:length(gram)
            word = gram{w};
            if ~isKey(wordToIndex,word)
                word = '<other>';
            end
            idx(w) = wordToIndex(word);
        end

        tic
        tStart = cputime;

        %If using HaCOO format
        if fmtNum == 2
            % accumulate the count
            %Search if index already exists in tensor
            [k,j] = tns.search(idx);

            if j == -1 %if it doesnt exist yet, set new entry w/ value of 1
                tns.table{k} = {idx 1};
            else
                %else, update the entry's val
                tns.table{k}{j,2} = tns.table{k}{j,2} + 1;
                %fprintf('Existing entry has been updated.\n')
            
            end

        %If using COO format
        elseif fmtNum == 1
            %Check if this index is larger than the sptensor size
            updateModes = idx > size(tns);

            if any(updateModes) %if any index modes are larger, just insert
                tns(idx) = 1;
            else
                %update the entry's val
                tns(idx) = tns(idx) + 1;
            end
        end

        walltime = walltime + toc;
        tEnd = cputime - tStart;
        cpu_time = cpu_time + tEnd;
        
        % next word
        i = i+1;
    end

    if mat_save
        %fprintf("Writing file: ");
        %newFileNames{doc}
        
        % write the file
        fileID = newFileNames{doc};
        write_htns(tns,fileID,'-v7.3');
    end
    
end

end %<-- end function

