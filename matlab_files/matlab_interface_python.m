function  matlab_interface_python(size_p,iteration_number,num_ini)
%% set num_ini as the initial set of solutions you want to tune your inverse optimization if you want to parse into python use the method proposed here for the rest of the variables 
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
%% example of models, please change this depending o how you are computing your model in python %%
u_Val=(1./(1+num_ini.*u));
%% u and x_targets are defined here as input for the python code. u is defined as the rate between Pb/Pf vectors for the model defined on the READ file, and the w value will be modulated on the python code directly for the estimation
%% w will be the final output use the final weight output from the the stdout obtained from the Matlab results variable
systemCommand = ['D:\Miniconda3\python.exe -u ..\python\model_deep_inv_opt.py "', strrep(str_data_x(2:end-1),' ',','), '" "' strrep(str_data_u(2:end-1),' ',',') '" ' num2str(iteration_number) ' ' num2str(w(1)) ' ' num2str(w(2)) ' | tee output_file_opt.txt'];
[status,results]=system(systemCommand)
systemCommand2= ['grep -n "weights" output_file_opt.txt | tail -f -n 1 > output_params.txt'];
[status2,results2]=system(systemCommand2)
fid=fopen('output_params.txt','r')
t_l=linspace(0,2,300);
s_out=fgets(fid);
out_f=strsplit(s_out,'=');
loss_c=str2num(out_f{2}(1:9))
weight_estim=str2num(out_f{3}(2:end-3))
%% example of models, please change this depending o how you are computing your model in python %%
u_Val_t=(1./(1+weight_estim.*u));
figure;
scatter(u_Val,x_targets,100,'b*');
hold on
scatter(u_Val_t,x_targets,100,'r*');
P1n = polyfit(u_Val,x_targets,1);
yfit = P1n(1).*t_l+P1n(2);
H(1)=plot(t_l,yfit,'b','LineWidth',2);
[R1,pval1]=corr(u_Val',x_targets','Type','Pearson');
P2n = polyfit(u_Val_t,x_targets,1);
yfit = P2n(1).*t_l+P2n(2);
H(2)=plot(t_l,yfit,'r','LineWidth',2);
[R2,pval2]=corr(u_Val_t',x_targets','Type','Pearson');
xlabel('$\hat{\omega}$','Interpreter','latex');
ylabel('\omega_{e}');
title(['inverse optimization loss=' num2str(loss_c) ' weight=' num2str(weight_estim)]);
legend('data before opt','data after opt',['R=' num2str(R1) ', p=' num2str(pval1)],['R=' num2str(R2) ', p=' num2str(pval2)]);
set(gca,'FontSize',16);
grid on;
cd ..
