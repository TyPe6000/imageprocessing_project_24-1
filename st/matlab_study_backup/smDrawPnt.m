function [imgout] = smDrawPnt(img,pnt,color)
% 영상, 포인트, 색을 입력받아 imgout을 출력함
% pnt = [r1,c1; r2,c2; .... ; rn,cn]
% color = [R, G, B]
% img  row x col x color

R = color(1);
G = color(2);
B = color(3);

[row,col] = size(pnt);
num = row;

for n=1:num
    r = pnt(n,1);
    c = pnt(n,2);

    img(r,c,1) = color(1);
    img(r,c,2) = color(2);
    img(r,c,3) = color(3);
end


imgout = img;

