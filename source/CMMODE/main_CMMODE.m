%% Add path
addpath(genpath('CMMF/'));
addpath(genpath('Indicator_calculation/'));

clear all
clc
global fname
N_function=17;% number of test function
runtimes=1;  % odd number
 %% Initialize the parameters in CMMF test functions
     for i_func=1:N_function
        switch i_func
            case 1
                fname='CMMF1';  % function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[-1 -1];     % the low bounds of the decision variables
                xu=[1 1];      % the up bounds of the decision variables
                repoint=[1.1,1.1]; % reference point used to calculate the Hypervolume, it is set to 1.1*(max value of f_i)     
            case 2
                fname='CMMF2';% function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[-1 -1];     % the low bounds of the decision variables
                xu=[1 1];       % the up bounds of the decision variables
                repoint=[1.1,1.1];
            case 3
                fname='CMMF3';% function name
                n_obj=2;        % the dimensions of the objective space
                n_var=2;        % the dimensions of the decision space
                xl=[-1 -1];      % the low bounds of the decision variables
                xu=[1 1];        % the up bounds of the decision variables
                repoint=[1.1,1.1];
            case 4
                fname='CMMF4';% function name
                n_obj=2;        % the dimensions of the objective space
                n_var=2;        % the dimensions of the decision space
                xl=[-1 0];       % the low bounds of the decision variables
                xu=[1 1];       % the up bounds of the decision variables
                repoint=[1.1,1.1];
            case 5
                fname='CMMF5';% function name
                n_obj=2;        % the dimensions of the objective space
                n_var=2;        % the dimensions of the decision space
                xl=[-1 -1];      % the low bounds of the decision variables
                xu=[1 1];        % the up bounds of the decision variables
                repoint=[1.1,1.1];
             case 6
                fname='CMMF6';% function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[-1 -1];     % the low bounds of the decision variables
                xu=[1 1];       % the up bounds of the decision variables
                repoint=[1.1,1.1];
            case 7
                fname='CMMF7';% function name
                n_obj=2;        % the dimensions of the objective space
                n_var=2;        % the dimensions of the decision space
                xl=[-1 -1];      % the low bounds of the decision variables
                xu=[1 1];        % the up bounds of the decision variables
                repoint=[1.1,1.1];
             case 8
                fname='CMMF8'; % function name
                n_obj=2;        % the dimensions of the objective space
                n_var=2;        % the dimensions of the decision space
                xl=[0 0];         % the low bounds of the decision variables
                xu=[2 2];        % the up bounds of the decision variables
               repoint=[1.1,1.1];
              case 9
                fname='CMMF9';  % function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[0 0];        % the low bounds of the decision variables
                xu=[2 2];       % the up bounds of the decision variables
                repoint=[1.1,1.1]; % reference point used to calculate the Hypervolume
            case 10
               fname='CMMF10';  % function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[-1 -1];     % the low bounds of the decision variables
                xu=[1 1];      % the up bounds of the decision variables
               repoint=[1.1,1.1]; % reference point used to calculate the Hypervolume
            case 11
                fname='CMMF11';  % function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[-1 -1];     % the low bounds of the decision variables
                xu=[1 1];      % the up bounds of the decision variables
                repoint=[1.1,1.1];
            case 12
                fname='CMMF12';  % function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[-1 -1];     % the low bounds of the decision variables
                xu=[1 1];      % the up bounds of the decision variables
                repoint=[1.1,1.1];
             case 13
                 %*need to be modified
                fname='CMMF13';  % function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[-1 -1];     % the low bounds of the decision variables
                xu=[1 1];      % the up bounds of the decision variables
                repoint=[1.1,1.43275];
             case 14
                fname='CMMF14';  % function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[-1 -1];     % the low bounds of the decision variables
                xu=[1  1];      % the up bounds of the decision variables
                repoint=[1.19918226131,1.19918226131];
              case 15
                fname='CMMF15';  % function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[-1 0];     % the low bounds of the decision variables
                xu=[1  1];      % the up bounds of the decision variables
                repoint=[1.65,1.65];
             case 16
                fname='CMMF16';  % function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[-2 -2];     % the low bounds of the decision variables
                xu=[2 2];      % the up bounds of the decision variables
                repoint=[1.1,6.6];
            case 17
                fname='CMMF17';  % function name
                n_obj=2;       % the dimensions of the objective space
                n_var=2;       % the dimensions of the decision space
                xl=[-1 -1];     % the low bounds of the decision variables
                xu=[1 1];      % the up bounds of the decision variables
                repoint=[2.2,2.2];
        end
       %% Load reference PS and PF data
          load  (strcat([fname,'_Reference_PSPF_data']));
          load  (strcat([fname,'_Reference_PSPF_data']))
       %% Initialize the population size and the maximum evaluations
          popsize=50*n_var;
          Max_fevs=5000*n_var;
          Max_Gen=fix(Max_fevs/popsize);
           for j=1:runtimes
               %% Search the PSs using CMMODE
               [ps,pf,cons]=CMMODE(fname,xl,xu,n_obj,popsize,Max_Gen);
               % Indicators
               IGDx=IGD_calculation(ps,PS);  % Calculate IGDX values
               IGDf=IGD_calculation(pf,PF);    % Calculate IGDF values
               CR=CR_calculation(ps,PS);       % Calculate CR values
               CV=cv_calculation(cons);         % Calculate meanCV values
               rPSP=IGDx/CR;                         % Calculate rPSP values
               Indicator.CMMODE(j,:)=[rPSP,CV,IGDx,IGDf];
               PSdata.CMMODE{j}=ps;
               PFdata.CMMODE{j}=pf;
               clear ps pf IGDx IGDf CR rPSP
               fprintf('Running test function: %s \n %d times \n', fname,j);
           end
       %% Calculate mean and std of the indicators
        %% CMMODE
            Table.CMMODE.rPSP(i_func,:)=(Indicator.CMMODE(:,1))';
            Table.CMMODE.CV(i_func,:)=(Indicator.CMMODE(:,2))';
            Table.CMMODE.IGDX(i_func,:)=(Indicator.CMMODE(:,3))';
            Table.CMMODE.IGDF(i_func,:)=(Indicator.CMMODE(:,4))';
       %% save resultdata
%          save(strcat([fname,'PSPF_indicator_data']),'PSdata','PFdata','Indicator');
save 
            clear PSdata PFdata Indicator
     end
     save Table