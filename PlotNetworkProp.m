function [T] = PlotNetworkProp(seg, raw, data, set_up, centrality_all)
% Created on 18/08/2021 by Yasha Tenhagen.


%% General

disp('Create segmentation plots of each well with network properties as overlay...')

% Create an array with the filenames
for i = 1:numel(set_up)
    filename(:,i) = convertCharsToStrings(data(i).filename);
end


%% Data structure

% Preallocate the data matrices by finding the maximum number of nodes
for i = 1:numel(set_up)                                                    % Create array of the number of nodes
   num_nodes(:,i) = data(i).num_nodes;
end

degree = nan(numel(set_up), max(num_nodes));
closeness = nan(numel(set_up), max(num_nodes));
betweenness = nan(numel(set_up), max(num_nodes));

for i = 1:numel(set_up)
    
    % Retrieve and normalise 
    degree(i,1:num_nodes(i)) = data(i).degree;
    closeness(i,1:num_nodes(i)) = data(i).closeness;
    betweenness(i,1:num_nodes(i)) = data(i).betweenness;
    
end

max_degree = max(degree, [], 'all');
max_closeness = max(closeness, [], 'all');
max_betweenness = max(betweenness,[], 'all');
min_degree = min(degree, [], 'all');
min_closeness = min(closeness, [], 'all');
min_betweenness = min(betweenness, [], 'all');


%% Plot segmentations

for i = 1:numel(set_up)

    % Load the image
    cd(raw(i));
    segmented = imread(seg(i));

    % Label matrix
    CC = bwconncomp(segmented);                                            % Calculate connected components
    L = labelmatrix(CC);                                                   % Retrieve the label matrix
    
    % Retrieve and normalise 
    degree_norm = 4*rmmissing(degree(i,:))/max_degree;
    closeness_norm = 4*rmmissing(closeness(i,:))/max_closeness;
    betweenness_norm = 4*rmmissing(betweenness(i,:))/max_betweenness;
    
    % Create colourmaps
    cmap_degree = MakeColourmap(degree_norm', L);
    cmap_closeness = MakeColourmap(closeness_norm', L);
    cmap_betweenness = MakeColourmap(betweenness_norm', L);
    
    % Convert the ordering of the subplot from row-wise to column-wise
    M = size(set_up,1);
    N = size(set_up,2);
    
    i_colwise = i;                                                         % The index according to your preferred ordering (column-wise)
    
    [jj,ii] = ind2sub([N,M],i_colwise);                                    % Conversion function
    i_rowwise = sub2ind([M,N],ii,jj);                                      % This is the ordering MATLAB expects (row-wise)

    if i == 1
        
        if centrality_all(1) == 1
        
            % Create a degree figure and store handle
            figure
            fig(1) = gcf;

            % Plot the degree
            subplot(N, M, i_rowwise)
            rgb = label2rgb(segmented, cmap_degree, [0,0,0]);                  % relabel to RGB colormap for visualization
            imshow(rgb)

            % Adjust labels
            xlabel('x')
            ylabel('y')
            title(['Degree of ', num2str(filename(i))])
            set(gcf, 'Name', 'Degree centrality of segmented image')

        elseif centrality_all(2) == 1
        
            % Create a closeness figure and store handle
            figure
            fig(2) = gcf;

            % Plot the closeness
            subplot(N, M, i_rowwise)
            rgb = label2rgb(segmented, cmap_closeness, [0,0,0]);               % relabel to RGB colormap for visualization
            imshow(rgb)

            % Adjust labels
            xlabel('x')
            ylabel('y')
            title(['Closeness of ', num2str(filename(i))])
            set(gcf, 'Name', 'Closeness centrality of segmented image')

        elseif centrality_all(3) == 1
            
            % Create a figure and store handle
            figure
            fig(3) = gcf;

            % Plot the betweenness
            subplot(N, M, i_rowwise)
            rgb = label2rgb(segmented, cmap_betweenness, [0,0,0]);             % relabel to RGB colormap for visualization
            imshow(rgb)

            % Adjust labels
            xlabel('x')
            ylabel('y')
            title(['Betweenness of ', num2str(filename(i))])
            set(gcf, 'Name', 'Betweenness centrality of segmented image')
            
        end
    else
        
        if centrality_all(1) == 1
            
            % Go to degree figure
            figure(fig(1));

            % Plot the degree
            subplot(N, M, i_rowwise)
            rgb = label2rgb(segmented, cmap_degree, [0,0,0]);                  % relabel to RGB colormap for visualization
            imshow(rgb)

            % Adjust labels
            xlabel('x')
            ylabel('y')
            title(['Degree of ', num2str(filename(i))])
       
        elseif centrality_all(2) == 1
            
            % Go to closeness figure
            figure(fig(2));

            % Plot the closeness
            subplot(N, M, i_rowwise)
            rgb = label2rgb(segmented, cmap_closeness, [0,0,0]);               % relabel to RGB colormap for visualization
            imshow(rgb)

            % Adjust labels
            xlabel('x')
            ylabel('y')
            title(['Closeness of ', num2str(filename(i))])
        
        elseif centrality_all(3) == 1
            
            % Go to betweenness figure
            figure(fig(3));

            % Plot the betweenness
            subplot(N, M, i_rowwise)
            rgb = label2rgb(segmented, cmap_betweenness, [0,0,0]);             % relabel to RGB colormap for visualization
            imshow(rgb)

            % Adjust labels
            xlabel('x')
            ylabel('y')
            title(['Betweenness of ', num2str(filename(i))])
            
        end
    end
end


%% Print maxima and minima

Name = {'Degree'; 'Closeness'; 'Betweenness'};
Minima = [min_degree; min_closeness; min_betweenness];
Maxima = [max_degree; max_closeness; max_betweenness];

T = table(Name, Minima, Maxima)


end