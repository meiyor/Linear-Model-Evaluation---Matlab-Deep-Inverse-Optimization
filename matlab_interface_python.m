function  matlab_interface_python(size_p)
load_anaconda_packages()
cd deep_inv_opt-master

x_targets=rand([1 size_p])*0.7-0.1;
pb=rand([1 size_p]);
pf=rand([1 size_p]);
u=pb./pf;
str_data_u=mat2str(u);
str_data_x=mat2str(x_targets);
%!python test_linear_model_deep_inv.py  "str_data"
%systemCommand = ['D:\Miniconda3\python.exe test_linear_model_deep_inv.py "', strrep(str_data_x(2:end-1),' ',','), '" "' strrep(str_data_u(2:end-1),' ',',') '" 20'];
systemCommand = ['D:\Miniconda3\python.exe model_christoph_inv_opt.py "', strrep(str_data_x(2:end-1),' ',','), '" "' strrep(str_data_u(2:end-1),' ',',') '" 20'];
[status,results]=system(systemCommand)
cd ..