%Test for timing n random accesses on a Tensor Toolbox COO sptensor.

function coo_rand(n, modes,nnz)

% A random, sparse tensor with nnz nonzeros.
X = sptenrand(modes,nnz);

NUMTRIALS = n; %try one million elements

genIdx = zeros(1,length(modes));
asn = 0; %just a counter

for i = 1:NUMTRIALS
    %Generate a random index
    for j=1:length(modes)
        genIdx(j) = randi([1,modes(j)]);
    end

    X(genIdx);
    %{
    %Check if that index exists
    if X(genIdx) == 0
        %fprintf("Index not found.\n")
        %Assign it to tensor

    else
        %Assign it a new value
        X(genIdx) = 1;
        fprintf("New value assigned.\n")
        asn = asn + 1;
    end
    %}
end

end