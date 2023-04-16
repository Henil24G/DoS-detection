clc
clear all
close all
load ("output_of_entropy_15min")  % getcount_packets entropy values of all header fields
norm_h_src = [];
norm_h_src2 = [];
norm_h_dst = [];
norm_h_prot = [];
norm_h_srcprt = [];
norm_h_dstprt = [];
norm_h_len = [];
norm_h_flag = [];
jh = [];
norm_jh = [];

jh_pro_DA = [];
norm_jh_pro_DA =[];

m = max(SrcPort_entropy);
p = max(Destination_entropy);
n = length(SrcPort_entropy);

for i = 1:n
    norm_h_src = [norm_h_src , Source_entropy(i)/max(Source_entropy)];
    norm_h_dst = [norm_h_dst , Destination_entropy(i)/max(Destination_entropy)];
    norm_h_prot = [norm_h_prot , Protocol_entropy(i)/max(Protocol_entropy)];
    norm_h_srcprt = [norm_h_srcprt , SrcPort_entropy(i)/max(SrcPort_entropy)];
    norm_h_dstprt = [norm_h_dstprt , DstPort_entropy(i)/max(DstPort_entropy)];
    norm_h_len = [norm_h_len , PacketLength_entropy(i)/max(PacketLength_entropy)];
    norm_h_flag = [norm_h_flag , SYS_entropy(i)/max(SYS_entropy)];
end 

%all
for i = 1:n
    jh = [ jh , Destination_entropy(i)+Protocol_entropy(i)+DstPort_entropy(i)+PacketLength_entropy(i) + SYS_entropy(i) ];
end 

for i = 1:n
    norm_jh = [ norm_jh , jh(i)/ max(jh)];
end 
% DA pro
for i = 1:n
    jh_pro_DA = [ jh_pro_DA , Destination_entropy(i)+Protocol_entropy(i) ];
end 

for i = 1:n
    norm_jh_pro_DA = [ norm_jh_pro_DA , jh_pro_DA(i)/max(jh_pro_DA)];
end 

% len DA --1

jh_len_DA=[];
norm_len_DA=[];

for i = 1:n
    jh_len_DA = [ jh_len_DA , norm_h_len(i)+Destination_entropy(i) ];
end 

for i = 1:n
    norm_len_DA = [ norm_len_DA , jh_len_DA(i)/max(jh_len_DA)];
end 

mean_JE_len_DA = movmean(norm_len_DA,10);

% len pro --2

jh_len_pro=[];
norm_len_pro=[];

for i = 1:n
    jh_len_pro = [ jh_len_pro , norm_h_len(i)+Protocol_entropy(i) ];
end 

for i = 1:n
    norm_len_pro = [ norm_len_pro , jh_len_pro(i)/max(jh_len_pro)];
end 

mean_JE_len_pro = movmean(norm_len_pro,10);


% len dstprt --3

jh_len_dstprt=[];
norm_len_dstprt=[];

for i = 1:n
    jh_len_dstprt = [ jh_len_dstprt , norm_h_len(i)+DstPort_entropy(i) ];
end 

for i = 1:n
    norm_len_dstprt = [ norm_len_dstprt , jh_len_dstprt(i)/max(jh_len_dstprt)];
end 

mean_JE_len_dstPrt = movmean(norm_len_dstprt,10);


% len flag --4

jh_len_flag=[];
norm_len_flag=[];

for i = 1:n
    jh_len_flag = [ jh_len_flag , norm_h_len(i)+SYS_entropy(i) ];
end 

for i = 1:n
    norm_len_flag = [ norm_len_flag , jh_len_flag(i)/max(jh_len_flag)];
end 

mean_JE_len_flag = movmean(norm_len_flag,10);

mean_srcIP = movmean(norm_h_src,10);
mean_dstIP = movmean(norm_h_dst,10);
mean_prot = movmean(norm_h_prot,10);
mean_srcPrt = movmean(norm_h_srcprt,10);
mean_dstPrt = movmean(norm_h_dstprt,10);
mean_len = movmean(norm_h_len,10);
mean_flag = movmean(norm_h_flag,10);

norm_mean_flag=[];
norm_mean_len = [];
norm_mean_len_flag = [];

for i = 1:n
    norm_mean_flag = [ norm_mean_flag , mean_flag(i)/max(mean_flag)];
end 

for i = 1:n
    norm_mean_len = [ norm_mean_len , mean_len(i)/max(mean_len)];
end 

for i = 1:n
    norm_mean_len_flag = [ norm_mean_len_flag , mean_JE_len_flag(i)/max(mean_JE_len_flag)];
end 

x = [1:1799];
figure 
plot(x, norm_mean_len, x, norm_mean_flag, x, norm_mean_len_flag )
legend({'H(length)', 'H(TCP flag)', 'H(joint)'},'Location','southeast')
grid on
title('Joint entropy of packet length and TCP flag')
xlabel('Time(sec)')
ylabel('Entropy (H)')




