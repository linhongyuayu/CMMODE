clc
clear all
global number
for number=1:7
    switch number
        case 1
            name='CTAEA';
        case 2
            name='PPS';
        case 3
            name='MOEADDAE';
        case 4
            name='MMOEAC';
        case 5
            name='CMO_Ring_PSO_SCD';
        case 6
            name='CDNNSGAII';
        case 7
            name='CMMODE';            
    end
    
    for c=1:17
        %% 真实PS和PF数据
        b=[];
        aaa_x=[];
        aaa_f=[];
        reference_point=load  (strcat(['CMMF',num2str(c),'_Reference_PSPF_data']));
        reference_PS=reference_point.PS;
        reference_PF=reference_point.PF;
        
        %% 算法获得的结果，计算指标值
        for i=1:31
            b_x=[];
            b_f=[];
            b_c=[];
            
            % 加载所有算法的数据结果
            a=load([name,'_CMMF',num2str(c),'_M2_D2_',num2str(i)]);
            
            
            aa=a.result(1,2);
            aa=aa{1,1};
            for k=1:size(aa,2)
                aaa_x=aa(1,k).decs;
                aaa_f=aa(1,k).objs;
                aaa_c=aa(1,k).cons;
                b_x=[b_x;aaa_x];
                b_f=[b_f;aaa_f];
                b_c=[b_c;aaa_c];
            end
            b_c_sum = sum(max(0,b_c),2);
            cv=b_c_sum;
            CV(c,i)=mean(cv,1);
            obtained_ps=b_x;
            obtained_pf=b_f;
            CR(c,i)=CR_calculation(obtained_ps,reference_PS);
            IGDX(c,i)=IGD_calculation(obtained_ps,reference_PS);
            IGD(c,i)=IGD_calculation(obtained_pf,reference_PF);
            rPSP(c,i)=IGDX(c,i)/CR(c,i);
        end
    end

        switch number
            case 1
                save(['CTAEA_indicator.mat'],'IGD','IGDX','rPSP','CV');
            case 2
                save( ['PPS_indicator.mat'],'IGD','IGDX','rPSP','CV');
            case 3
                save( ['MOEADDAE_indicator.mat'],'IGD','IGDX','rPSP','CV');
            case 4
                save(['MMOEAC_indicator.mat'], 'IGD','IGDX','rPSP','CV');
            case 5
                save( ['CMO_Ring_PSO_SCD_indicator.mat'],'IGD','IGDX','rPSP','CV');
            case 6
                save( ['CDNNSGAII_indicator.mat'],'IGD','IGDX','rPSP','CV');
             case 7
                save( ['CMMODE_indicator.mat'],'IGD','IGDX','rPSP','CV');               
        end
clc
clear all
end
    


%% 计算CPSP指标
 for i=1:17
    for number=1:7
        switch number
            case 1
                name='CTAEA';
            case 2
                name='PPS';
            case 3
                name='MOEADDAE';
            case 4
                name='MMOEAC';
            case 5
                name='CMO_Ring_PSO_SCD';
            case 6
                name='CDNNSGAII';
            case 7
                name='CMMODE';
        end
        a=load([name,'_indicator']);
        CV=a.CV;
        rPSP=a.rPSP;
        cv_max(i,number)=max(CV(i,:));    %find the maximum of CV value
        rpsp_max(i,number)=max(rPSP(i,:));   %find the maximum of rPSP value
    end
 end

 for i=1:17
    for number=1:7
        switch number
            case 1
                name='CTAEA';
            case 2
                name='PPS';
            case 3
                name='MOEADDAE';
            case 4
                name='MMOEAC';
            case 5
                name='CMO_Ring_PSO_SCD';
            case 6
                name='CDNNSGAII';
            case 7
                name='CMMODE';
        end
            b=load([name,'_indicator']);
            new_CV=b.CV;
            
%% Normalization
            if max(cv_max(i,:))==0
                NEW_CV(i,:)=0;
            else
                NEW_CV(i,:)=new_CV(i,:)./max(cv_max(i,:));
            end
            new_rPSP=b.rPSP;
            n_rPSP(i,:)=new_rPSP(i,:)./max(rpsp_max(i,:));
            CV_rPSP(i,:)=NEW_CV(i,:)+n_rPSP(i,:);
            
 %% Store CRPSP values           
            switch number
                case 1
                    CTAEA_CPSP(i,:)=CV_rPSP(i,:);
                case 2
                    PPS_CPSP(i,:)=CV_rPSP(i,:);
                case 3
                    MOEADDAE_CPSP(i,:)=CV_rPSP(i,:);
                case 4
                    MMOEAC_CPSP(i,:)=CV_rPSP(i,:);
                case 5
                    CMO_Ring_PSO_SCD_CPSP(i,:)=CV_rPSP(i,:);
                case 6
                    CDNNSGAII_CPSP(i,:)=CV_rPSP(i,:);
                case 7
                    CMMODE_CPSP(i,:)=CV_rPSP(i,:);
            end
        clc
        clear n_CV n_rPSP CVrPSP new_CV new_rPSP b NEW_CV  CV_rPSP
    end
end

for number=1:7
    switch number
        case 1
            CPSP = CTAEA_CPSP;
            save(['CTAEA_indicator.mat'],'CPSP');
        case 2
            CPSP = PPS_CPSP;
            save( ['PPS_indicator.mat'],'CPSP');
        case 3
            CPSP = MOEADDAE_CPSP;
            save( ['MOEADDAE_indicator.mat'],'CPSP');
        case 4
            CPSP = MMOEAC_CPSP;
            save(['MMOEAC_indicator.mat'], 'CPSP');
        case 5
            CPSP = CMO_Ring_PSO_SCD_CPSP;
            save( ['CMO_Ring_PSO_SCD_indicator.mat'],'CPSP');
        case 6
            CPSP = CDNNSGAII_CPSP;
            save( ['CDNNSGAII_indicator.mat'],'CPSP');
    end
end
