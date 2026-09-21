function  [Outcome] = CMMF13(PopDec) 
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
                    else
                        obj.THETA_(i) = 2/pi*atan(abs(Pop(i,2))./abs(Pop(i,1)));
                    end
                end 
                obj.h = sum((PopDec(:,M+1:D) - OptX).^2,2);
                T_=zeros(N,1);
                G_=zeros(N,M);
                for i=1:N
                    if Pop(i,1)>=0&&Pop(i,2)>=0   
                        T_(i) = (0.64 -obj.Sx(i,1)).^2 + obj.h(i);
                        G_(i,1:M) = [ones(1,1) cumprod(obj.THETA_(i),2)] .* [1-obj.THETA_(i) ones(1,1)];
                    elseif Pop(i,1)<0&&Pop(i,2)>=0  
                        T_(i) = (0.36 - obj.Sx(i,1)).^2 + obj.h(i);
                        G_(i,1:M) = [ones(1,1) cumprod(obj.THETA_(i),2)] .* [1-obj.THETA_(i) ones(1,1)];
                        elseif Pop(i,1)<0&&Pop(i,2)<0  
                        T_(i) = (0.64 - obj.Sx(i,1)).^2 + obj.h(i);
                        G_(i,1:M) = [ones(1,1) cumprod(obj.THETA_(i),2)] .* [1-obj.THETA_(i) ones(1,1)];
                        elseif Pop(i,1)>=0&&Pop(i,2)<0  
                        T_(i) = (0.09 - obj.Sx(i,1)).^2 + obj.h(i);
                        G_(i,1:M) = [ones(1,1) cumprod(obj.THETA_(i),2)] .* [1-obj.THETA_(i) ones(1,1)];
                    end
                end
                PopObj = G_ .* repmat((1+T_),1,M);
                a = 1.0/4.0;
                b = 2.0/4.0;
                c = 3.0/4.0;
                d = 4.0/4.0;
                PopCon=zeros(N,4);
                for i=1:N
                    if Pop(i,1)<0&&Pop(i,2)<0   
                        PopCon(i,1) = obj.THETA_(i,1)- a ;
                        PopCon(i,2)= -obj.THETA_(i,1);
                        PopCon(i,3)= obj.Sx(i,1)-0.66;
                        PopCon(i,4)= -obj.Sx(i,1)+0.62;
                    elseif Pop(i,1)>=0&&Pop(i,2)>=0   
                        PopCon(i,1) =- obj.THETA_(i,1)+c;
                        PopCon(i,2) = obj.THETA_(i,1)- d ;
                        PopCon(i,3)= -Pop(i,1)-Pop(i,2)+0.3;
                        PopCon(i,4)= Pop(i,1).^2+ Pop(i,2).^2-0.09;
                    elseif Pop(i,1)<0&&Pop(i,2)>=0    
                        PopCon(i,1) =- obj.THETA_(i,1)+c;
                        PopCon(i,2) = obj.THETA_(i,1)- d ;
                        PopCon(i,3)= -Pop(i,1).^2-Pop(i,2).^2+0.91;
                        PopCon(i,4)= Pop(i,1).^2+ Pop(i,2).^2-1;
                    elseif  Pop(i,1)>=0&&Pop(i,2)<0   
                        PopCon(i,1) = obj.THETA_(i,1)- a ;
                        PopCon(i,2)= -obj.THETA_(i,1);
                        PopCon(i,3)= -Pop(i,1)+Pop(i,2)+0.3;
                        PopCon(i,4)= Pop(i,1).^2+ 0.25*Pop(i,2).^2-0.09;
                    end
                end
             PopCon(PopCon <= 0) = 0;
             PopCon = abs(PopCon);
             PopCon = sum(PopCon,2);
             Outcome=[PopObj PopCon];
end