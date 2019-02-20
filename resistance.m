%calculates resistive heating due to currents based on initial choices made
function [heat_resistance] = resistance(a,b,c,d)
%electrical conductivity of brass 
conductivity = 18695831.28

%calculates a ratio, for instance 1/((L1/A1 + L2/A2))
AoverL = 1/((a/b+c/d))
heat_resistance = (120^2)/AoverL/conductivity*1000;
end