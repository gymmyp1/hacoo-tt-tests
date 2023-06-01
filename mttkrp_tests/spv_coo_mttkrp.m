%{
Carry out mttkrp using the Sparse Vector method between the tensor 
and an array of matrices unfolding the tensor along mode n.

Parameters:
    T - an sptensor
    u - A list of matrices, these correspond to the modes
	    in the tensor, other than n. If i is the dimension in
	    mode x, then u(x) must be an i x f matrix.
    n - The mode along which the tensor is unfolded for the
	    product.
    varargin - optionally pass index and value arrays as the 4th and 5th
               arguments respectively
Returns:
    m - Result matrix with dimensions i_n x f
%}

function m = spv_coo_mttkrp(T,u,n)

% number of columns
fmax = size(u{1},2);

% create the result array
m = zeros(T.size(n), fmax);

% go through each column
for f=1:fmax
    % preallocate accumulation arrays
    t=zeros(1,size(T.subs,1));
    tind=zeros(1,size(T.subs,1));
    ac = 1; %counter for accumulation arrays

    % go through every entry
    for i = 1:size(T.subs,1)
        idx =T.subs(i,:);
        val = T.vals(i);
        t(ac) = val;
        tind(ac) = T.subs(i,n);
        ac = ac + 1; %advance counter
        z = ac-1;

        % multiply by each factor matrix except the nth matrix
        for j=1:size(u,1) %<-- for each matrix in u
            % skip the unfolded mode
            if j==n
                continue
            end

            % multiply the factor and advance to the next
            t(z) = u{j}(idx(j), f) * t(z);
        end
    end

    % accumulate m(:,f)
    for p=1:size(T.subs,1)
        m(tind(p),f) = m(tind(p), f) + t(p);
    end
end

end %<-- end function