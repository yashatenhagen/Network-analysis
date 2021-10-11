function [T] = PlotNetworkProp(seg, raw, data, set_up, centrality_ind)
% Created on 18/08/2021 by Yasha Tenhagen.


%% General

disp('Create segmentation plots of each well with network properties (normalised per well) as overlay...')

% Create an array with the filenames
for i = 1:numel(set_up)
    filename(:,i) = convertCharsToStrings(data(i).filename);
end


%% Plot segmentations

for i = 1:numel(set_up)

    % Load the image
    cd(raw(i));
    segmented = imread(seg(i));

    % Label matrix
    CC = bwconncomp(segmented);                                            % Calculate connected components
    L = labelmatrix(CC);                                                   % Retrieve the label matrix
    
    % Retrieve and normalise 
    degree = data(i).degree;
    closeness = data(i).closeness;
    betweenness = data(i).betweenness;
    degree_norm = 4*degree/max(degree);
    closeness_norm = 4*closeness/max(closeness);
    betweenness_norm = 4*betweenness/max(betweenness);
    
    %
    max_degree(i) = max(degree);
    max_closeness(i) = max(closeness);
    max_betweenness(i) = max(betweenness);
    min_degree(i) = min(degree);
    min_closeness(i) = min(closeness);
    min_betweenness(i) = min(betweenness);
   
    % Create colourmaps
    cmap_degree = MakeColourmap(degree_norm, L);
    cmap_closeness = MakeColourmap(closeness_norm, L);
    cmap_betweenness = MakeColourmap(betweenness_norm, L);
    
    % Convert the ordering of the subplot from row-wise to column-wise
    M = size(set_up,1);
    N = size(set_up,2);
    
    i_colwise = i;                                                         % The index according to your preferred ordering (column-wise)
    
    [jj,ii] = ind2sub([N,M],i_colwise);                                    % Conversion function
    i_rowwise = sub2ind([M,N],ii,jj);                                      % This is the ordering MATLAB expects (row-wise)

    if i == 1
        
        if centrality_ind(1) == 1
            
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
        
        end
        if centrality_ind(2) == 1
            
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
       
        end
        if centrality_ind(3) == 1
        
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
        
        if centrality_ind(1) == 1
            
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
        
        end
        if centrality_ind(2) == 1
            
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
    
        end
        if centrality_ind(3) == 1
            
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

Name = filename';
Min_Degree = min_degree';
Max_Degree = max_degree';
Min_Closeness = min_closeness';
Max_Closeness = max_closeness';
Min_Betweenness = min_betweenness';
Max_Betweenness = max_betweenness';

T = table(Name, Min_Degree, Max_Degree, Min_Closeness, Max_Closeness, Min_Betweenness, Max_Betweenness)


end