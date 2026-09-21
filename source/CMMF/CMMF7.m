function  [Outcome] = CMMF7(PopDec) 
                M=2;
                OptX = 0.2;
                [N,D]  = size(PopDec);
                Pop=PopDec;
                obj.Sx = cumsum(Pop(:,1:M).^2,2,'reverse');
                obj.THETA_=zeros(N,1);
                for i=1:N
                    if Pop(i,1)>-1/2
                        obj.THETA_(i) = 2/pi*atan(abs(Pop(i,2))./abs(Pop(i,1)));
                    elseif Pop(i,1)==-1/2 ||Pop(i,1)==0
                        obj.THETA_(i) = 1;
                    else
                        obj.THETA_(i) = 2/pi*atan(abs(Pop(i,2))./abs((Pop(i,1)+1/2)));
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
                    if Pop(i,1)>-1/2
                        T_(i) = (0.96 - Pop(i,1)^2-Pop(i,2)^2).^2 + obj.h(i);
                        G_(i,1:M) = 1-[ones(1,1) cumprod(sin(pi/2*obj.THETA_(i)),2)] .* [cos(pi/2*obj.THETA_(i)) ones(1,1)];
                    else 
                        T_(i) = (0.25 - (Pop(i,1)+0.5)^2-Pop(i,2)^2).^2 + obj.h(i);
                        G_(i,1:M) = 1-[ones(1,1) cumprod(sin(pi/2*obj.THETA_(i)),2)] .* [cos(pi/2*obj.THETA_(i)) ones(1,1)];
                    end
                end
                PopObj = G_ .* repmat((1+T_),1,M) ;      
             %% PopCon
             PopCon=zeros(N,4);
             for i=1:N
                 PopCon(i,1)=Pop(i,1)*Pop(i,2)+eps;
                 PopCon(i,2)=-obj.Sx(i,1)+0.5;
                 PopCon(i,3)= obj.Sx(i,1)-1;
                 PopCon(i,4)= abs(Pop(i,2))-abs(Pop(i,1));
             end      
                                       PopCon(PopCon <= 0) = 0;
             PopCon = abs(PopCon);
             PopCon = sum(PopCon,2);
             Outcome=[PopObj PopCon];
end