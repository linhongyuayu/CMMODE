function  [Outcome] = CMMF16(PopDec) 
                M=2;
                OptX = 0.2;
                [N,D]  = size(PopDec);
                Pop=PopDec;
                obj.Sx = cumsum(Pop(:,1:M).^2,2,'reverse');
                obj.THETA_=zeros(N,1);
                for i=1:N
                    if Pop(i,1)==0|| Pop(i,1)==-2
                        obj.THETA_(i) = 1;
                    else
                        if Pop(i,1)>0
                            obj.THETA_(i) = 2/pi*atan(abs(Pop(i,2))./Pop(i,1));
                        elseif Pop(i,1)<0&&Pop(i,2)>0
                            obj.THETA_(i) = 2/pi*atan((2-Pop(i,2))./(Pop(i,1)+2));
                        elseif Pop(i,1)<0&&Pop(i,2)<=0
                            obj.THETA_(i) = 2/pi*atan(abs(Pop(i,2))./abs(Pop(i,1)));
                        end
                    end
                end     
if D>2
    obj.h = 20 - 20 * exp(-0.2 * sqrt(sum((PopDec(:,M+1:end)-OptX).^2,2)/(D-M))) + exp (1)...
        - exp(sum(cos(2 * pi .*(PopDec(:,M+1:end)-OptX)),2)/(D-M));
else
    obj.h = zeros( size(PopDec,1),1);
end    

                T_=zeros(N,1);
                G_=zeros(N,M);
                for i=1:N
                    if Pop(i,1)>=0
                        T_(i) = (1-Pop(i,1).^2-Pop(i,2).^2).^2 + obj.h(i);
                        G_(i,1:M) = [ones(1,1) cumprod(sin(pi/2*obj.THETA_(i)),2)] .* [cos(pi/2*obj.THETA_(i)) ones(1,1)];
                    elseif  Pop(i,1)<0&&Pop(i,2)>0
                        T_(i) = (1-(2+Pop(i,1)).^2-(2-Pop(i,2)).^2).^2 + obj.h(i);
                        G_(i,1:M) = [ones(1,1) cumprod(sin(pi/2*obj.THETA_(i)),2)] .* [cos(pi/2*obj.THETA_(i)) ones(1,1)];
                    elseif Pop(i,1)<0&&Pop(i,2)<=0
                        T_(i) = (4-Pop(i,1).^2-Pop(i,2).^2).^2 + obj.h(i);
                        G_(i,1:M) = [ones(1,1) cumprod(sin(pi/2*obj.THETA_(i)),2)] .* [cos(pi/2*obj.THETA_(i)) ones(1,1)];
                    end
                end
                 PopObj = G_ .* repmat((1+T_),1,M);          
                 PopCon=zeros(N,3);
                for i=1:N
                    if Pop(i,1)>=0&&Pop(i,2)>=0   
                        PopCon(i,1)=3.24*Pop(i,1).^2+Pop(i,2).^2-3.24;
                        PopCon(i,2)=-1.8*(Pop(i,1)-1)-Pop(i,2);
                        PopCon(i,3)=0;
                    elseif Pop(i,1)<0&&Pop(i,2)>=0  
                        PopCon(i,1)=-1.8*(1+Pop(i,1))+Pop(i,2)-2;
                        PopCon(i,2)=-(-1.8*(1+Pop(i,1))+Pop(i,2)-1.98);
                        PopCon(i,3)=-obj.THETA_(i)+2/pi*atan(45/28);
                    elseif Pop(i,1)<0&&Pop(i,2)<0  
                        PopCon(i,1)=obj.THETA_(i)-2/pi*atan(45/28);
                        PopCon(i,2)=Pop(i,1).^2+Pop(i,2).^2-4;
                        PopCon(i,3)=-Pop(i,1).^2-Pop(i,2).^2+3.98;
                    elseif Pop(i,1)>=0&&Pop(i,2)<0  
                        PopCon(i,1)=obj.THETA_(i)-2/pi*atan(45/28);
                        PopCon(i,2)=Pop(i,1).^2+Pop(i,2).^2-0.81;
                        PopCon(i,3)=0;
                    end
                end
             PopCon(PopCon <= 0) = 0;
             PopCon = sum(PopCon,2);
             Outcome=[PopObj PopCon];
end