function  matlab_interface_python(size_p,iteration_number)
%% Remeber to change the  Miniconda3 binary path, for Window in C:\Miniconda3\ and for Unix systems use /Users/your_user/anaconda/bin/
load_anaconda_packages()
cd deep_inv_opt-master
%% learning range for w. This range need to be defined to find the better convergence on the inverse optimization. Please refer to the README file for more detail
w=[2 6];
%% input data definition you can change this model depending on your convinience. For inital evaluation use random vectors of size size_p as you can give it as input.
x_targets=rand([1 size_p])
pb=rand([1 size_p]);
pf=rand([1 size_p]);
u=pb./pf;
str_data_u=mat2str(u);
str_data_x=mat2str(x_targets);
%% u and x_targets are defined here as input for the python code. u is defined as the rate between Pb/Pf vectors for the model defined on the READ file, and the w value will be modulated on the python code directly for the estimation
%% w will be the final output use the final weight output from the the stdout obtained from the Matlab results variable
systemCommand = ['D:\Miniconda3\python.exe ..\python\model_deep_inv_opt.py "', strrep(str_data_x(2:end-1),' ',','), '" "' strrep(str_data_u(2:end-1),' ',',') '" num2str(iteration_number) num2str(w(1)) num2str(w(2))'];
[status,results]=system(systemCommand)
cd ..
