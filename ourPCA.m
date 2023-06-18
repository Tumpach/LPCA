function [eigvalues, eigvectors] = ourPCA(D)

     [d,n] =  size(D);
     C = ourCov(D);
     [eigvectors, lambda] = eig(C);
     eigvalues = diag(lambda); 
     [eigvalues, index] = sort(eigvalues, 'descend');
     eigvectors = real(eigvectors(:,index));
     eigvectors = normr(eigvectors')';

end