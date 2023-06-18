# LPCA
visualization of high dimensional datasets

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LPCA is a visualization procedure that computes 2D positions of labelled
% datapoints from a high-dimensional dataset by performing a global PCA
% followed by local PCAs in each class. The low-dimensional approximation
% of each class is then glued in the plane spanned by the first two
% eigenvalues of the global PCA in such a way that:
% 1. the distance from the global mean to the mean of each class is preserved
% 2. the direction from the global mean to the mean of each class is preserved
% 3. the angle between the main eigenvector of each class and the main eigenvector
% of the whole dataset is preserved.
% 
% LPCA is a function:
% positions = lpca(data, labels)
%
% DIMENSION OF THE DATASET
% 'data' should be a dim x nb_of_samples matrix
% 
% LABELS
% 'labels' should be a 1 x nb_of_samples matrix containing consecutive
% numbers from 1 to nb_of_classes
%
% OUTPUT
positions is a 2 x nb_of_samples matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_LPCA to run lpca on the provided dataset
