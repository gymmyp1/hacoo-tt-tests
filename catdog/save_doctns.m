% Build and save HaCOO document tensors as COO files.

%constraint = 10^6;
constraint = 600;
ngram = 3;
files = dir('*.TXT');
vocabFile = "vocabulary";
freqFile = '@';

fprintf("Building corpus with %i word vocabulary.\n",constraint);

%{
for i = 1:length(files)
    fid1 = files(i).name;
    fprintf("%s\n",fid1);
end
%}

N = numel(files);
newFileNames = cell(N,1);
words = cell(N, 1);


for i = 1:length(files)
    fid1 = files(i).name;
    newFileNames{i} = replace(fid1,'.txt','_coo.txt');
    fidI = fopen(files(i).name,'r');
    temp = textscan(fidI, '%s');
    temp{1} = erasePunctuation(temp{1}); %requires MATLAB Text Analytics Toolbox
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

%vocab.keys
%vocab.values

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
    
    tns = htensor();
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

        % build using HaCOO format
        tns = tns.set(idx,1,'update',1);
        
        % next word
        i = i+1;
    end

    %tns.display_htns
    %tns.table{126}
    fprintf("Writing file: ");
    newFileNames{doc}

    % write the file
    fileID = newFileNames{doc};
    write_coo(tns,fileID);


end