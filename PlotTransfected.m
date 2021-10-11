function [rate, TFs] = PlotTransfected(fused, seg, raw, data, set_up, threshold)
% Created on 06/10/2021 by Yasha Tenhagen. Based on TF_well_analysis by
% Jeroen Jacques


%% General

disp('Create segmentation plots of each well with transfected cells as overlay...')

% Create an array with the filenames
for i = 1:numel(set_up)
    filename(:,i) = convertCharsToStrings(data(i).filename);
    num_nodes(i) = data(i).num_nodes;
end

TFs = zeros(max(num_nodes),numel(set_up));

%% Plot Transfection

for i = 1:numel(set_up)

    % Load the image
    cd(raw(i));
    
    segmented = imread(seg(i));
    fused_image = imread(fused(i));
    
    % Retrieve GFP intensities from fused image
    GFPstats = regionprops(segmented, fused_image(:,:,2), 'MeanIntensity');
    
    % Calculate the mean GFP intensity and set threshold
    MeanGFPIntensities = [GFPstats.MeanIntensity];
    GFPth = threshold;
    
    % Label the cells as transfected and non-transfected
    TF_labels = find([GFPstats.MeanIntensity]>GFPth);                      % labels transfected cells
    noTF_labels = find([GFPstats.MeanIntensity]<GFPth);                    % labels non-transfected cells
    
    % Label matrix
    CC = bwconncomp(segmented);                                            % Calculate connected components
    L = labelmatrix(CC);                                                   % Retrieve the label matrix
    
    % Make a colourmap
    cmap = zeros(max(L(:)), 3);
    cmap(noTF_labels,:) = 0.5;
    cmap(TF_labels, 1) = 0;
    cmap(TF_labels, 2) = 1;
    cmap(TF_labels, 3) = 0;

    % Convert the ordering of the subplot from row-wise to column-wise
    M = size(set_up,1);
    N = size(set_up,2);
    
    i_colwise = i;                                                         % The index according to your preferred ordering (column-wise)
    
    [jj,ii] = ind2sub([N,M],i_colwise);                                    % Conversion function
    i_rowwise = sub2ind([M,N],ii,jj);                                      % This is the ordering MATLAB expects (row-wise)
    
    % Plot transfected cells on segmentation plot
    if i == 1
        
        % Create a transfection figure and store handle
        figure
        fig(1) = gcf;
        
        % Plot the degree
        subplot(N, M, i_rowwise)
        rgb = label2rgb(segmented, cmap, [0,0,0]);                  % relabel to RGB colormap for visualization
        imshow(rgb)

        % Adjust labels
        xlabel('x')
        ylabel('y')
        title(['Transfection of ', num2str(filename(i))])
        set(gcf, 'Name', 'Transfections on segmented image')
        
    else
        
        % Go to degree figure
        figure(fig(1));
        
        % Plot the degree
        subplot(N, M, i_rowwise)
        rgb = label2rgb(segmented, cmap, [0,0,0]);                  % relabel to RGB colormap for visualization
        imshow(rgb)

        % Adjust labels
        xlabel('x')
        ylabel('y')
        title(['Transfection of ', num2str(filename(i))])
    end
    
    % Print transfection rate
    format0 = "The transfection rate of well %s is %0.2f%s% %.";
    rate(i) = length(TF_labels)/num_nodes(i)*100;
    fprintf(format0, filename(i), rate(i));
    fprintf("\n");
    
    % Create label array
    for j = 1:length(TF_labels)
        TFs(TF_labels(j),i) = 1;
    end
end


end