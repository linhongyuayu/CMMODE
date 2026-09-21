function  [Outcome] = CMMF8(PopDec) 
                M=2;
                OptX = 0.2;
                [N,D]  = size(PopDec);
                Pop=PopDec;
                obj.Sx = cumsum(Pop(:,1:M).^2,2,'reverse');
                obj.THETA_=zeros(N,1);
                for i=1:N
                    if Pop(i,1)>1
                        obj.THETA_(i) = 2/pi*atan(Pop(i,2)/(Pop(i,1)-1));
                    elseif Pop(i,1)<1
                        obj.THETA_(i) = 2/pi*atan(Pop(i,2)/(1-Pop(i,1)));
                    else
                        obj.THETA_(i) = 1;
                    end
                end
if D>2
    obj.h = 20 - 20 * exp(-0.2 * sqrt(sum((PopDec(:,M+1:end)-OptX).^2,2)/(D-M))) + exp (1)...
        - exp(sum(cos(2 * pi .*(PopDec(:,M+1:end)-OptX)),2)/(D-M));
else
    obj.h = zeros(size(PopDec,1),1);
end     
                G_=zeros(N,M);
                T_=zeros(N,1);
                for i=1:N
                    if Pop(i,1)>1
                        T_(i) = (4 - 4*(2-Pop(i,1))^2-(2-Pop(i,2))^2).^2 + obj.h(i);
                       G_(i,1:M) = 1-[ones(1,1) cumprod(sin(pi/2*obj.THETA_(i)),2)] .* [cos(pi/2*obj.THETA_(i)) ones(1,1)];
                    elseif Pop(i,1)<=1
                        T_(i) = (4 - 4*(1-Pop(i,1))^2-(Pop(i,2))^2).^2 + obj.h(i);
                        G_(i,1:M) = 1-[ones(1,1) cumprod(sin(pi/2*obj.THETA_(i)),2)] .* [cos(pi/2*obj.THETA_(i)) ones(1,1)];
                    end
                end
                PopObj = G_ .* repmat((1+T_),1,M) ;      
             PopCon=zeros(N,2);
             for i=1:N
                 PopCon(i,1)=obj.THETA_(i)-2/3;
                 PopCon(i,2)=-obj.THETA_(i)+1/3;
             end  
                                       PopCon(PopCon <= 0) = 0;
             PopCon = abs(PopCon);
             PopCon = sum(PopCon,2);
             Outcome=[PopObj PopCon];
end