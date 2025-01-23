function [pnt] = pntLine(lineinfo)
%
% lineinfo = [r1, c1, r2, c2]

r1 = lineinfo(1);
r2 = lineinfo(3);
c1 = lineinfo(2);
c2 = lineinfo(4);

len = ceil(sqrt((r1-r2)^2 + (c1-c2)^2));
t = 0 : 1/len : 1;
% length
r = (r2-r1)*t + r1;
c = (c2-c1)*t + c1;
% t값이 vector이므로 r,c도 vector
pnt = [r(:),c(:)];
