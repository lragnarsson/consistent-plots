Consistent Plots for MatLab
--------
Small utility class which simplifies the process of
saving consistent looking plots. Create and save predefined
plot configs for different purposes. Useful for writing reports
with many figures.

### Example
´´´Matlab
x = [0:0.1:10]';
y = [3 * x.^2 - 4.*x + 2, ...
     2 * x.^2 + 5.*x - 5];

foo = consfig(x, y);
consplot(foo);
´´´

### Example 2
´´´Matlab
x = [0:0.1:10]';
y = [3 * x.^2 - 4.*x + 2, ...
     2 * x.^2 + 5.*x - 5];

foo = consfig(x, y, ...
             'title', 'Foobar', ...
             'legend', {'foo', 'bar'}, ...
             'color_order', 'red_range_4', ...
             'xlabel', 'Raboof [Hz]');

consplot(foo, 'config', 'some_config');
´´´
