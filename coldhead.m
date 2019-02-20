%this function uses spline interpolation to get a coldhead power using a
%set of measurements and the user defined choice for cooling power

function [powers] = coldhead(Xq,Yq)

%read excel table
interpolate = readtable('interpolation.xlsx','ReadVariableNames',false);

%extract measured data out
x = convert(interpolate,1);
y = convert(interpolate,2);
f = convert(interpolate,3);
s = convert(interpolate,4);

%conduct interpolation
pt1 = griddata(x,y,f,Xq,Yq);
pt2 = griddata(x,y,s,Xq,Yq);

powers = [pt1 pt2];
end

%this function converts data to format that can be used for interpolation
function data = convert(table,index)
data = table2array(table(:,index));
data = data(2:end);
data = cellfun(@str2num,data)
end