clc
load Pop_best_con
%% 
plot(Pop_best(:,1),Pop_best(:,2),'c.')
hold on
%%
feasible=Pop(:,end)==0;
infeasible=~feasible;
Pop_infeasible=PopDec(infeasible,:);
plot(Pop_infeasible(:,1),Pop_infeasible(:,2),'.','color',[0.5 0.5 0.5])
hold on
%%
A1=[0.1,1.4];    
A2=[0.78,1.48];
A3=[2.02,0.56];
A4=[2.02-cos(pi*5/12)/2+sqrt(2)/4,0.56+sin(pi*5/12)/2+sqrt(2)/4];
A5=[0.75,0.47];
A=[A1;A2;A3;A4;A5]; 
B1=[0.1,0.9];  
B2=[0.78+sin(pi/9)/2,1.48-cos(pi/9)/2];
B3=[2.02+sqrt(2)/4,0.56+sqrt(2)/4];
B4=[0.34,0.095];
B=[B1;B2;B3;B4]; 
C1=[0.533,1.15];
C2=[0.78+sin(pi/9)/2+cos(pi*5/18)/2,1.48-cos(pi/9)/2+sin(pi*5/18)/2];
C3=[2.02-cos(pi*5/12)/2,0.56+sin(pi*5/12)/2]; 
C4=[0.995,0.775];
C5=[0.925,0.05];
C6=[1.965,0.165];
C7=[1.62,1.34];
C8=[1.45,0.445];
C9=[2.335,0.2];
C10=[0.325,0.715];
C=[C1;C2;C3;C4;C5;C6;C7;C8;C9;C10];

sz=30;
scatter(A(:,1),A(:,2),sz,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0.4 1],'LineWidth',1.5);
hold on 
scatter(B(:,1),B(:,2),sz,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 1 0],'LineWidth',1.5);
hold on 
scatter(C(:,1),C(:,2),sz,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0],'LineWidth',1.5);
hold on 

%% change figure
xlabel ('{\itx}_1','FontName','Times New Roman','FontSize',10);  
ylabel ('{\itx}_2','FontName','Times New Roman','FontSize',10);  
set(get(gca,'YLabel'),'Rotation', -pi/2);   
Fig_fontsize=8;
set(gca,'Fontname','Times New Roman','Fontsize',Fig_fontsize);
set(get(gca,'XLabel'),'FontName','Times New Roman','FontSize',Fig_fontsize,'Vertical','top');
set(get(gca,'YLabel'),'FontName','Times New Roman','FontSize',Fig_fontsize,'Vertical','middle');
set(gcf,'Units','centimeters');
set(gcf,'Position',[5 5 7.89 5.97]);
set(gca,'Position',[.10 .15 0.8 0.7]); 
% axis fill