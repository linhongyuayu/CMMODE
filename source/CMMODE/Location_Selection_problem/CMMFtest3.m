function  [Outcome] = CMMFtest3(PopDec) 
                M=3;
                [N,~]  = size(PopDec);
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


%% Calculate objective values
PopObj = NaN(N,M);
 
temp1=pdist2(PopDec(:,1:2),A(:,1:2));
temp2=pdist2(PopDec(:,1:2),B(:,1:2));
temp3=pdist2(PopDec(:,1:2),C(:,1:2));         
            
PopObj(:,1) = min(temp1,[],2);
PopObj(:,2) = min(temp2,[],2);
PopObj(:,3) = min(temp3,[],2);

            
            PopCon1=zeros(N,1);  
            PopCon2=zeros(N,1);  
            PopCon3=zeros(N,1);  
            
            PopCon4=zeros(N,1);  
            PopCon5=zeros(N,1);  
            PopCon6=zeros(N,1);  
            
            PopCon7=zeros(N,1);  
            PopCon8=zeros(N,1); 
            PopCon9=zeros(N,1);  
            
            PopCon10=zeros(N,1);  
            PopCon11=zeros(N,1);  
            
%%
for i=1:N
x=PopDec(i,1);
y=PopDec(i,2);
XX=[PopDec(i,1) PopDec(i,2)];
%% 
if x >=0.0951 && x<= 0.72
    p1 =     -0.5756  ;
    p2 =      0.5603  ;
    p3 =      0.7404  ;
    p4 =     -0.6413  ;
    p5 =      0.2269  ;
    lake_lower = p1.*x.^4 + p2.*x.^3 + p3.*x.^2 + p4.*x + p5;
    aa1 =      0.4944  ;
    bb1 =       3.694  ;
    cc1 =      0.1075  ;
    aa2 =      0.1703  ;
    bb2 =       19.14  ;
    cc2 =      -5.126  ;
    aa3 =      0.1867  ;
    bb3 =       19.97  ;
    cc3 =       3.978 ;
    lake_upper = aa1.*sin(bb1.*x+cc1) + aa2.*sin(bb2.*x+cc2) + aa3.*sin(bb3.*x+cc3);
    if y > lake_upper || y < lake_lower
        PopCon2(i,1)=0;
    else
        X2=0.0951:0.0001:0.72 ;
        Y2_lower = p1.*X2.^4 + p2.*X2.^3 + p3.*X2.^2 + p4.*X2 + p5;
        Y2_upper = aa1*sin(bb1.*X2+cc1) + aa2.*sin(bb2.*X2+cc2) + aa3.*sin(bb3.*X2+cc3);
        Y2=[Y2_lower Y2_upper];
        XX2=[X2 X2];
        lake=[XX2;Y2]';
        [~,distance2,~] = distance2curve(lake,XX,'linear');
        PopCon2(i,1)=1./(distance2+0.001);
    end
else
    PopCon2(i,1)=0;
end


%% 
       a1 =      0.5387  ;
       b1 =      0.4465  ;
       c1 =        2.06  ;
       a2 =      0.1543  ;
       b2 =       2.787  ;
       c2 =       1.199  ;
       a3 =      0.1718  ;
       b3 =       4.375  ;
       c3 =       1.241  ;
       a4 =     0.04322  ;
       b4 =       11.78  ;
       c4 =       1.893  ;
X1=0:0.0001:2.5;
Y1 =a1.*sin(b1*(X1.*(0.7))+c1) + a2.*sin(b2.*(X1.*(0.7))+c2) + a3.*sin(b3.*(X1.*(0.7))+c3) + a4.*sin(b4.*(X1.*(0.7))+c4)+0.42;
river=[X1;Y1]';  
[~,distance1,~] = distance2curve(river,XX,'linear');
if distance1>0.06
    PopCon1(i,1)=0;
else
    PopCon1(i,1)=1./(distance1+0.001);
end


%% 
if x<1 && y>0.5 && y<=1.2
    X3=0.4:0.0001:0.83;
    Y3=(1/2).*X3+0.76;
    bridge=[X3;Y3]';
    [~,distance3,~] = distance2curve(bridge,XX,'linear');
    if distance3>0.06
        PopCon3(i,1)=0;
    else
        PopCon3(i,1)=1./(distance3+0.001);
    end
else
    PopCon3(i,1)= 0;
end


%%
if x >=0.8 && x<= 0.86
    distance4= abs(x-0.83);
    PopCon4(i,1)= 1./(distance4+0.001);
else
    PopCon4(i,1)=0;
end

if x >=1.5 && x<= 1.54
    distance5= abs(x-1.52);
    PopCon5(i,1)= 1./(distance5+0.001);
else
    PopCon5(i,1)=0;
end

if x >=2.04 && x<= 2.1
    distance6= abs(x-2.07);
    PopCon6(i,1)= 1./(distance6+0.001);
else
    PopCon6(i,1)=0;
end

%% 7、8、9
if x > 0.86 && x<2.04 && y>=1.28 && y<=1.3
    distance7= abs(y-1.29);
    PopCon7(i,1)= 1./(distance7+0.001);
else
    PopCon7(i,1)=0;
end

if x > 2.1 && y>=1.1 && y<=1.12
    distance8= abs(y-1.11);
    PopCon8(i,1)= 1./(distance8+0.001);
else
    PopCon8(i,1)=0;
end

if x > 0.86 && y>=0.23 && y<=0.25
    distance9= abs(y-0.24);
    PopCon9(i,1)= 1./(distance9+0.001);
else
    PopCon9(i,1)=0;
end

%%  10、11
if x >= 2 && x<=2.14 && y>=0.17 && y<=0.31
    distance10= sqrt((x-2.07)^2+(y-0.24)^2);
    if distance10<=0.06
        PopCon10(i,1)= 1./(distance10+0.001);
    else
        PopCon10(i,1)=0;
    end
else
    PopCon10(i,1)=0;
end

if x >= 1.46 && x<=1.58 && y>=1.23 && y<=1.35
    distance11= sqrt((x-1.52)^2+(y-1.29)^2);
    if distance11<=0.05
        PopCon11(i,1)= 1./(distance11+0.001);
    else
        PopCon11(i,1)=0;
    end
else
    PopCon11(i,1)=0;
end
end
PopCon=[PopCon1 PopCon2 PopCon3 PopCon4 PopCon5 PopCon6 PopCon7 PopCon8 PopCon9 PopCon10 PopCon11];
PopCon(PopCon <= 0) = 0;
PopCon = abs(PopCon);
PopCon = sum(PopCon,2);
Outcome=[PopObj PopCon];
         
end