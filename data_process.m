clear
load('24_0287L_IE_data_infobrdige.mat')
return
%% Processing

low_bound = 1000;
up_bound = 20000;

start_loc = 1;
end_loc = size(ie_signal, 1);

np = size(ie_signal, 2);
sr = sampling_freq*1000;
sd = np/sr;
t_ax = [0:1/sr:1/sr*(np-1)];

slab_freq = zeros(end_loc - start_loc + 1, 1);

low_coord = round(low_bound*sd);
up_coord = round(up_bound*sd);

for ii = start_loc:end_loc
    t_am = ie_signal(ii, :);
    f_am = abs(fft(t_am));
    f_ax = [0:1/sd:1/sd*(np-1)];
        
    [maxa, maxf] = max(f_am(low_coord:up_coord));
    slab_freq(ii - start_loc + 1) = f_ax(maxf+low_coord-1);
end

%% Plot single test

signal_number = 2178;
split_freq = 5/10;

% Define 2 subplots
sp1=subplot(2,1,1);
sp2=subplot(2,1,2);

t_am = ie_signal(signal_number + start_loc -1, :);
f_am = abs(fft(t_am));
f_ax = [0:1/sd:1/sd*(np-1)];

plot(sp1, t_ax, t_am)
plot(sp2, f_ax(1:round(end*split_freq)), f_am(1:round(end*split_freq)))

% Add titles and labels to both plots
title(sp1,'Time Domain Signal')
xlabel(sp1,'Time [s]')
ylabel(sp1,'Amplitude')

title(sp2,'Frequency Domain Signal')
xlabel(sp2,'Frequency [Hz]')
ylabel(sp2,'Amplitude')

sp1.FontSize = 26;
sp2.FontSize = 26;

%% Sound slab mean frequency

low_bound = 6000;
up_bound = 14000;
slab_freq_range = [];

for ii = 1:size(slab_freq, 1)
    if slab_freq(ii)>low_bound & slab_freq(ii)<up_bound
        slab_freq_range = [slab_freq_range; slab_freq(ii)];
    end
end

slab_freq_range_mean = mean(slab_freq_range)

%% Fundamental Frequencies plot

sp1 = subplot(1,1,1);
plot(slab_freq)

% Add titles and labels to both plots
title(sp1,'Fundamental Frequencies')
xlabel(sp1,'Data point number')
ylabel(sp1,'Frequency [Hz]')
sp1.FontSize = 26;

%% Fundamental Frequencies Histogram

sp1 = subplot(1,1,1);
histogram(slab_freq, 100)

% Add titles and labels to both plots
title(sp1,'Fundamental Frequencies Histogram')
xlabel(sp1,'Frequency [Hz]')
ylabel(sp1,'Number of cases')
sp1.FontSize = 26;

%% Color surface triangulation plot

sp1 = subplot(1,1,1);
tri = delaunay(x_location(start_loc:end_loc), y_location(start_loc:end_loc));
trisurf(tri, x_location(start_loc:end_loc), y_location(start_loc:end_loc), slab_freq);
axis([0 265 0 40])
shading interp
colorbar

% Add titles and labels to both plots
title(sp1,'Color surface Triangulation Plot')
xlabel(sp1,'Longitudinal distance [ft]')
ylabel(sp1,'Transverse distance [ft]')
sp1.FontSize = 26;
colormap parula

view(2)

%% Color surface griddata plot

sp1 = subplot(1,1,1);
[xg, yg] = meshgrid(linspace(0, max(x_location(start_loc:end_loc)), 1200), linspace(0, max(y_location(start_loc:end_loc)), 160));
[X, Y, Z] = griddata(x_location(start_loc:end_loc), y_location(start_loc:end_loc), slab_freq, xg, yg);
surf(X, Y, Z)
axis([0 265 0 40])
shading interp
colorbar

% Add titles and labels to both plots
title(sp1,'Color surface Griddata Plot')
xlabel(sp1,'Longitudinal distance [ft]')
ylabel(sp1,'Transverse distance [ft]')
sp1.FontSize = 26;
colormap parula

view(2)

%% Color contour griddata plot

sp1 = subplot(1,1,1);
[xg, yg] = meshgrid(linspace(0, max(x_location(start_loc:end_loc)), 1200), linspace(0, max(y_location(start_loc:end_loc)), 160));
[X, Y, Z] = griddata(x_location(start_loc:end_loc), y_location(start_loc:end_loc), slab_freq, xg, yg);
layers = [0 4000 15000];
contourf(X, Y, Z, layers);
colorbar

% Add titles and labels to both plots
title(sp1,'Color Contour Plot')
xlabel(sp1,'Longitudinal distance [ft]')
ylabel(sp1,'Transverse distance [ft]')
sp1.FontSize = 26;

axis([0 265 0 40])

%% Point ID finder

sp1 = subplot(1,1,1);
scatter3(x_location(start_loc:end_loc), y_location(start_loc:end_loc), [1:size(x_location(start_loc:end_loc),2)], 4, [1:size(x_location(start_loc:end_loc),2)])
colorbar

% Add titles and labels to both plots
title(sp1,'Point Id Finder Plot')
xlabel(sp1,'Longitudinal distance [ft]')
ylabel(sp1,'Transverse distance [ft]')
sp1.FontSize = 26;

axis([0 265 0 40])
view(2)

%% Print current figure

print(gcf,'foo.png','-dpng','-r300');
