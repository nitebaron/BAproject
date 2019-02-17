function F = PDEsolver(coldhead,flux,PT)
%this script solves Poisson's equation as appropriate
%for the PT plates with an off-central coldhead.
%it takes heat flux around the perimeter as an boundary condition
%which is extrapolated from measurements taken 

%INPUTs
% -coldhead = coldhead temperature (from experimental data)
% for PT1 it's ~40, for PT2 it's around ~4 (units of Kelvin)
% -flux = heat flux at the perimeter (from experimental data)
% for PT1 heat flux is ~30 based on trial and error compared to
% measurements, for PT2 it's ~ (units of Wm^-2)
% - PT is either 1 or 2, for PT1 and PT2 respectively.
%
%OUTPUT
% - temperature colourmap of PT plates
% for example PDEsolver(4,0.5,2) returns the temperature colour map of PT1.

model = createpde;
%C1 = [1,0,0,1]'; 
%C2 = [1,0.2,-0.2,0.3]'; %coldhead
%C1 = [C1;60.*ones(length(C1),1)];
%C2 = [C2;4.*ones(length(C2),1)];
%gm = [C1,C2]
%sf = 'C1-C2';
%ns = (char('C1','C2'))';
%g = decsg(gm,sf,ns);
%geometryFromEdges(model,g);
if PT == 1
    geometryFromEdges(model,@PT1);
else
    geometryFromEdges(model,@PT2);
end
pdegplot(model,'EdgeLabels','on')
%coldhead constant cooling power boundary condition
applyBoundaryCondition(model,'dirichlet','Edge',5:8,'u',coldhead);
%applyBoundaryCondition(model,'dirichlet','Edge',1:4,'u',50);
%heat flux boundary condition
applyBoundaryCondition(model,'neumann','Edge',1:4,'g',flux);
specifyCoefficients(model,'m',0,'d',0,'c',1,'a',0,'f',0);
generateMesh(model,'HMax',0.01);
setInitialConditions(model,60);
results = solvepde(model);
u = results.NodalSolution;
pdeplot(model,'XYData',u);
title('Temperature gradient by an off-central cooling power');
xlabel('distance (m)');
ylabel('distance (m)');
colormap jet
hcb=colorbar
title(hcb,'T (K)')
