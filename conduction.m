%calculates heat conduction based on dropdown choice made
function [heat_conduction] = conduction(a,b,c,d)

%conductivity integral for brass
conductivity_integral = 19324.03083;

%calculates a ratio, for instance 1/((L1/A1 + L2/A2))
AoverL = 1/((a/b+c/d))
heat_conduction = AoverL*conductivity_integral/1000;
end