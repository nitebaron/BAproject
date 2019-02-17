function [x,y] = PT1(bs,s)
% This function defines the geometry of the PT1 plate
% with a circular hole that corresponds to the coldhead
if nargin == 0
  % eight edge segments
  x = 8; 
  return
end
if nargin == 1
    %plate
    dlc = [0,pi/2,pi,3*pi/2; % start parameter values
           pi/2,pi,3*pi/2,2*pi; % end parameter values
           1,1,1,1; % region label to left
           0,0,0,0]; % region label to right
       
    % Inner circular hole
    dlh = [0,      pi/2,   pi,       3*pi/2;
           pi/2,   pi,     3*pi/2,   2*pi;
           0,      0,      0,        0; % To the left is empty
           1,      1,      1,        1]; % To the right is region 2
    % Combine the three edge matrices
    dl = [dlc,dlh];
    x = dl(:,bs);
    return
end
x = zeros(size(s));
y = zeros(size(s));
if numel(bs) == 1 
    bs = bs*ones(size(s)); % Expand bs
end
cbs = find(bs < 5); %circle
x(cbs) = 0.227*cos(s(cbs));
y(cbs) = 0.227*sin(s(cbs));

cbs = find(bs >= 5); 
x(cbs) = 0.125 + 0.061*cos(s(cbs));
y(cbs) = -0.095 + 0.061*sin(s(cbs));
end