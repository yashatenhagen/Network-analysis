function [T] = ViolinTransfected(data, set_up, TFs)
% Created on 06/10/2021 by Yasha Tenhagen.

%% General

disp('Create violin plots of each condition with transfected cells...')

% Create an array with the filenames
for i = 1:numel(set_up)
    filename(:,i) = convertCharsToStrings(data(i).filename);
    num_nodes(i) = data(i).num_nodes;
end


%% Isolate cell morphology properties

% Create an array with the names of the conditions
for i = 1:size(set_up,1)                                                   
    last(i) = i*size(set_up,2);
    if i == 1
        filename_cond(i) = join(filename(1:last(i)), ' + ');
    else
        filename_cond(i) = join(filename(last(i-1)+1:last(i)), ' + ');
    end
end

area_all = nan(max(num_nodes),numel(set_up));                                  % Create a nan array for area
eccentricity_all = nan(max(num_nodes),numel(set_up));                          % Create a nan array for eccentricity
perimeter_all = nan(max(num_nodes),numel(set_up));                             % Create a nan array for perimeter

% Create data matrices for separate wells
for i = 1:numel(set_up)
    area_all(1:length(data(i).area),i) = data(i).area;
    eccentricity_all(1:length(data(i).eccentricity),i) = data(i).eccentricity;
    perimeter_all(1:length(data(i).perimeter),i) = data(i).perimeter;
    
    area(:,i) = area_all(:,i).*TFs(:,i);
    eccentricity(:,i) = eccentricity_all(:,i).*TFs(:,i);
    perimeter(:,i) = perimeter_all(:,i).*TFs(:,i);
    
    area(area(:,i) == 0,i) = nan;
    eccentricity(eccentricity(:,i) == 0, i) = nan;
    perimeter(perimeter(:,i) == 0, i) = nan;
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

end