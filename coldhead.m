%this function uses spline interpolation to get a coldhead power
%from a set of data

inter = readtable('interpolation.xlsx','ReadVariableNames',false);

x = table2array(inter(:,1));
x = x(2:end);
x = str2num(cell2mat(x));

y = table2array(inter(:,2));
y = y(2:end);
y = str2double(y);

f = table2array(inter(:,3));
f = f(2:end);
f = str2double(f);

f2 = inter(:,4);
f2 = table2array(f2);
f2 = f2(2:end);
f2 = str2double(f2);

Xq = 50.79242585;
Yq = 3.742368096;

vq = griddata(x,y,f,Xq,Yq)