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
                 'xlim', [], ...
                 'ylim', [], ...
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
                                 'format', '-depsc');

            option_names = fieldnames(plt_options);
            n_args = length(varargin);
            if mod(n_args, 2)
               error('All optional arguments come as key-value pairs!')
            end

            for pair = reshape(varargin, 2, [])
               i_name = lower(pair{1});   
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

            fig = figure('units', units, ...
                         'position', [x0, y0, width, height], ...
                         'MenuBar', menu_bar);
                     
            plot_fn = str2func(plot_function);
            objs = [obj];
            for sp = 1:length(plt_options.subplots)
                objs(1+sp) = plt_options.subplots(sp);
            end
            
            % Plot
            for plt = 1:length(objs)
                plt_obj = objs(plt);
                subplot(rows, columns, plt);
                set(groot, 'defaultAxesColorOrder', plt_obj.color_order, ...
                    'defaultAxesLineStyleOrder','-|--|:');
                plot_fn(plt_obj.x, plt_obj.y, 'lineWidth', plt_obj.options.lineWidth);

                % Apply optional arguments:
                title(plt_obj.options.title);
                xlabel(plt_obj.options.xlabel);
                ylabel(plt_obj.options.ylabel);
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
                             plt_obj.options.stemLines{stemseries}(:,2), 'Marker', 'none');
                    end
                    hold off;
                end
                if isequal(size(plt_obj.options.xlim), [1, 2])
                    xlim(plt_obj.options.xlim);
                else
                    xlim([min(plt_obj.x), max(plt_obj.x)]);
                end
                if isequal(size(plt_obj.options.ylim), [1, 2])
                   ylim(plt_obj.options.ylim);
                end
                if iscell(plt_obj.options.legend)
                    legend(plt_obj.options.legend);
                end
            end

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