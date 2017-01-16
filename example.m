%% Example usage of the consistent plot function
close all;
x = [0:0.1:10]';
y = [3 * x.^2 - 4.*x + 2, ...
     2 * x.^2 + 5.*x - 5];

consplot(x, y, ...
         'title', 'The Plot', ...
         'legend', {'foo', 'bar'}, ...
         'xlim', [0, 12], ...
         'save', 'my-plot', ...
         'format', '-depsc')

%% Plot many tiny plots next to eachother
close all;
M = 100;
n_plots = 12;
for k = 1:n_plots
    Y = round(20 * rand(M, 1) - 10);
    X = [1:M]';
    consplot(X, Y, 'config', 'tiny', 'title', ['Plot ', num2str(k)])
end