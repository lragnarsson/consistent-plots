%% Default single plot config
clear; clc;
width = 550;
height = 400;
units = 'pixels';
menu_bar = 'figure';
plot_function = 'plot';

save('default.mat')

%% Tiny plot
clear; clc;
width = 300;
height = 200;
units = 'pixels';
menu_bar = 'none';
plot_function = 'bar';

save('tiny.mat')