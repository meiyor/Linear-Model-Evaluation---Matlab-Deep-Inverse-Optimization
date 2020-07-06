function load_anaconda_packages_unix()
%% function collected from stack-overflow blogs on this link https://stackoverflow.com/questions/58252108/how-to-run-a-python-script-with-anaconda-packages-on-matlab
pyExec = '/usr/local/lib/python3.8/';
pyRoot = fileparts(pyExec);
p = getenv('PATH');
p = strsplit(p, ';');
addToPath = {
   pyRoot
   fullfile('/usr/bin/python3')
};
p = [addToPath(:); p(:)];
p = unique(p, 'stable');
p = strjoin(p, ';');
setenv('PATH', p);