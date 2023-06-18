close all;clc;

%load a dataset
name = 'leaves_1000_clock_rotated_translated_area_one';

load(name)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%perform LPCA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

positions = lpca(data, labels);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set colors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nb_classes = max(labels);


tps = [0:pi/(2*(nb_classes)):pi/2];
for i = 1:nb_classes
    col(i,1)= abs(sin(tps(1,i)));
end


colors1 = zeros(nb_classes, 3);
for i = 1:nb_classes
    colors1(i, :) = colorbar_rainbow(col(i,1))';
end

symbols = 'o+_*x.sdv^<>ph.';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name', 'Dimension reduction using local PCAs')

gscatter(positions(1,:)', positions(2,:)', labels, colors1, symbols);
    
    
