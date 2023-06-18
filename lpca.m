%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LPCA is a visualization procedure that computes 2D positions of labelled
% datapoints from a high-dimensional dataset by performing a global PCA
% followed by local PCAs in each class. The low-dimensional approximation
% of each class is then glued in the plane spanned by the first two
% eigenvalues of the global PCA in such a way that:
% 1. the distance from the global mean to the mean of each class is preserved
% 2. the angle between the main eigenvector of each class and the main eigenvector
% of the whole dataset is preserved.
%
% DIMENSION OF THE DATASET
% 'data' should be a dim x nb_of_samples matrix
% 
% LABELS
% 'labels' should be a 1 x nb_of_samples matrix containing consecutive
% numbers from 1 to nb_of_classes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function global_positions = lpca(data, labels)

    nb_of_samples = size(data, 2);
    nb_classes = max(labels);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % In the first step, we apply a global PCA and estimate the global
    % dimension of the ambient vector space by computing the number of
    % eigenvectors needed to capture 99% of the variance
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [eigvalues, eigvectors] = ourPCA(data);

    % calculate variance

    variance = abs(eigvalues);
    variance_reached = cumsum(variance); % sum up variance to specify how much of the variance is reached already
    variance_reached = variance_reached/variance_reached(end); % in fraction
    I = find(variance_reached > 0.99);
    dimension_of_ambient_space = nb_of_samples
    estimated_global_dimension = I(1)
    
    global_dimension = estimated_global_dimension;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % From now on, we will use the coordinates given by the global PCA.
    % Therefore we transform the vectors of the initial dataset in the global
    % PCA coordinates, this reduces the ambient space to the dimension
    % estimated_global_dimension.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mean_data = mean(data, 2);
     
    data_in_global_PCA = eigvectors(:, [1:estimated_global_dimension])'* (data-mean_data);
    
    mean_data_in_global_PCA = mean(data_in_global_PCA,2); % should be closed to 0
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % An upper bound of the local dimension is obtained by performing PCA in
    % each class
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    estimated_dimension_per_class = zeros(nb_classes, 1);

    for i = 1: nb_classes
        class{i} = data_in_global_PCA(:, find(labels == i));
        [eigvalues_class{i}, eigvectors_class{i}] = ourPCA(class{i});
        mean_class{i} = mean(class{i}, 2);
        
        % calculate variance

        variance = abs(eigvalues_class{i});        
        variance_reached = cumsum(variance); % sum up variance to specify how much of the variance is reached already
        variance_reached = variance_reached/variance_reached(end); % in fraction        
        I = find(variance_reached > 0.99);
        estimated_dimension_per_class(i,1) = I(1);

    end
    the_estimated_dimensions_per_class_are = estimated_dimension_per_class(:, 1)'
    upper_bound_local_dimension = max(estimated_dimension_per_class)
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % We compute the Euclidiean distance between the centers of classes and the mean. 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dist = zeros(1, nb_classes);
    for i = 1: nb_classes
        dist(1, i) = norm(mean_data_in_global_PCA-mean_class{i});        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % We compute the direction form the mean_data to each center of class by
    % projection the vectors (mean_class{i}-mean_shape) onto the first two
    % eigenvectors of the global PCA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    vectors = zeros(2, nb_classes);
    for i = 1:nb_classes
        vectors(:, i) = (mean_class{i}(1:2,1)-mean_data_in_global_PCA(1:2,1))/norm(mean_class{i}(1:2,1)-mean_data_in_global_PCA(1:2,1));
    end

    positions_centers_classes = zeros(2, nb_classes);
    for i = 1:nb_classes
        positions_centers_classes(:,i) = (dist(1, i)) *vectors(:,i);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The angle between the main eigenvector of each class and the main
    % eigenvector of the global PCA basis is computed
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:nb_classes
        projection_eigenvector_class{i}(:, 1) = eigvectors_class{i}(1:2, 1)/norm(eigvectors_class{i}(1:2, 1));
        if projection_eigenvector_class{i}(2, 1) > 0 
            angle = acos(projection_eigenvector_class{i}(1,1));
        elseif projection_eigenvector_class{i}(2, 1) < 0 
            angle = -acos(projection_eigenvector_class{i}(1,1));
        else angle = 0;
        end
        rotation{i} = [cos(angle) -sin(angle); sin(angle) cos(angle)];
    end       
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The center of each class is placed in the plane at the right distance from
    % the mean shape in the right direction 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global_positions = zeros(2, nb_of_samples);
    
    
    for k = 1: nb_of_samples
        for i = 1:nb_classes
            if labels(1, k) == i
                positions = eigvectors_class{i}'*(data_in_global_PCA(:, k));
                positions(1, 1) = positions(1, 1) * sqrt(eigvalues(1,1));
                positions(2, 1) = positions(2, 1) * sqrt(eigvalues(2,1));


                positions(1:2,1) = rotation{i} * positions(1:2, 1);

                global_positions(1, k) = positions(1, 1) + positions_centers_classes(1,i);
                global_positions(2, k) = positions(2, 1) + positions_centers_classes(2,i);
            end   
        end
    end
    
end