%Test for timing n random accesses on a HaCOO sptensor.

function avg = htns_rand(n, modes,nnz)

% A random, sparse tensor with nnz nonzeros.
X = sptenrand(modes,nnz);

%extract its subs and values
H = htensor(X.subs,X.vals);

NUMTRIALS = n; 

genIdx = zeros(1,3);
asn = 0; %just a counter

for i = 1:NUMTRIALS
    %Generate a random index
    for j=1:length(modes)
        genIdx(j) = randi([1,modes(j)]);
    end
    
    tic
    H.get(genIdx);
    sum = sum + toc;

    %Assign it a value of 1 if it's present in the tensor
    %H = H.set(genIdx,1);
    %asn = asn + 1;

end

avg = sum/NUMTRIALS;
end