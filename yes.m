%Viktoria

%this script designs a user-friendly app that will allow for easy 
%selection of different configurations of the cryostat.
function yes
%current leads configuration
Xq = 50;
Yq = 4;
%read tables
S = table2array(readtable('Choice.xlsx','Sheet','Current','ReadVariableNames',false));
T = table2array(readtable('Choice.xlsx','Sheet','Triton','ReadVariableNames',false));

%create array for assigning a number to each current configuration
[selection1, items1] = configuration(S);
[selection2, items2] = configuration(T);

%starts app
fig = uifigure('Name','Cryostat Configuration');
fig.Position = [100 100 640 480];

%label current leads configuration
label1 = uilabel(fig);
label1.FontSize = 16;
label1.Position = [49 359 212 20];
label1.Text = 'Current Leads Configuration';

%label for cooler type
label2 = uilabel(fig);
label2.FontSize = 16;
label2.Position = [297 359 97 20];
label2.Text = 'Cooler Type';

%label for fridge and tail set
label3 = uilabel(fig);
label3.FontSize = 16;
label3.Position = [438 359 140 20];
label3.Text = 'Fridge and Tail Set';

%dropdown menu for current configuration choices
d1 = uidropdown(fig,...
    'Position',[31 322 230 22],...
    'Items',items1,...
    'ItemsData',selection1,...
    'ValueChangedFcn',@(d1,event) assign1);

%dropdown menu for cooler type choices
d2 = uidropdown(fig,...
    'Position',[293.703125 322 100 22],...
    'Items',{'1W','1.5W','2W','3W'},...
    'ItemsData',[1,1.5,2,2.5,3],...
    'ValueChangedFcn',@(d2,event) cooling(d2,Xq,Yq));

%dropdown menu for fridge and tail set
d3 = uidropdown(fig,...
    'Position',[435.703125 319 100 22],...
    'Items',items2,...
    'ItemsData',selection2,...
    'ValueChangedFcn',@(d3,event) setvalues(d3,T));

% Create StartButton

StartButton = uibutton(fig, ...
    'push',...
    'Position',[403 130 114 22],...
    'Text','Start',...
    'ButtonPushedFcn',@(StartButton,event) pushbutton);

%% these are the callback functions that act upon selecting a choice

%calculate coldhead cooling power
function [cooling_powerPT1, cooling_powerPT2] = cooling(d2,Xq,Yq)
power = d2.Value;
powers = power*coldhead(Xq,Yq);
cooling_powerPT1 = powers(1);
cooling_powerPT2 = powers(2);
end

%this function sets the length of various components based on initial
%choice made in the dropdown menu 
function [PT1length,PT2length,magnetlength] = setvalues(d3,T)
value = d3.Value;
PT1length = converter(value,T,2);
PT2length = converter(value,T,3);
magnetlength = converter(value,T,4);
end

%this function assigns values to dimenions within the current leads e.g.
%inner and outer length & cross sections 
%and calculates heat loads due to current leads
    function assign1
    value = d1.Value;
    L1_length_in = converter(value,S,2);
    A1_csection_in = converter(value,S,4);
    L2_length_in = converter(value,S,6);
    A2_csection_in = converter(value,S,8);
    L1_length_out = converter(value,S,3);
    L2_length_out = converter(value,S,7);
    A1_csection_out = converter(value,S,5);
    A2_csection_out = converter(value,S,9);
    quantity1 = converter(value,S,10);
    quantity2 = converter(value,S,11);
    quantity3 = converter(value,S,12);
    l1_3length = converter(value,S,13);
    l1_3olength = converter(value,S,14);
    area31 = converter(value,S,15);
    area32 = converter(value,S,16);

    heat_conduction = quantity1*2*conduction(L1_length_in,A1_csection_in,L2_length_in,A2_csection_in) ...
        + quantity2*2*conduction(L1_length_out,A1_csection_out,L2_length_out,A2_csection_out) ...
        + quantity3*conduction(l1_3olength,area32,L2_length_out,A2_csection_out) ...
        + quantity3*conduction(l1_3length,area31,L2_length_in,A2_csection_in);
    setappdata(d1,'name',heat_conduction);
    resistive_heat = 2*quantity1*resistance(L1_length_in,A1_csection_in,L2_length_in,A2_csection_in)
    end

    function pushbutton
       
        heat_conduction = getappdata(d1,'name')
    end
end

%% these functions help with bookkeeping

%this extracts what we need, e.g. length or cross section column, after
%which it takes the number based on the dropdown choice and finally
%converts it to a double from a string
function [variable] = converter(value,S,i)
variable = S(:,i);
variable = variable(2:end);
variable = variable(value);
variable = str2num(cell2mat(variable));
end

%this will select the data column we need
function [selection, i_items] = configuration(table)
config = table(:,1);
config = config(2:end);
i_items = {};
selection = [];
for i = 1:length(config)
    i_items(i) = config(i);
    selection(i) = i;
end

end
