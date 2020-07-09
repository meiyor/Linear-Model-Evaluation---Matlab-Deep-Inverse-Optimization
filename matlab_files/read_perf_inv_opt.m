function read_perf_inv_opt(path_b)
figure;
fid=fopen(path_b,'r');
n=1;
while ~feof(fid)
    s_out=fgets(fid);
    out_f=strsplit(s_out,'=');
    loss_c(n)=str2num(out_f{2}(1:9));
    weight_p(n)=str2num(out_f{3}(2:end-3));
    n=n+1;
end;
subplot(121)
plot([1:1:n-1],loss_c,'b','LineWidth',2);
xlabel('Epochs');
ylabel('loss');
grid on;
set(gca,'FontSize',16);
subplot(122)
plot([1:1:n-1],weight_p,'b','LineWidth',2);
xlabel('Epochs');
ylabel('Weight');
grid on;
set(gca,'FontSize',16);