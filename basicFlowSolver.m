% basic flow-solver tutorial
% single-phase

% dimensions of the grid
nx = 10;
ny = 10;
nz = 4;

% construction of the grid
G = cartGrid([nx ,ny, nz]);
display(G);

plotGrid(G);
view(3), camproj orthographic, axis tight, camlight headlight

G = computeGeometry(G);

% set rock and fluid data
% single-phase the only parameters needed is permeability and fluid
% viscosity

%filled all cells of the grid with rock permeability
rock.perm = repmat([1000, 100, 10].*milli*darcy(),[G.cells.num, 1]);
display(rock.perm);

%module of incompressible fluid
mrstModule add incomp

fluid = initSingleFluid('mu', 1*centi*poise, 'rho', 1014*kilogram/meter^3);

%initializing the reservoir simulator
resSol = initResSol(G, 0, 0);

%impose boundary conditions
bc = fluxside([], G, 'LEFT', 1*meter^3/day());
bc = pside(bc, G, 'RIGHT', 0);

%construct linear system without gravity in this case
gravity off;
mrstModule add mimetic
S = computeMimeticIP(G, rock);

clf, subplot(1,2,1)

cellNo = rldecode(1:G.cells.num, diff(G.cells.facePos), 2) .';

C = sparse(1:numel(cellNo), cellNo, 1); 
D = sparse(1:numel(cellNo), double(G.cells.faces(:,1)), 1, numel(cellNo), G.faces.num);


spy([S.BI               , C        , D        ; ...
     C', zeros(size(C,2), size(C,2) + size(D,2)); ...
     D', zeros(size(D,2), size(C,2) + size(D,2))]);
title('Hybrid pressure system matrix')
