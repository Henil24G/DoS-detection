clc
clear all
close all
load ("TCP_syn_15min_dos")  %% input CSV to MAT file, keep the name of the array same as defined in the MAT file. 

select = input('Enter 1 to calculate source IP, destination IP and Prot IP. Enter 2 to calculate entropy for source port, destination port , TCP SYN flag');

switch select
    
    case 1 
        t_counter=0;   
        t_counter_end=ceil(Time(end));
        pps = [];
        for t_counter=0:t_counter_end
        tic()
        K=find(Time<t_counter+1 & Time>t_counter);%indices for window of 1
        N_window=length(K); %% Number packets in 1s window
        pps = [pps N_window];
        tcp_slice=Protocol(K);
        dip_slice=Destination(K);
        sip_slice=Source(K);

        sip_list=unique(sip_slice);
        dip_list=unique(dip_slice);
        prt_list=unique(tcp_slice);

        count_sip(t_counter+1)=length(sip_list);
        count_dip(t_counter+1)=length(dip_list);
        count_tcp(t_counter+1)=length(prt_list);

        prob_sip=zeros(1, count_sip(t_counter+1)); %initialize prob arrays
        prob_dip=zeros(1, count_dip(t_counter+1)); %initialize prob arrays
        prob_tcp=zeros(1, count_tcp(t_counter+1)); %initialize prob arrays

        for i=1:count_sip(t_counter+1)
            prob_sip(i)=length(find(sip_slice == sip_list(i)))/N_window;
        end

        for i=1:count_dip(t_counter+1)
            prob_dip(i)=length(find(dip_slice == dip_list(i)))/N_window;
        end

        for i=1:count_tcp(t_counter+1)
            prob_tcp(i)=length(find(tcp_slice == prt_list(i)))/N_window;
        end

        Source_entropy(t_counter+1)= sum(-prob_sip.*log2(prob_sip));
        Destination_entropy(t_counter+1)= sum(-prob_dip.*log2(prob_dip));
        Protocol_entropy(t_counter+1)= sum(-prob_tcp.*log2(prob_tcp));

        toc()

        end 
        
    case 2
        t_counter=0;
        t_counter_end=ceil(Time(end));
        srcPrt_array=[];
        dstPrt_array=[];
        SYS_array=[];
      
        for t_counter=0:t_counter_end
        tic();  
        K=find(Time<t_counter+1 & Time>t_counter);%indices for window of 1
        N_window=length(K); %% Number packets in 1s window
        Info_slice=Info(K);

         for i=1:length(Info_slice)
          source_port = split(Info_slice(i),' ');
          isPort=find(source_port == '>');
          isSYN=find(source_port == '[SYN]');
          isFINACK=find(source_port == '[FIN, ACK]'); 
          isACK=find(source_port == '[ACK]');
          isPSHACK=find(source_port == '[PSH, ACK]'); 
          isRST=find(source_port == '[RST]');
          isRSTACK=find(source_port == '[RST, ACK]');
           if length(isPort)>0
              srcPrt_array=cat(1,srcPrt_array,source_port(isPort-2));
              dstPrt_array=cat(1,dstPrt_array,source_port(isPort+2));
           else
              srcPrt_array=cat(1,srcPrt_array,'NaN');
              dstPrt_array=cat(1,dstPrt_array,'NaN');
           end
           if length(isSYN)>0
               SYS_array=cat(1,SYS_array,source_port(isSYN));
           elseif length(isFINACK) >0
               SYS_array=cat(1,SYS_array,source_port(isFINACK));
           elseif length(isACK) >0
               SYS_array=cat(1,SYS_array,source_port(isACK));
           elseif length(isPSHACK) >0
               SYS_array=cat(1,SYS_array,source_port(isPSHACK));
           elseif length(isRST) >0
               SYS_array=cat(1,SYS_array,source_port(isRST));
           elseif length(isRSTACK) >0
               SYS_array=cat(1,SYS_array,source_port(isRSTACK));
           else
              SYS_array=cat(1,SYS_array,'NAN');
          end
         end   
        toc();
        end 
        t_counter=0;
        % entopy calc for srcPrt_array , dstPrt_array , SYS_array
        for t_counter=0:t_counter_end
        tic();  
        K=find(Time<t_counter+1 & Time>t_counter);%indices for window of 1
        N_window=length(K); %% Number packets in 1s window
        Info_slice=Info(K);

        srcP_slice = srcPrt_array(K);
        dstP_slice = dstPrt_array(K);
        SYS_slice = SYS_array(K);

        srcP_list=unique(srcP_slice);
        dstP_list=unique(dstP_slice);
        SYS_list=unique(SYS_slice);

        count_srcP(t_counter+1)=length(srcP_list);
        count_dstP(t_counter+1)=length(dstP_list);
        count_SYS(t_counter+1)=length(SYS_list);

        prob_srcP=zeros(1, count_srcP(t_counter+1)); %initialize prob arrays
        prob_dstP=zeros(1, count_dstP(t_counter+1)); %initialize prob arrays
        prob_SYS=zeros(1, count_SYS(t_counter+1)); %initialize prob arrays


            parfor i=1:count_srcP(t_counter+1)
                prob_srcP(i)=length(find(srcP_slice == srcP_list(i)))/N_window;
            end

            parfor i=1:count_dstP(t_counter+1)
                prob_dstP(i)=length(find(dstP_slice == dstP_list(i)))/N_window;
            end

            parfor i=1:count_SYS(t_counter+1)
                prob_SYS(i)=length(find(SYS_slice == SYS_list(i)))/N_window;
            end
        SrcPort_entropy(t_counter+1)= sum(-prob_srcP.*log2(prob_srcP));
        DstPort_entropy(t_counter+1)= sum(-prob_dstP.*log2(prob_dstP));
        SYS_entropy(t_counter+1)= sum(-prob_SYS.*log2(prob_SYS));
        toc();

       end 
end




