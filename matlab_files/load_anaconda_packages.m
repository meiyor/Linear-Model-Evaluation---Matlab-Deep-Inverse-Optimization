function load_anaconda_packages()
%% function collected from stack-overflow blogs on this link https://stackoverflow.com/questions/58252108/how-to-run-a-python-script-with-anaconda-packages-on-matlab
pyExec = "D:\Miniconda3\"; %% here add your Miniconda3 binary path, common Window systems is C:\Miniconda3\ for Unix systems use /Users/yout_user/anaconda/bin/
pyRoot = fileparts(pyExec);
p = getenv('PATH');
p = strsplit(p, ';');
addToPath = {
   pyRoot
   fullfile(pyRoot, 'Library', 'mingw-w64', 'bin')
   fullfile(pyRoot, 'Library', 'usr', 'bin')
   fullfile(pyRoot, 'Library', 'bin')
   fullfile(pyRoot, 'Scripts')
   fullfile(pyRoot, 'bin')
};
p = [addToPath(:); p(:)];
p = unique(p, 'stable');
p = strjoin(p, ';');
setenv('PATH', p);
