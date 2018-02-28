mrstModule add incomp

gravity reset on

%dimensions of the grid
nx = 9;
ny = 9;
nz = 4;

%parameters of the wells
bhp = 1*barsa;
radius = 0.1; %10cm

%create the grid
G = cartGrid([nx, ny, nz]);
G = computeGeometry(G);

%create rock data structure
rock.perm = repmat(100*milli*darcy, [G.cells.num, 1]);

%two-phase fluid (apply with three before)
fluid = initSimpleFluid('mu', [1, 10]*centi*poise, ...
                        'rho',[1014, 859]*kilogram/meter^3, ...
                        'n', [2, 2]);
    

%create the injector well. Cartesian coordenates are (x,y,z) with x and
%y equal 1 and z are completed by the number of the layers []
W = verticalWell([], G, rock, 1, 1, [], ... 
                'Type', 'bhp', 'Val', bhp, ...
                'Radius', radius, 'InnerProduct', 'ip_tpf', ...
                'Com_i', [0, 1]);

%create the producer well. Same coordenates then injector well but in
%other cells, (x,y,z) = (9,9,[])
W = verticalWell(W, G, rock, 9, 9, [], ...
                'Type', 'bhp' , 'Val', 0*barsa(), ...
                'Radius', 0.1, 'InnerProduct', 'ip_tpf', ...
                'Comp_i', [1, 0]);
        

%create a initialized state
sol = initState(G, [], 0, [1, 0]);

T = computeTrans(G, rock);

pressureSolve = @(state) incompTPFA(state, G, T, fluid, 'wells', W);
                                            
sol= pressureSolve(sol);
clf;
plotCellData(G, sol.pressure)
colorbar
view(30,50)
axis tight

