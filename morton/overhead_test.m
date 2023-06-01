%Testing how much overhead morton encoding/decoding adds.

addpath /Users/meilicharles/Documents/MATLAB/hacoo-matlab/
%addpath  C:\Users\MeiLi\OneDrive\Documents\MATLAB\hacoo-matlab

%read in COO tensor
table = readtable('uber.txt');
idx = table(:,1:end-1);
vals = table(:,end);
idx = table2array(idx);
vals = table2array(vals);

codes = zeros(size(idx,1),1);

size(idx,1)
%encode each index individually
tic
for i=1:size(idx,1)
    codes(i) = morton_encode(idx(i,:));
end
fprintf("Time elapsed to encode individually: ");
toc


%encode in batch form
tic
S = sum(idx,2);
shift1 = arrayfun(@(x) x + bitshift(x,1),S);
shift2 = arrayfun(@(x) bitxor(x, bitshift(x,-2)),shift1);
shift3 = arrayfun(@(x) x + bitshift(x,5),shift2);
fprintf("Time elapsed to encode in batch form: ");
toc


%decode each index individually
tic
for i=1:size(idx,1)
    morton_decode(codes(i),size(idx,1));
end
fprintf("Time elapsed to decode individually: ");
toc

%decode in batch form
tic
%apply morton decode function
arrayfun(@(x) morton_decode(codes(x),size(idx,1)))
fprintf("Time elapsed to decode in batch form: ");
toc