%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function  ourCov computes the covariance matrix C of a data matrix D
% input = matrix D of dimension dxn where n is the number of samples and d
% the dimension of the vectors
% output = mean M  and covariance matrix C of the sample of vectors 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function C = ourCov(D)

n = size(D, 2);
C = zeros(size(D, 1), size(D, 1));
M = repmat(mean(D, 2), [1, n]);

C = (D-M)*(D-M)'./(n-1);

end
