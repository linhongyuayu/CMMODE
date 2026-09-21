clc
clear all

%% Calculate maximum of rPSP and CV values
global number
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
    for j=1:7
        switch j
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
            switch j
                case 1
                    CTAEA_CVrPSP(i,:)=CV_rPSP(i,:);
                case 2
                    PPS_CVrPSP(i,:)=CV_rPSP(i,:);
                case 3
                    MOEADDAE_CVrPSP(i,:)=CV_rPSP(i,:);
                case 4
                    MMOEAC_CVrPSP(i,:)=CV_rPSP(i,:);
                case 5
                    CMO_Ring_PSO_SCD_CVrPSP(i,:)=CV_rPSP(i,:);
                case 6
                    CDNNSGAII_CVrPSP(i,:)=CV_rPSP(i,:);
                case 7
                    CMMODE_CVrPSP(i,:)=CV_rPSP(i,:);
            end
        clc
        clear n_CV n_rPSP CVrPSP new_CV new_rPSP b NEW_CV  CV_rPSP
    end
end

for func=1:7
    switch func
        case 1
            save( 'CTAEA_CVrPSP');
        case 2
            save( 'PPS_CVrPSP');
        case 3
            save( 'MOEADDAE_CVrPSP');
        case 4
            save( 'MMOEAC_CVrPSP');
        case 5
            save( 'CMO_Ring_PSO_SCD_CVrPSP');
        case 6
            save( 'CDNNSGAII_CVrPSP');
        case 7
            save( 'CMMODE_CVrPSP');
    end
end