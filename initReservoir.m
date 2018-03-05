%read and process files
current_dir = fileparts(mfilename('fullpath'));
fn = fullfile(current_dir, 'BENCH_SPE3.DATA'); %BENCH_SPE3.DATA who knows

deck = readEclipseDeck(fn);

%the deck is given in field units, mrst use metric, so we need convert the
%units.
deck = convertDeckUnits(deck);
save('SPE3deckASKE','deck');
G = initEclipseGrid(deck);
G = computeGeometry(G);

plotGrid(G);

rock = initEclipse(deck);
rock = compressRock(rock. G.cells.indexMap);

%create fluid
fluid = initDeckADIFluid(deck);

gravity on

% SOLUTION => equilibration data (description of how the model is to be
% initialized).
p0 = deck.SOLUTION.PRESSURE; %pressure initialized
sw0 = deck.SOLUTION.SWAT; %initialized water saturation
sg0 = deck.SOLUTION.SGAS; %initialiazed gas saturation
s0 = [sw0, 1-sw0-sg0, sg0]; 
rv0 = deck.SOLUTION.RV;
rs0 = 0;
state = struct('s', s0, 'rs', rs0, 'rv', rv0, 'pressure', p0);   
clear k p0 s0 rv0 rs0

%% Plot wells and permeability
% The permeability is constant in each layer. There is one injecting and one
% producing well.

clf;
W = processWells(G, rock, deck.SCHEDULE.control(1));
save('SPE3WASKE','W');
plotCellData(G, convertTo(rock.perm(:,1), milli*darcy), ...
             'FaceAlpha', .5, 'EdgeAlpha', .3, 'EdgeColor', 'k');
plotWell(G, W, 'fontsize', 10, 'linewidth', 1);
title('Permeability (mD)')
axis tight;
view(35, 40);

