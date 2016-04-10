function M2 = convert(M)
    
M2 = M;
l = length(M(1,:));
    for k = 1:l
        M2(l+1-k, :) = M(k, :); 
    end
end