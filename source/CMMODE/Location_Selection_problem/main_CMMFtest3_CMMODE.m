%% Add path
clear all
clc
addpath(genpath('CMMFtest/'));
addpath(genpath('Indicator_calculation/'));
addpath(genpath('H:\学习\论文\CMMODE所有相关资料\CMMODE_NEW'));

global fname
N_function=1;% number of test function
runtimes=31;  % odd number
%% Initialize the parameters in CMMFF test functions
for i_func=N_function
    switch i_func
        case 1
            fname='CMMFtest3';  % function name
            n_obj=3;       % the dimensions of the decision space
            n_var=2;       % the dimensions of the objective space
            xl=[0  0];     % the low bounds of the decision variables
            xu=[2.5 1.5];      % the up bounds of the decision variables
            repoint=[4,4,4];
    end
    %% Load reference PS and PF data
               load  (strcat([fname,'_Reference_PSPF_data']));
    %% Initialize the population size and the maximum evaluations
    popsize=50*n_var*2;
    Max_fevs=20000*n_var;
    Max_Gen=fix(Max_fevs/popsize);
    
    for j=1:runtimes
%% Search the PSs using CMMODE     
        [ps,pf,cons]=CMMODE(fname,xl,xu,n_obj,popsize,Max_Gen);
        % Indicators
        % hyp=Hypervolume_calculation(pf,repoint);

        IGDx=IGD_calculation(ps,PS);
        IGDf=IGD_calculation(pf,PF);
        CR=CR_calculation(ps,PS);
        PSP=CR/IGDx;
        CV = mean(cons);

        Indicator.CMMODE(j,:)=[1./PSP,CV,IGDx,IGDf];
        PSdata.CMMODE{j}=ps;
        PFdata.CMMODE{j}=pf;
        clear ps pf CV IGDx IGDf CR PSP
        fprintf('Running test function: %s \n %d times \n', fname,j);
    end
    choosen_In=Indicator.CMMODE(:,1);% Choose PS according to PSP (the fifth indicator) value
    median_index=find(choosen_In==median(choosen_In));
    choose_ps.CMMODE= PSdata.CMMODE{median_index};
    choose_pf.CMMODE= PFdata.CMMODE{median_index};
    clear choosen_In median_index
    
    %% Calculate mean and std of the indicators
    %% CMMODE
    % Indicator.CMMODE(runtimes+1,:)=min(Indicator.CMMODE); %the minimum is the best
    % Indicator.CMMODE(runtimes+2,:)=max(Indicator.CMMODE); %the maximum is the worst
    % Indicator.CMMODE(runtimes+3,:)=mean(Indicator.CMMODE);
    % Indicator.CMMODE(runtimes+4,:)=median(Indicator.CMMODE);
    % Indicator.CMMODE(runtimes+5,:)=std(Indicator.CMMODE);
    % Generate Table data in the report
    Table.CMMODE.rPSP(i_func,:)=(Indicator.CMMODE(:,1))';%Talbe II data
    Table.CMMODE.CV(i_func,:)=(Indicator.CMMODE(:,2))';%Talbe III data
    Table.CMMODE.IGDX(i_func,:)=(Indicator.CMMODE(:,3))';%Talbe IV data
    Table.CMMODE.IGDF(i_func,:)=(Indicator.CMMODE(:,4))';%Talbe V data
%% save resultdata
% save(strcat([fname,'PSPF_indicator_data_v95']),'PSdata','PFdata','Indicator');
clear PSdata PFdata Indicator

IGD = Table.CMMODE.IGDF;
IGDX = Table.CMMODE.IGDX;
rPSP = Table.CMMODE.rPSP;
CV = Table.CMMODE.CV;

save(['H:\ICMMODE的消融实验_final\CPSP指标计算\CPSP_Location\\CMMODE_Location.mat'], 'IGD','IGDX','rPSP','CV');
save(strcat([fname,'Choosen_CMMODE']),'choose_ps','choose_pf');

% %% Plot figure
% figure(1)
% landscape_CMMFtest3
% fname='CMMFtest3';
% load  (strcat([fname,'_Reference_PSPF_data']));
% % load  (strcat([fname,'ChoosenPSPFdata']),'choose_ps','choose_pf');
% 
% scatter(choose_ps.CMMODE(:,1),choose_ps.CMMODE(:,2),3.5,'MarkerEdgeColor','k','MarkerFaceAlpha','0.3','LineWidth',2);
% hold on
% 
% range=[0 2.5 0 1.5];
% axis(range);
% hold on
end
    

