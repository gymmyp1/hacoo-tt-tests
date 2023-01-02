%Build tensors from a directory of .txt files

addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB
%addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/

files = dir('*.TXT');
N = numel(files);
newFileNames = cell(N,1);
words = cell(N, 1);
constraint = 600;
ngram = 3;

for i = 1:length(files)
    fid1 = files(i).name;
    disp(fid1);
    newFileNames{i} = replace(fid1,'txt','mat');
    disp(newFileNames(i))
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

for i=1:length(files)
    disp(words{i})
end

