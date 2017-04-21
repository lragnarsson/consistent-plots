%% Default single plot config
clear; clc;
width = 550;
height = 400;
units = 'pixels';
menu_bar = 'figure';
plot_function = 'plot';
rows = 1;
columns = 1;

save('default.mat')

%% 2 Row plot
clear; clc;
width = 550;
height = 500;
units = 'pixels';
menu_bar = 'none';
plot_function = 'plot';
rows = 2;
columns = 1;

save('2_row.mat')

%% 3 Row plot
clear; clc;
width = 550;
height = 500;
units = 'pixels';
menu_bar = 'none';
plot_function = 'plot';
rows = 3;
columns = 1;

save('3_row.mat')


%% Color Order Distinct 4
clear; clc;
color_order = [
    79,82,210;
    228,50,68;
    107,187,49;
    230,119,31] ./ 255;
save('distinct_4.mat')

%% Color Order Blue Range 8
clear; clc;
color_order = [
    74,110,226;
    96,78,218;
    163,106,223;
    157,63,222;
    152,56,176;
    222,76,213;
    195,64,163;
    219,56,146] ./ 255;
save('blue_range_8.mat');

%% Color Order Red range 4
clear; clc;
color_order = [
    229,39,64;
    227,52,33;
    233,83,20;
    243,149,18] ./ 255;
save('red_range_4.mat');

%% Color Order Purple range 3
clear; clc;
color_order = [
    92,42,167;
    116,104,220;
    193,75,202] ./ 255;
save('purple_range_3.mat');

%% Color Order Spectrum range 4
clear; clc;
color_order = [
    66,173,210;
    101,168,81;
    192,152,59;
    189,79,61] ./ 255;
save('spectrum_range_4.mat');
