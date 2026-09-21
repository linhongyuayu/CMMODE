function  [Outcome] = CMMF2(PopDec) 
M=2;
obj.r=0.25;
                OptX = 0.2;
                [N,D]  = size(PopDec);
                Pop=PopDec; 
                obj.Sx = cumsum(Pop(:,1:M).^2,2,'reverse'); 
                obj.THETA_ = 2/pi*atan(sqrt(obj.Sx(:,2:end))./abs(Pop(:,1:M-1)));
               obj.h = sum(100*((PopDec(:,M+1:end-1)-OptX).^2-(PopDec(:,M+2:end)-OptX)).^2+...
                   (PopDec(:,M+1:end-1)-OptX).^2,2);     
                T_=zeros(N,1);
                for i=1:N
                    if Pop(i,1)<0
                        T_(i) = (1/16 - Pop(i,1).^2 -0.25*Pop(i,2).^2 ).^2 + obj.h(i);
                    else
                        T_(i) = (0.25 - Pop(i,1).^2 -0.25*Pop(i,2).^2 ).^2 + obj.h(i);
                    end
                end
                G_ = [ones(N,1) cumprod(sin(pi/2*obj.THETA_),2)] .* [cos(pi/2*obj.THETA_) ones(N,1)];% P2
                PopObj = G_ .* repmat((1+T_),1,M) ;            
                b = 2.0/4.0;
                for i=1:N
                    if Pop(i,1)<0&&Pop(i,2)>=0    
                            PopCon(i,1)= -obj.Sx(i,1)-0.04;
                            PopCon(i,2)= obj.Sx(i,1)-0.25;
                            PopCon(i,3)= obj.THETA_(i,1)-b;
                    elseif Pop(i,1)<0&&Pop(i,2)<0   
                            PopCon(i,1)= -obj.Sx(i,1)-0.04;
                            PopCon(i,2)= obj.Sx(i,1)-0.25;
                            PopCon(i,3)= -obj.THETA_(i,1)+b;
                    elseif Pop(i,1)>=0&&Pop(i,2)>=0  
                        PopCon(i,1)= -(obj.THETA_(i,1)-b);
                        PopCon(i,2)= -obj.Sx(i,1)+0.36;
                        PopCon(i,3)= obj.Sx(i,1)-1;
                    else                               
                        PopCon(i,1)= obj.THETA_(i,1)-b;
                        PopCon(i,2)= -obj.Sx(i,1)+0.16;
                        PopCon(i,3)= obj.Sx(i,1)-0.49;
                    end
                end
                PopCon(PopCon <= 0) = 0;
                PopCon = abs(PopCon);
                PopCon = sum(PopCon,2);
                Outcome=[PopObj PopCon];
end