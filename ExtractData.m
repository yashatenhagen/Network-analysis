function [data] = ExtractData(network_file, filename, wellsize)
% Created on 09/07/2021 by Yasha Tenhagen.
% This code extracts and prints the output values of a Cellpose
% segmentation.


%% Load Data

% Load the data into a structure
network = load(network_file);
G = graph(network.contact_matrix);


%% Calculate values

% Convert pixels to micrometers
pix_to_um = wellsize/double(network.img_size(1));                      % number of micrometers per pixel

% Calculate values of interest
contact_matrix = network.contact_matrix;
num_nodes = length(contact_matrix);
num_edges = full(sum(contact_matrix,'all'));

degree = centrality(G,'degree');
avg_degree = mean(degree);                                             
sd_degree = sqrt(sum((degree-avg_degree).^2)/num_nodes);
closeness = centrality(G,'closeness');
betweenness = centrality(G,'betweenness');

area = network.area*pix_to_um^2;
avg_area = sum(area)/num_nodes;
sd_area = sqrt(sum((area-avg_area).^2)/num_nodes);

eccentricity = network.eccentricity;
avg_eccentricity = sum(eccentricity)/num_nodes;
sd_eccentricity = sqrt(sum((eccentricity-avg_eccentricity).^2)/num_nodes);

perimeter = network.perimeter*pix_to_um;
avg_perimeter = sum(perimeter)/num_nodes;
sd_perimeter = sqrt(sum((perimeter-avg_perimeter).^2)/num_nodes);


%% Print values

% Create strings
format0 = "Values for well %s:\n\n";

format1 = "The number of %s is %0.f.\n";
f_nodes = "nodes";
f_edges = "edges";

format2 = "The average %s is %0.2f%s%c with a standard deviation of %0.2f%s%c.\n";
f_area = "area";

format3 = "The average %s is %0.2f%s with a standard deviation of %0.2f%s.\n";
f_degree = "degree";
f_eccentricity = "eccentricity";
f_perimeter = "perimeter";

f_length = join([" ",(char(hex2dec('03bc'))),"m"],"");
f_empty = "";

% Print values
fprintf(format0, filename);
fprintf(format1, f_nodes, num_nodes);   
fprintf(format1, f_edges, num_edges);
fprintf(format3, f_degree, avg_degree, f_empty, sd_degree, f_empty);
fprintf("\n");

fprintf(format2, f_area, avg_area, f_length, 178, sd_area, f_length, 178);
fprintf(format3, f_eccentricity, avg_eccentricity, '', sd_eccentricity, '');
fprintf(format3, f_perimeter, avg_perimeter, f_length, sd_perimeter, f_length);
fprintf("\n");


%% Create data matrix

% network propterties
data.num_nodes = num_nodes;
data.num_edges = num_edges;
data.degree = degree;
data.avg_degree = avg_degree;                                          
data.sd_degree = sd_degree;
data.closeness = closeness;
data.betweenness = betweenness;

% cell properties
data.area = area;
data.avg_area = avg_area;
data.sd_area = sd_area;
data.eccentricity = eccentricity;
data.avg_eccentricity = avg_eccentricity;
data.sd_eccentricity = sd_eccentricity;
data.perimeter = perimeter;
data.avg_perimeter = avg_perimeter;
data.sd_perimeter = sd_perimeter;

xnodes = network.centroid1;           
ynodes = network.centroid0;

data.xnodes = xnodes;           
data.ynodes = ynodes;

% other properties
data.filename = filename;
    

end