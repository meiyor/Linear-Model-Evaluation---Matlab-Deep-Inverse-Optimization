function  [R1,R2,pval1,pval2]=matlab_interface_python_test_unix(iter,num_pos_sol,num_ini)
load_anaconda_packages_unix()
cd deep_inv_opt-master
close all;
load('data_test.mat'); ## load the data you want to optimize in here and declare them in the structure S
x_targets=S.target_x;
pb=S.pb';
pf=S.pf';
sigma_b=S.sigma_b;
u=(1./((sigma_b.^2)'.*pf));
%% re-define u value
%%u=(sigma_b.^2)./pf;
%%
u_Val=(1./(1+(num_ini).*u))';
str_data_u=mat2str(u);
str_data_x=mat2str(x_targets');
%!python test_linear_model_deep_inv.py  "str_data"
%systemCommand = ['D:\Miniconda3\python.exe test_linear_model_deep_inv.py "', strrep(str_data_x(2:end-1),' ',','), '" "' strrep(str_data_u(2:end-1),' ',',') '" 20'];
systemCommand = ['/usr/bin/python3 -u model_christoph_inv_opt_new.py "', strrep(str_data_x(2:end-1),' ',','), '" "' strrep(str_data_u(2:end-1),' ',',') '" ' num2str(iter) ' ' num2str(num_pos_sol) ' ' num2str(num_ini) '| tee output_file_opt.txt'];
[status,results]=system(systemCommand)
systemCommand2= ['grep -n "weights" output_file_opt.txt | tail -f -n 1 > output_params.txt'];
[status2,results2]=system(systemCommand2)
fid=fopen('output_params.txt','r')
t_l=linspace(0,2,300);
s_out=fgets(fid);
out_f=strsplit(s_out,'=');
loss_c=str2num(out_f{2}(1:9))
weight_estim=str2num(out_f{3}(2:end-3))
u_Val_t=(1./(1+(weight_estim.*u)))';
figure;
scatter(u_Val,x_targets,100,'b*');
hold on
scatter(u_Val_t,x_targets,100,'r*');
P1n = polyfit(u_Val,x_targets,1);
yfit = P1n(1).*t_l+P1n(2);
H(1)=plot(t_l,yfit,'b','LineWidth',2);
[R1,pval1]=corr(u_Val,x_targets,'Type','Pearson');
P2n = polyfit(u_Val_t,x_targets,1);
yfit = P2n(1).*t_l+P2n(2);
H(2)=plot(t_l,yfit,'r','LineWidth',2);
[R2,pval2]=corr(u_Val_t,x_targets,'Type','Pearson');
xlabel('$\hat{\omega}$','Interpreter','latex');
ylabel('\omega_{e}');
title(['inverse optimization loss=' num2str(loss_c) ' weight=' num2str(weight_estim)]);
legend('data before opt','data after opt',['R=' num2str(R1) ', p=' num2str(pval1)],['R=' num2str(R2) ', p=' num2str(pval2)]);
set(gca,'FontSize',16);
grid on;
cd ..
