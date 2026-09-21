function  [Outcome] = CMMF4(PopDec)
M=2;
OptX = 0.2;
[N,D]  = size(PopDec);
Pop=PopDec;
obj.Sx = cumsum(Pop(:,1:M).^2,2,'reverse');
obj.THETA_=zeros(N,1);
for i=1:N
    if Pop(i,1)>0
        obj.THETA_(i) = 2/pi*atan(abs(Pop(i,2))./abs(Pop(i,1)));
    elseif Pop(i,1)==0 || Pop(i,1)==-1
        obj.THETA_(i)=1;
    else
        obj.THETA_(i) = 2/pi*atan(abs(Pop(i,2))./(Pop(i,1)+1));
    end
end

if D>2
    obj.h = 20 - 20 * exp(-0.2 * sqrt(sum((PopDec(:,M+1:end)-OptX).^2,2)/(D-M))) + exp (1)...
        - exp(sum(cos(2 * pi .*(PopDec(:,M+1:end)-OptX)),2)/(D-M));
else
    obj.h = zeros(size(PopDec,1),1);
end

T_=zeros(N,1);
G_=zeros(N,M);
for i=1:N
    if Pop(i,1)>=0
        T_(i) = (0.96 -Pop(i,1).^2-Pop(i,2).^2 ).^2 + obj.h(i);
        G_(i,1:M) = 1-[ones(1,1) cumprod(sin(pi/2*obj.THETA_(i)),2)] .* [cos(pi/2*obj.THETA_(i)) ones(1,1)];
    else
        T_(i) = (0.96 - (PopDec(i,1)+1).^2-PopDec(i,2).^2).^2 + obj.h(i);
        G_(i,1:M) = 1-[ones(1,1) cumprod(sin(pi/2*obj.THETA_(i)),2)] .* [cos(pi/2*obj.THETA_(i)) ones(1,1)];
    end
end
PopObj = G_ .* repmat((1+T_),1,M);
%% PopCon
PopCon(:,1)=-Pop(:,2);
for i=1:N
    if Pop(i,1)<0
        if (PopDec(i,1)+1)^2+PopDec(i,2)^2 <=0.49
            PopCon(i,2)= (PopDec(i,1)+1)^2+PopDec(i,2)^2 - 0.36;
            PopCon(i,3)= -(PopDec(i,1)+1)^2-PopDec(i,2)^2+0.04;
        else
            PopCon(i,2)= (PopDec(i,1)+1)^2+PopDec(i,2)^2 - 1;
            PopCon(i,3)= -(PopDec(i,1)+1)^2-PopDec(i,2)^2 + 0.64;
        end
    elseif Pop(i,1)>=0
        if PopDec(i,1)^2+PopDec(i,2)^2 <=0.49
            PopCon(i,2)= PopDec(i,1)^2+PopDec(i,2)^2 - 0.36;
            PopCon(i,3)= -PopDec(i,1)^2-PopDec(i,2)^2+0.04;
        else
            PopCon(i,2)= PopDec(i,1)^2+PopDec(i,2)^2 - 1;
            PopCon(i,3)= -PopDec(i,1)^2-PopDec(i,2)^2 + 0.64;
        end
    end
end
PopCon(PopCon <= 0) = 0;
PopCon = abs(PopCon);
PopCon = sum(PopCon,2);
Outcome=[PopObj PopCon];
end