function [] = PlotRates(rate, data, set_up)
% Created on 06/10/2021 by Yasha Tenhagen.

%% General

% Create an array with the filenames
for i = 1:numel(set_up)
    filename(:,i) = convertCharsToStrings(data(i).filename);
end

% Create an array for the x-axis
x = linspace(1, numel(set_up), numel(set_up));


%% Plot nodes and edges

% Open a figure
figure

% Plot the left axis (#nodes)
scatter(x, rate, 'o', 'filled')
ylabel('Transfection rate [%]')

% Adjust labels and more
xticks(x)
xticklabels(filename)
xlim([0 (numel(set_up) + 1)])
set(gcf, 'Name', 'Transfection rate per well')
ylim([0 15])


end