% lab05 : drawing
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

color = [255, 255, 255];

for n=1:50
    pnt(n,1) = 100 + n ;
    pnt(n,2) = 100 + n ;
end

imgOut = smDrawPnt(img,pnt,color);

imshow(imgOut);