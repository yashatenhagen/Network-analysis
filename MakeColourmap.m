function [cmap] = MakeColourmap(norm, L)
% Created on 18/08/2021 by Yasha Tenhagen.

% Make logicals of normalised arrays and create an empty colourmap
cmap = zeros(max(L(:)), 3);                                            % Create an empty colourmap matrix

L_one = (norm <= 1);
L_two = (norm <= 2) & (norm > 1);
L_three = (norm <= 3) & (norm > 2);
L_four = (norm <= 4) & (norm > 3);

% Fill colourmap for values between 0 and 1
cmap(:,3) = cmap(:,3) + L_one;
cmap(:,2) = cmap(:,2) + L_one.*norm;

% Fill colourmap for values between 1 and 2
cmap(:,2) = cmap(:,2) + L_two;
cmap(:,3) = cmap(:,3) + L_two - (L_two.*(norm - 1));

% Fill colourmap for values between 2 and 3
cmap(:,2) = cmap(:,2) + L_three;
cmap(:,1) = cmap(:,1) + L_three.*(norm - 2);

% Fill colourmap for values between 3 and 4
cmap(:,1) = cmap(:,1) + L_four;
cmap(:,2) = cmap(:,2) + L_four - (L_four.*(norm - 3));

end