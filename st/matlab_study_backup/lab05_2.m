% Clear workspace and command window
clear;
clc;

% Load the image
fname = 'lena.png';
img = imread(fname);

% Display the original image
figure(1);
imshow(img);

% Convert image to double precision for processing
imgR = double(img(:,:,1));
imgG = double(img(:,:,2));
imgB = double(img(:,:,3));
imgY = (imgR + imgG + imgB)/3;

% Define the color for the square (white in this case)
color = [255, 255, 255];

% Define the size and position of the square
square_size = 50; % Size of the square in pixels
start_row = 100; % Starting row of the square
start_col = 100; % Starting column of the square

% Iterate over each pixel in the square region and set its color
for i = start_row : start_row + square_size - 1
    for j = start_col : start_col + square_size - 1
        img(i, j, :) = color;
    end
end

% Display the modified image
figure(2);
imshow(uint8(img));
