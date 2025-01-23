% Lab 04 : edge operations
%
clear;
clc;

fname = 'lena.png';
img = imread(fname);

figure(1);
imshow(img);

imgR = double(img(:,:,1));
imgG = double(img(:,:,2));
imgB = double(img(:,:,3));
imgY = (imgR + imgG + imgB)/3;

emap = edge(imgY, 'Canny', 0.3, 10);
figure(2);
imshow(emap);

imgEg = 255*uint8(emap);
imwrite(imgEg, 'edgemap.png');

img3 = imread('edgemap.png');
figure(3);
imshow(img3);