figure
t = tiledlayout(2,2);

nexttile
plot(x, mean_len, x, mean_dstIP , x, mean_JE_len_DA)
legend({'H(length)', 'H(destinationIP)', 'H(joint)'},'Location','southeast')
grid on
title('Joint entropy of packet length and destination IP')
xlabel('Time(sec)')
ylabel('Entropy (H)')

nexttile
plot(x, mean_len, x, mean_prot , x, mean_JE_len_pro)
legend({'H(length)', 'H(protocol)', 'H(joint)'},'Location','southeast')
grid on
title('Joint entropy of packet length and destination IP')
xlabel('Time(sec)')
ylabel('Entropy (H)')

nexttile
plot(x, mean_len, x, mean_dstPrt , x, mean_JE_len_dstPrt)
legend({'H(length)', 'H(dstPort)', 'H(joint)'},'Location','southeast')
grid on
title('Joint entropy of packet length and destination IP')
xlabel('Time(sec)')
ylabel('Entropy (H)')

nexttile
plot(x, norm_h_len, x, norm_h_flag , x, norm_len_flag)
legend({'H(length)', 'H(flag)', 'H(joint)'},'Location','southeast')
grid on
title('Joint entropy of packet length and destination IP')
xlabel('Time(sec)')
ylabel('Entropy (H)')

%saveas(gcf,"test1.emf")


figure
plot(x, mean_JE_len_DA, x, mean_JE_len_pro, x, mean_JE_len_dstPrt , x, mean_JE_len_flag)
legend({'H(da)', 'H(p)', 'H(pi)', 'H(f)'},'Location','southeast')
grid on
title('Joint entropy of packet length and destination IP')
xlabel('Time(sec)')
ylabel('Entropy (H)')


figure
plot(x, mean_len, x, mean_flag , x, mean_JE_len_flag)
legend({'H(length)', 'H(flag)', 'H(joint)'},'Location','southeast')
grid on
title('Joint entropy of packet length and destination IP')
xlabel('Time(sec)')
ylabel('Entropy (H)')


fig_syl = 1;

switch fig_syl
    
    case 1

figure
t = tiledlayout(2,4);

nexttile
plot(norm_jh)
%yline(Threshold,'-','Thr');
title('Joint entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
%legend('Source IP entropy')

nexttile
plot(norm_h_src)
%yline(Threshold,'-','Thr');
title('Source IP entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
%legend('Source IP entropy')

nexttile
plot(norm_h_dst)
%yline(Threshold,'-','Thr');
title('Destination IP entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
%legend('Destination IP entropy')

nexttile
plot(norm_h_prot);
%yline(Threshold,'-','Thr');
title('Protocol entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
%legend('Protocol entropy')

nexttile
plot(norm_h_srcprt)
%yline(Threshold,'-','Thr');
title('SrcPort entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
%legend('Protocol IP entropy')

nexttile
plot(norm_h_dstprt)
%yline(Threshold,'-','Thr');
title('DstPort entropy')
ylabel('Entropy H(X)')
xlabel('sampling period (1 sec)')
%legend('DstPort entropy')

nexttile
plot(norm_h_flag)
%yline(Threshold,'-','Thr');
title('SYS entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
%legend('SYS_entropy entropy')

nexttile
plot(norm_h_len)
%yline(Threshold,'-','Thr');
title('length entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
%legend('SYS_entropy entropy')

    case 2
        
figure
plot(norm_jh)
%yline(Threshold,'-','Thr');
grid on
title('Joint entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
legend('Joint entropy')

figure
plot(norm_h_src)
%yline(Threshold,'-','Thr');
grid on
title('Source IP entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
legend('Source IP entropy')


figure
plot(norm_h_dst)
%yline(Threshold,'-','Thr');
grid on
title('Destination IP entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
legend('Destination IP entropy')

figure
plot(norm_h_prot);
%yline(Threshold,'-','Thr');
grid on
title('Protocol entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
legend('Protocol entropy')

figure
plot(norm_h_srcprt)
%yline(Threshold,'-','Thr');
grid on
title('Source port entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
legend('Source port entropy')

figure
plot(norm_h_dstprt)
%yline(Threshold,'-','Thr');
grid on
title('Destination port entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
legend('Destination port entropy')

figure
plot(norm_h_flag)
%yline(Threshold,'-','Thr');
grid on
title('TCP SYN flag entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
legend('TCP SYN flag entropy')

figure
plot(norm_h_len)
%yline(Threshold,'-','Thr');
grid on
title('Packet length entropy')
ylabel('Entropy (H)')
xlabel('sampling period (1 sec)')
legend('Packet length entropy')
        
end