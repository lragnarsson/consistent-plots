function [ fig ] = consplot(x, y, varargin)
%CONSPLOT Create plots with consistent appearence using preset
%configurations.
%   Detailed explanation...

% Loaded from config file:
% height, width, units, plot_function

% Handle optional arguments:
options = struct('config', 'default', ...
                 'save', '', ...
                 'format', '-depsc', ...
                 'title', '', ...
                 'xlim', [], ...
                 'ylim', [], ...
                 'legend', 0);

option_names = fieldnames(options);
n_args = length(varargin);
if round(n_args/2)~=n_args/2
   error('All optional arguments come as key-value pairs!')
end

for pair = reshape(varargin, 2, [])
   i_name = lower(pair{1});   
   if any(strcmp(i_name, option_names))
      options.(i_name) = pair{2};
   else
      error('%s is not a recognized parameter name',i_name)
   end
end

% Load correct config file
load(['plot-configs/', lower(options.config)])

% Calculate screen position for figure based on last figure position
resolution = get(groot, 'Screensize');
y_margin = 100;
fig = get(groot,'CurrentFigure');
if isempty(ishandle(fig)) % First fig
    x0 = 1;
    y0 = resolution(4) - height - y_margin;
else % Place next to last fig
    last_pos = get(fig, 'Position');
    if resolution(3) - last_pos(1) - last_pos(3) >= width % Place to left
       x0 = last_pos(1) + last_pos(3);
       y0 = last_pos(2);
    elseif resolution(4) >= height % Start on new row
       x0 = 1;
       y0 = last_pos(2) - last_pos(4);
    else % All empty, restart at the top right
       x0 = 1;
       y0 = 1;
    end
end

% Plot
fig = figure('units', units, ...
             'position', [x0, y0, width, height], ...
             'MenuBar', menu_bar);
plot_fn = str2func(plot_function);
plot_fn(x, y);

% Apply optional arguments:
title(options.title)
if isequal(size(options.xlim), [1, 2])
   xlim(options.xlim);
end
if isequal(size(options.ylim), [1, 2])
   ylim(options.ylim);
end
if iscell(options.legend)
    legend(options.legend);
end

% Save file:
if ~strcmp(options.save, '')
    print(fig, options.save, options.format);
end

% That's all folks!
end

