Consistent Plots for MatLab
--------
Small utility class which simplifies the process of
saving consistent looking plots. Create and save predefined
plot configs for different purposes. Useful for writing reports
with many figures.

### Example
```Matlab
% Generate some data to plot:
x = [0:0.1:10]';
y = [3 * x.^2 - 4.*x + 2, ...
     2 * x.^2 + 5.*x - 5];


foo = consfig(x, y);
consplot(foo);
```

### Example 2
```Matlab
% Generate some data to plot:
x = [0:0.1:10]';
y = [3 * x.^2 - 4.*x + 2, ...
     2 * x.^2 + 5.*x - 5];

% Create consfig object with extra options:
foo = consfig(x, y, ...
             'title', 'Foobar', ...
             'legend', {'foo', 'bar'}, ...
             'color_order', 'red_range_4', ...
             'xlabel', 'Raboof [Hz]');

consplot(foo, 'config', 'some_config', 'save', 'path/to/saved/file');
```

### Example 3
```Matlab
% Generate some data to plot:
x = [0:0.1:10]';
y1 = [3 * x.^2 - 4.*x + 2];
y2 = [2 * x.^2 + 5.*x - 5];

% Create one consfig object/subplot:
foo = consfig(x, y1, 'title', 'Foo');
bar = consfig(x, y2, 'title', 'Bar');

% Make sure to use a config where rows * colums = number of consfig objects
consplot(foo, 'subplots', bar, 'config', '2_row');
% 'subplots' should be a list of all the additional consfig objects to be used.
```
