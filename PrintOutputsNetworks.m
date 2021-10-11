function [T] = PrintOutputsNetworks(data,set_up)
% Created on 09/07/2021 by Yasha Tenhagen.
% This code extracts and prints the output values of a Cellpose
% segmentation between networks (after PrintOutputsWell).

%% General

disp('Create plot for each well and condition...')

% Specify the bin width
bindegree = 1;
bincloseness = 5e-8;
binbetweenness = 5e4;

% Specify the number of displayed bins (and thus the x limits)
dispbins = 50;
xlimdegree = [0, 20*bindegree];
xlimcloseness = [0, dispbins*bincloseness];
xlimbetweenness = [0, dispbins*binbetweenness];

% Specify the y limits
ylimdegree = [0, 0.5];
ylimcloseness = [0, 0.5];
ylimbetweenness = [0, 0.8];

% Create an array with the filenames
for i = 1:numel(set_up)
    filename(:,i) = convertCharsToStrings(data(i).filename);
end

% Create an array with the names of the conditions
for i = 1:size(set_up,1)                                                   
    last(i) = i*size(set_up,2);
    if i == 1
        filename_cond(i) = join(filename(1:last(i)), ' + ');
    else
        filename_cond(i) = join(filename(last(i-1)+1:last(i)), ' + ');
    end
end

%% PART I
%% Cell morphology calculations

% Preallocate the data matrices by finding the maximum number of nodes
for i = 1:numel(set_up)                                                    % Create array of the number of nodes
   num_nodes(:,i) = data(i).num_nodes;
end

area = nan(max(num_nodes),numel(set_up));                                  % Create a nan array for area
eccentricity = nan(max(num_nodes),numel(set_up));                          % Create a nan array for eccentricity
perimeter = nan(max(num_nodes),numel(set_up));                             % Create a nan array for perimeter

% Create data matrices for separate wells
for i = 1:numel(set_up)
   area(1:num_nodes(i),i) = data(i).area;
   eccentricity(1:num_nodes(i),i) = data(i).eccentricity;
   perimeter(1:num_nodes(i),i) = data(i).perimeter;
end

% Create data matrices for conditions
for i = 1:size(set_up,1)
    last(i) = max(num_nodes)*i*size(set_up,2);
    if i == 1
        area_cond(:,i) = vertcat(area(1:last(i)));
        eccentricity_cond(:,i) = vertcat(eccentricity(1:last(i)));
        perimeter_cond(:,i) = vertcat(perimeter(1:last(i)));
    else
        area_cond(:,i) = vertcat(area(last(i-1)+1:last(i)));
        eccentricity_cond(:,i) = vertcat(eccentricity(last(i-1)+1:last(i)));
        perimeter_cond(:,i) = vertcat(perimeter(last(i-1)+1:last(i)));
    end
end


%% Violin plots of area, eccentricity, perimeter for seperate wells

figure()

% Plot area
subplot(3,1,1)
violinplot(area, filename);
ylabel('Cell area [\mum^{2}]')
xlabel('Well')
title('Cell area per well')

% Plot eccentricity
subplot(3,1,2)
violinplot(eccentricity, filename);
ylabel('Eccentricity')
xlabel('Well')
title('Cell eccentricity per well')

% Plot perimeter
subplot(3,1,3)
violinplot(perimeter, filename);
ylabel('Perimeter [\mum]')
xlabel('Well')
title('Cell perimeter per well')

set(gcf, 'Name', 'Morphologies per well')


%% Violin plots of area, eccentricity, perimeter for conditions

figure()

% Plot area
subplot(3,1,1)
violinplot(area_cond, filename_cond);
ylabel('Cell area [\mum^{2}]')
xlabel('Well')
title('Cell area per condition')

% Plot eccentricity
subplot(3,1,2)
violinplot(eccentricity_cond, filename_cond);
ylabel('Eccentricity')
xlabel('Well')
title('Cell eccentricity per condition')

