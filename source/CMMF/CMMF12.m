function  [Outcome] = CMMF12(PopDec) 
                M=2;
                OptX = 0.2;
                [N,D]  = size(PopDec);
                Pop=PopDec;
                obj.Sx = cumsum(PopDec(:,1:M).^2,2,'reverse');
                obj.THETA_=zeros(N,1);
                for i=1:N
                    if Pop(i,1)>0
                        obj.THETA_(i) = 2/pi*atan(abs(Pop(i,2))./Pop(i,1));
                    elseif Pop(i,1)==0
                        obj.THETA_(i) = 1;
                    elseif Pop(i,1)<0
                        obj.THETA_(i) = 2/pi*atan(abs(Pop(i,2))./abs(Pop(i,1)));
                    end
                end 
                obj.h = sum((PopDec(:,M+1:D) - OptX).^2,2);
                h=obj.h;
                T_=zeros(N,1);
                G_=zeros(N,M);
                for i=1:N
                    T_(i) = (1 - Pop(i,1).^2-4*Pop(i,2).^2).^2 + obj.h(i);
                   G_(i,1:M) = 1-[ones(1,1) cumprod(sin(pi/2*obj.THETA_(i)),2)] .* [cos(pi/2*obj.THETA_(i)) ones(1,1)];
                end
                PopObj = G_ .* repmat((1+T_),1,M);

                PopCon=zeros(N,4);
                for i=1:N
                    if Pop(i,1)>=0&&Pop(i,2)>=0   
                        PopCon(i,1)=-obj.THETA_(i)+1/2;
                        PopCon(i,2)=obj.THETA_(i)-2/3;
                        PopCon(i,3)=Pop(i,1).^2+Pop(i,2).^2-1;
                        PopCon(i,4)=0;
                    elseif Pop(i,1)<0&&Pop(i,2)>=0 
                        PopCon(i,1)=obj.THETA_(i)-1/2;
                        PopCon(i,2)=-obj.THETA_(i)+1/3;
                        PopCon(i,3)=Pop(i,1).^2+3*Pop(i,2).^2-1 ;
                        PopCon(i,4)=-Pop(i,1).^2-5*Pop(i,2).^2+1 ;
                    elseif Pop(i,1)<0&&Pop(i,2)<0
                        PopCon(i,1)=obj.THETA_(i)-1/2;
                        PopCon(i,2)=-obj.THETA_(i)+1/3;
                        PopCon(i,3)=-Pop(i,1).^2-4*Pop(i,2).^2+1-0.04;
                        PopCon(i,4)=Pop(i,1).^2+4*Pop(i,2).^2-1-0.04;
                    else
                        PopCon(i,1)=-obj.THETA_(i)+1/2;
                        PopCon(i,2)=obj.THETA_(i)-2/3;
                        PopCon(i,3)=-Pop(i,1).^2-4*(Pop(i,2)-0.04).^2+1;
                        PopCon(i,4)=Pop(i,1).^2+4*(Pop(i,2)+0.04).^2-1;
                    end
                end
                                          PopCon(PopCon <= 0) = 0;
             PopCon = abs(PopCon);
             PopCon = sum(PopCon,2);
             Outcome=[PopObj PopCon];
end