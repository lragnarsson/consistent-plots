classdef consfig
    properties
        x
        y
        options
        color_order
    end
    methods
        function obj = consfig(x, y, varargin)
            obj.y = y;
            obj.x = x;
            
            options = struct('title', '', ...
                 'xlabel', '', ...
                 'ylabel', '', ...
                 'ylabel2', '', ...
                 'xlim', [], ...
                 'ylim', [], ...
                 'ylim2', [], ...
                 'legend', 0, ...
                 'color_order', 'distinct_4', ...
                 'lineWidth', 1, ...
                 'xticks', 'auto', ...
                 'yticks', 'auto', ...
                 'stemLines', []);
            option_names = fieldnames(options);
            n_args = length(varargin);
            if mod(n_args, 2)
               error('All optional arguments come as key-value pairs!')
            end

            for pair = reshape(varargin, 2, [])
               i_name = pair{1};   
               if any(strcmp(i_name, option_names))
                  options.(i_name) = pair{2};
               else
                  error('%s is not a recognized parameter name', i_name);
               end
            end
            if options.('ylabel2')
                if min(size(y)) ~= 2
                    error('Can only use 2 y axes with two data series');
                end
            end
            obj.options = options;
            % Load color order
            load(['plot-configs/', lower(options.color_order)]);
            obj.color_order = color_order;
        end
        function fig = consplot(obj, varargin)
            % Handle optional arguments:
            plt_options = struct('subplots', [], ...
                                 'config', 'default', ...
                                 'save', '', ...
                                 'format', '-depsc', ...
                                 'linkAxes', 'xy');

            option_names = fieldnames(plt_options);
            n_args = length(varargin);
            if mod(n_args, 2)
               error('All optional arguments come as key-value pairs!')
            end

            for pair = reshape(varargin, 2, [])
               i_name = pair{1};   
               if any(strcmp(i_name, option_names))
                  plt_options.(i_name) = pair{2};
               else
                  error('%s is not a recognized parameter name',i_name);
               end
            end
            % Load correct config file
            load(['plot-configs/', lower(plt_options.config)]);

            % Calculate screen position for figure based on last figure position
            resolution = get(groot, 'Screensize');
            y_margin = 100;
            fig = get(groot,'CurrentFigure');
            if isempty(ishandle(fig)) % First fig
                x0 = 1;
                y0 = resolution(4) - height - y_margin;
            else % Place next to last fig
                last_pos = get(fig, 'Position');
                if resolution(3) - last_pos(1) - last_pos(3) >= 0.3*width % Place to the right
                   x0 = last_pos(1) + last_pos(3);
                   y0 = last_pos(2);
                elseif resolution(4) - last_pos(2) - last_pos(4) >= 0.3*height % Start on new row
                   x0 = 1;
                   y0 = last_pos(2) - last_pos(4);
                else % Restart at the top left
                   x0 = 1;
                   y0 = resolution(4) - height - y_margin;
                end
            end

            fig = figure('units', units, ...
                         'position', [x0, y0, width, height], ...
                         'MenuBar', menu_bar);
                     
            plot_fn = str2func(plot_function);
            objs = [obj];
            for sp = 1:length(plt_options.subplots)
                objs(1+sp) = plt_options.subplots(sp);
            end
            
            % Plot
            axes = zeros(length(objs), 1);
            for plt = 1:length(objs)
                plt_obj = objs(plt);
                axes(plt) = subplot(rows, columns, plt);
                set(groot, 'defaultAxesColorOrder', plt_obj.color_order, ...
                    'defaultAxesLineStyleOrder','-|--|:');
                
                if plt_obj.options.('ylabel2') % Handle 2 y axes
                    hold on
                    yyaxis left;
                    plot_fn(plt_obj.x, plt_obj.y(1,:), 'lineWidth', plt_obj.options.lineWidth);
                    ylabel(plt_obj.options.ylabel);
                    
                    yyaxis right
                    plot_fn(plt_obj.x, plt_obj.y(2,:), 'lineWidth', plt_obj.options.lineWidth);
                    ylabel(plt_obj.options.ylabel2);
                    hold off
                    yyaxis left;
                else
                    plot_fn(plt_obj.x, plt_obj.y, 'lineWidth', plt_obj.options.lineWidth);
                    ylabel(plt_obj.options.ylabel);
                end

                
                % Apply optional arguments:
                title(plt_obj.options.title);
                xlabel(plt_obj.options.xlabel);
                xticks(plt_obj.options.xticks);
                yticks(plt_obj.options.yticks);
                if ~isempty(plt_obj.options.stemLines)
                    hold on;
                    color_diff = size(plt_obj.color_order, 1) - size(plt_obj.y, 2);
                    for cd = 1:color_diff
                        plot(0);
                    end
                    for stemseries = 1:length(plt_obj.options.stemLines)
                        stem(plt_obj.options.stemLines{stemseries}(:,1), ...
                             plt_obj.options.stemLines{stemseries}(:,2), 'Marker', 'none', ...
                             'lineWidth', 1);
                    end
                    hold off;
                end
                
                if isequal(size(plt_obj.options.xlim), [1, 2])
                    xlim(plt_obj.options.xlim);
                else
                    xlim([min(plt_obj.x), max(plt_obj.x)]);
                end
                if isequal(size(plt_obj.options.ylim), [1, 2])
                    if plt_obj.options.('ylabel2') % Handle 2 y axes
                        ylim(plt_obj.options.ylim);
                        yyaxis right;
                        ylim(plt_obj.options.ylim2);
                    else
                        ylim(plt_obj.options.ylim);
                    end
                end
                if iscell(plt_obj.options.legend)
                    legend(plt_obj.options.legend);
                end
            end

            linkaxes(axes, plt_options.linkAxes);
            
            % Save file:
            if ~strcmp(plt_options.save, '')
                print(fig, plt_options.save, plt_options.format);
                close;
            end

            set(groot,'defaultAxesLineStyleOrder','remove');
            set(groot,'defaultAxesColorOrder','remove');
        end
    end
end