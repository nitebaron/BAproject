%this script designs a user-friendly app that will allow for easy 
%selection of different configurations of the cryostat.
%at the moment it also calls some functions that contribute to the head load
%example run: initial(50.79242585,3.742368096);
%inputs are initial plate temperature and outputs will be different heat loads
function initial(Xq,Yq)
%current leads configuration

%read table
S = table2array(readtable('Choice.xlsx','ReadVariableNames',false));

%create array for assigning a number to each current configuration
Config = S(:,1);
Config = Config(2:end);
i_items = {};
selection = [];
for i = 1:length(Config)
    i_items(i) = Config(i);
    selection(i) = i;
end

%starts app
fig = uifigure('Name','Cryostat Configuration');
fig.Position = [100 100 640 480];

%label current leads configuration
label1 = uilabel(fig);
label1.FontSize = 16;
label1.Position = [49 359 212 20];
label1.Text = 'Current Leads Configuration';

%label for cooler type
label2 = uilabel(fig)
label2.FontSize = 16;
label2.Position = [297 359 97 20]
label2.Text = 'Cooler Type';

%dropdown menu for current configuration choices
d1 = uidropdown(fig,...
    'Position',[31 322 230 22],...
    'Items',i_items,...
    'ItemsData',selection,...
    'ValueChangedFcn',@(d1,event) assign1(d1,S));

%dropdown menu for cooler type choices
d2 = uidropdown(fig,...
    'Position',[293.703125 322 100 22],...
    'Items',{'1W','1.5W','2W','3W'},...
    'ItemsData',[1,1.5,2,2.5,3],...
    'ValueChangedFcn',@(d2,event) cooling(d2,Xq,Yq))

% Create StartButton
StartButton = uibutton(fig, 'push');
StartButton.Position = [403 130 114 22];
StartButton.Text = 'Start';

%calculate heat load from current leads
T_hot = 300;

end

%calculate coldhead cooling power
function [cooling_powerPT1, cooling_powerPT2] = cooling(d2,Xq,Yq)
power = d2.Value;
powers = power*coldhead(Xq,Yq);
cooling_powerPT1 = powers(1)
cooling_powerPT2 = powers(2)
end

%this function assigns values to dimenions within the current leads e.g.
%inner and outer length & cross sections 
function assign1(d1,S)
value = d1.Value;
L1_length_in = converter(value,S,2);
L2_length_in = converter(value,S,6);
A1_csection_in = converter(value,S,4);
A2_csection_in = converter(value,S,8);
L1_length_out = converter(value,S,3);
L2_length_in = converter(value,S,6);
L2_length_out = converter(value,S,7);
A1_csection_in = converter(value,S,4);
A1_csection_out = converter(value,S,5);
A2_csection_in = converter(value,S,8);
A2_csection_out = converter(value,S,9);

heat_conduction = conduction(L1_length_in,A1_csection_in,L2_length_in,A2_csection_in)
resistive_heat = resistance(L1_length_in,A1_csection_in,L2_length_in,A2_csection_in)
end

%this extracts what we need, e.g. length or cross section column, after
%which it takes the number based on the dropdown choice and finally
%converts it to a double from a string
function [variable] = converter(value,S,i)
variable = S(:,i);
variable = variable(2:end);
variable = variable(value);
variable = str2num(cell2mat(variable));
end
