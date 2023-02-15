%{
 File: htns_doctnns.m

Parameters:
    tns_format - which tensor format to use (sptensor or htensor)
    vocabFile - save vocabulary file
    freqFile - save frequency file
    constraint - limit vocabulary to the n most frequent words
    ngram - set the number of consecutive words when building tensor
    save - save document tensors as .mat files
%}

function doctns(varargin)
%% Set up params
params = inputParser;
params.addParameter('tns_format','default',@isstring);
params.addParameter('vocabFile','vocabulary',@isstring);
params.addParameter('freqFile','@',@isstring);
params.addParameter('constraint',10e4,@isscalar);
params.addParameter('ngram',3,@isscalar);
params.addParameter('mat_save',0,@isscalar);
params.parse(varargin{:});

%% Copy from params object
fmt = params.Results.tns_format;
vocabFile = params.Results.vocabFile;
freqFile = params.Results.freqFile;
constraint = params.Results.constraint;
ngram = params.Results.ngram;
mat_save = params.Results.mat_save;
%%

%Check if tensor format is valid
if strcmp(fmt,"sptensor")
    fmtNum = 1;
elseif strcmp(fmt,"htensor")
    fmtNum = 2;
else 
    printf("Tensor format invalid.\n");
    return
end

files = dir('*.TXT');
N = numel(files);
newFileNames = cell(N,1);
words = cell(N, 1);

for i = 1:length(files)
    fid1 = files(i).name;
    newFileNames{i} = replace(fid1,'txt','mat');
    fidI = fopen(files(i).name,'r');
    temp = textscan(fidI, '%s');
    docWords = {};
    for j=1:length(temp{1})
        lowerCase = lower(temp{1});
        if all(isstrprop(lowerCase{j},'alpha'))
            docWords{end+1} = lowerCase{j};
        end
    end
    words{i} = transpose(docWords);
end


% Build raw vocabulary dictionary
vocab = containers.Map;
for doc=1:N  %for every doc
    for i=1:length(words{doc})  %for every word in a doc
        word = words{doc}{i};
        if ~isKey(vocab,word) %if word is not in voacb, add it
            vocab(word) = 1;
        else
            vocab(word) = vocab(word) + 1;
        end
    end
end

%vocab.keys;
%vocab.values;

%Sort by frequency in descending order
keys = vocab.keys;
mvals = cell2mat(vocab.values);
[vocabVals, sortIdx] = sort(mvals,'descend');
vocabKeys = keys(sortIdx);

if constraint > 0 && constraint < length(keys)
    % count the other
    other = 0;
    for word=constraint+1:size(vocab,1)
        other = other + vocabVals(word);
    end

    % trim the list
    vocabKeys = vocabKeys(1:constraint);
    vocabVals = vocabVals(1:constraint);
    vocabKeys{end+1} = '<other>';
    vocabVals(end+1) = other;
end

% index the vocabulary
vocabIndex = 1:length(vocabKeys);

%Save the vocabulary
fileID = fopen(vocabFile,'w');
for i=1:length(vocabKeys)
    fprintf(fileID,'%s %d\n',vocabKeys{i},vocabIndex(i));
end
fclose(fileID);

% optionally save the frequency file
if freqFile ~= '@'
    fileID = fopen(freqFile,'w');
    for i=1:length(vocabKeys)
        fprintf(fileID,'%s %d\n',vocabKeys{i},vocabVals(i));
    end
    fclose(fileID);
end

% construct the word lookup
wordToIndex = containers.Map(vocabKeys,vocabIndex);


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
                %fprintf('Entry has been updated: ')
                %idx
                %tns(idx)
            end
        end

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

