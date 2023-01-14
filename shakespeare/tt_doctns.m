% Build tensors from a directory of .txt files using Tensor Toolbox's
% sptensor class and functions.

function tt_doctns(varargin)
%% Set up params
params = inputParser;
params.addParameter('vocabFile','vocabulary',@isstring);
params.addParameter('freqFile','@',@isstring);
params.addParameter('constraint',10e4,@isscalar);
params.addParameter('ngram',3,@isscalar);
params.parse(varargin{:});

%% Copy from params object
vocabFile = params.Results.vocabFile;
freqFile = params.Results.freqFile;
constraint = params.Results.constraint;
ngram = params.Results.ngram;
%%

files = dir('*.TXT');
N = numel(files);
newFileNames = cell(N,1);
words = cell(N, 1);

for i = 1:length(files)
    fid1 = files(i).name;
    %disp(fid1);
    newFileNames{i} = replace(fid1,'txt','mat');
    %disp(newFileNames(i))
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
%wordToIndex.keys
%wordToIndex.values


% construct the document tensors
for doc=1:N %for every doc
    tns = sptensor(ones(1,ngram));
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
        %disp(tns);

        % next word
        i = i+1;
    end

    %fprintf("Writing file: ");
    %disp(newFileNames{doc});
    
    % write the file
    fileID = newFileNames{doc};
    save(fileID,'tns','-v7.3'); %adding version to save large files
    
end

end %<-- end function