% Plot perimeter
subplot(3,1,3)
violinplot(perimeter_cond, filename_cond);
ylabel('Perimeter [\mum]')
xlabel('Well')
title('Cell perimeter per condition')

set(gcf, 'Name', 'Morphologies per condition')


%% Print medians of conditions

for i = 1:size(set_up,1)
    median_area_cond(i) = median(rmmissing(area_cond(:,i)));
    median_eccentricity_cond(i) = median(rmmissing(eccentricity_cond(:,i)));
    median_perimeter_cond(i) = median(rmmissing(perimeter_cond(:,i)));
end

Name = filename_cond';
Median_Area = median_area_cond';
Median_Eccentricity = median_eccentricity_cond';
Median_Perimeter = median_perimeter_cond';

T = table(Name, Median_Area, Median_Eccentricity, Median_Perimeter);

%% PART II
%% Network calculations

for i = 1:numel(set_up) 
    if mod(i-1,size(set_up,2)) == 0
        degree_cond(1:data(i).num_nodes) = data(i).degree;
    else
        degree_cond((data(i-1).num_nodes + 1):(data(i-1).num_nodes + data(i).num_nodes)) = data(i).degree;
    end
end


%% Histograms of network calculations for separate wells

figure()

% Plot degree
for i = 1:numel(set_up)
    subplot(3, numel(set_up), i)
    histogram(data(i).degree, 20, 'Normalization', 'probability', 'BinWidth' , bindegree)
    xlabel('Degree')
    ylabel('Probability')
    title(filename(i))
    xlim(xlimdegree)
    ylim(ylimdegree)
end

% Plot closeness
for i = 1:numel(set_up)
    subplot(3, numel(set_up), i + numel(set_up))
    histogram(data(i).closeness, 20, 'Normalization', 'probability', 'BinWidth' , bincloseness)
    xlabel('Closeness')
    ylabel('Probability')
    title(filename(i))
    xlim(xlimcloseness)
    ylim(ylimcloseness)
end

% Plot betweenness
for i = 1:numel(set_up)
    subplot(3, numel(set_up), i + numel(set_up)*2)
    histogram(data(i).betweenness, 20, 'Normalization', 'probability', 'BinWidth' , binbetweenness)
    xlabel('Betweenness')
    ylabel('Probability')
    title(filename(i))
    xlim(xlimbetweenness)
    ylim(ylimbetweenness)
end

set(gcf, 'Name', 'Network per well')


%% Histograms of network calculations for conditions

figure()

% Plot degree
c = 0;
for i = 1:size(set_up,1)
    subplot(3, size(set_up,1), i)
    for j = 1:size(set_up,2)
        c = c + 1;
        histogram(data(c).degree, 20, 'Normalization', 'probability', 'BinWidth' , bindegree)
        hold on
    end
    xlabel('Degree')
    ylabel('Probability')
    title(filename_cond(i))
    xlim(xlimdegree)
    ylim(ylimdegree)
end

% Plot closeness
c = 0;
for i = 1:size(set_up,1)
    subplot(3, size(set_up,1), i + size(set_up,1))
    for j = 1:size(set_up,2)
        c = c + 1;
        histogram(data(c).closeness, 20, 'Normalization', 'probability', 'BinWidth' , bincloseness)
        hold on
    end
    xlabel('Closeness')
    ylabel('Probability')
    title(filename_cond(i))
    xlim(xlimcloseness)
    ylim(ylimcloseness)
end

% Plot betweenness
c = 0;
for i = 1:size(set_up,1)
    subplot(3, size(set_up,1), i + size(set_up,1)*2)
    for j = 1:size(set_up,2)
        c = c + 1;
        histogram(data(c).betweenness, 20, 'Normalization', 'probability', 'BinWidth' , binbetweenness)
        hold on
    end
    xlabel('Betweenness')
    ylabel('Probability')
    title(filename_cond(i))
    xlim(xlimbetweenness);
    ylim(ylimbetweenness);
end

set(gcf, 'Name', 'Network per condition')


end