clear
load('24 0287L_resistivity_data_infobridge.mat')

start_loc = 1;
end_loc = size(resistivity_data, 2);
return

%% Color surface triangulation plot

sp1 = subplot(1,1,1);
tri = delaunay(x_location(start_loc:end_loc), y_location(start_loc:end_loc));
trisurf(tri, x_location(start_loc:end_loc), y_location(start_loc:end_loc), resistivity_data);
axis([0 265 0 40])
shading interp
colorbar

% Add titles and labels to both plots
title(sp1,'Color surface Triangulation Plot')
xlabel(sp1,'Longitudinal distance [ft]')
ylabel(sp1,'Transverse distance [ft]')
sp1.FontSize = 26;

view(2)

%% Color surface griddata plot

sp1 = subplot(1,1,1);
[xg, yg] = meshgrid(linspace(0, max(x_location(start_loc:end_loc)), 1200), linspace(0, max(y_location(start_loc:end_loc)), 160));
[X, Y, Z] = griddata(x_location(start_loc:end_loc), y_location(start_loc:end_loc), resistivity_data, xg, yg);
surf(X, Y, Z)
axis([0 265 0 40])
shading interp
colorbar

% Add titles and labels to both plots
title(sp1,'Color surface Griddata Plot')
xlabel(sp1,'Longitudinal distance [ft]')
ylabel(sp1,'Transverse distance [ft]')
sp1.FontSize = 26;

view(2)

%% Color contour griddata plot

sp1 = subplot(1,1,1);
[xg, yg] = meshgrid(linspace(0, max(x_location(start_loc:end_loc)), 1200), linspace(0, max(y_location(start_loc:end_loc)), 160));
[X, Y, Z] = griddata(x_location(start_loc:end_loc), y_location(start_loc:end_loc), resistivity_data, xg, yg);
% layers = [-150 -50];
contourf(X, Y, Z, 5);
colorbar

% Add titles and labels to both plots
title(sp1,'Color Contour Plot')
xlabel(sp1,'Longitudinal distance [ft]')
ylabel(sp1,'Transverse distance [ft]')
sp1.FontSize = 26;

axis([0 265 0 40])

%% Print current figure

print(gcf,'foo.png','-dpng','-r300');
