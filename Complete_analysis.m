% Created on 13/07/2021 by Yasha Tenhagen.
% This code performs analysis on a Cellpose segmentation.

clear all
close all
clc

%% Load scripts

% specify the path to your scripts
addpath('M:\tnw\bn\dm\Shared\Yasha\CellContactNetwork-main\NetworkAnalysis')        
addpath('M:\tnw\bn\dm\Shared\Yasha\CellContactNetwork-main\NetworkAnalysis\Violinplot-Matlab-master')


%% Set parameters

cond = 3;                                                                  % specify number of conditions
num = 2;                                                                   % specify number of experiments per condition (e.g. duplicate)
set_up = zeros(cond, num);                                                 % experimental set-up
wellsize = 6100;                                                           % specify well size in um


%% Extract the data from each well and output basic numbers

disp('Extracting data...')

for i = 1:numel(set_up)

    % Choose files (RGB image, segmented image and network measurements)
    [fused_file,raw_path] = uigetfile('.tif', 'Choose the fused RGB image.')
    cd(raw_path)
    segmented_file = uigetfile('.tif', 'Choose the segmented image.');
    network_file = uigetfile('.mat', 'Choose the Matlab file containing the network measurements.');

    filename = raw_path(end-3:end-1);

    % Print outputs
    [data(i)] = ExtractData(network_file, filename, wellsize);
    
    % Keep segmented image
    seg(i) = convertCharsToStrings(segmented_file);
    raw(i) = convertCharsToStrings(raw_path);

end


%% Perform analysis between wells and conditions

PrintOutputsNetworks(data, set_up)


%% Plot segmentations

PlotSegmentation(seg, raw, data, set_up)


%% Plot network properties on segmentation

PlotNetworkProp(seg, raw, data, set_up)


%% Plot network values

PlotValues(data, set_up)

