function [] = PlotValues(data, set_up)
% Created on 19/08/2021 by Yasha Tenhagen.

%% General

% Create an array with the filenames, #nodes, #edges
for i = 1:numel(set_up)
    filename(:,i) = convertCharsToStrings(data(i).filename);
    nodes(i) = data(i).num_nodes;
    edges(i) = data(i).num_edges;
end

% Create an array for the x-axis
x = linspace(1, numel(set_up), numel(set_up));


%% Plot nodes and edges

% Open a figure
figure

% Plot the left axis (#nodes)
yyaxis left
scatter(x, nodes, 'o', 'filled')
ylabel('# nodes')

% Plot the right axis (#nodes)
yyaxis right
scatter(x, edges, 'd', 'filled')
ylabel('# edges')

% Adjust labels and more
xticks(x)
xticklabels(filename)
xlim([0 (numel(set_up) + 1)])
set(gcf, 'Name', 'Nodes and edges per well')


end