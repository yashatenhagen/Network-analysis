function [] = PlotSegmentation(seg, raw, data, set_up)
% Created on 16/08/2021 by Yasha Tenhagen.

%% General

% Create an array with the filenames
for i = 1:numel(set_up)
    filename(:,i) = convertCharsToStrings(data(i).filename);
end


%% Plot segmentations

figure()

for i = 1:numel(set_up)
    
    % Change the directory and load the image
    cd(raw(i));
    segmented = imread(seg(i));
    
    % Convert the ordering of the subplot from row-wise to column-wise
    M = size(set_up,1);
    N = size(set_up,2);
    
    i_colwise = i;                                                         % The index according to your preferred ordering (column-wise)
    
    [jj,ii] = ind2sub([N,M],i_colwise);                                    % Conversion function
    i_rowwise = sub2ind([M,N],ii,jj);                                      % This is the ordering MATLAB expects (row-wise)

    % Plot the image after relabeling to RGB colormap
    subplot(N, M, i_rowwise)
    rgb = label2rgb(segmented,'jet',[0,0,0],'shuffle');                    % randomly relabel to RGB colormap for visualization
    imshow(rgb)
    
    % Adjust labels
    xlabel('x')
    ylabel('y')
    title(filename(i))
    
end

set(gcf, 'Name', 'Segmentation per well')


end