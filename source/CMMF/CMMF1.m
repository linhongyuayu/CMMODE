function  [Outcome] = CMMF1(PopDec) 


M=2;
                OptX = 0.2;
                [N,D]  = size(PopDec);
                Pop=PopDec; 
for i=1:N
    if PopDec(i,1)<=0
        PopDec(i,1)=PopDec(i,1)+1;
    end
end
                obj.Sx = cumsum(PopDec(:,1:M).^2,2,'reverse'); 
                obj.THETA_ = 2/pi*atan(sqrt(obj.Sx(:,2:end))./PopDec(:,1:M-1));
                obj.h = sum((PopDec(:,M+1:D) - OptX).^2,2);    
                T_ = (0.98 - obj.Sx(:,1)).^2 + obj.h;
                G_ = [ones(N,1) cumprod(obj.THETA_,2)] .* [1-obj.THETA_ ones(N,1)];
                PopObj = G_ .* repmat((1+T_),1,M);    
                a = 1.0/4.0;
                b = 2.0/4.0;
                c = 3.0/4.0;
                d = 4.0/4.0;
                for i=1:N
                    if obj.Sx(i,1)<=0.36
                        PopCon(i,1)=obj.Sx(i,1)-0.36;
                        PopCon(i,2)=-obj.Sx(i,1)+0.04;
                    elseif Pop(i,1)<0&&Pop(i,2)>0  
                        if  obj.THETA_(i,1)<=b
                            PopCon(i,3)= -(obj.THETA_(i,1)- a);
                            PopCon(i,4)= obj.Sx(i,1)-1;
                            PopCon(i,5)= -obj.Sx(i,1)+0.96;
                            PopCon(i,6)= 0;
                        elseif obj.THETA_(i,1)>b
                            PopCon(i,3)=-obj.THETA_(i,1)+c;
                            PopCon(i,4)= obj.Sx(i,1)-1;
                            PopCon(i,5)= -obj.Sx(i,1)+0.96;
                            PopCon(i,6)= 0;
                        end
                    elseif Pop(i,1)<0&&Pop(i,2)<0
                        if  obj.THETA_(i,1)<=b
                            PopCon(i,3) = obj.THETA_(i,1)- a ;
                            PopCon(i,4)= -obj.Sx(i,1)+0.96;
                            PopCon(i,5)= obj.Sx(i,1)-1;
                            PopCon(i,6)= 0;
                        elseif obj.THETA_(i,1)>b
                            PopCon(i,3) =- obj.THETA_(i,1)+b;
                            PopCon(i,4) = obj.THETA_(i,1)- c ;
                            PopCon(i,5)= -obj.Sx(i,1)+0.96;
                            PopCon(i,6)= obj.Sx(i,1)-1;
                        end
                    elseif Pop(i,1)>=0&&Pop(i,2)>=0
                        if obj.THETA_(i,1)<=b
                            PopCon(i,3) =- obj.THETA_(i,1);
                            PopCon(i,4) = obj.THETA_(i,1)- a ;
                            PopCon(i,5)= -obj.Sx(i,1)+0.96;
                            PopCon(i,6)= obj.Sx(i,1)-1;
                        elseif obj.THETA_(i,1)>b
                            PopCon(i,3) =- obj.THETA_(i,1)+b;
                            PopCon(i,4) = obj.THETA_(i,1)- c ;
                            PopCon(i,5)= -obj.Sx(i,1)+0.96;
                            PopCon(i,6)= obj.Sx(i,1)-1;
                        end
                    else                             
                        if  obj.THETA_(i,1)<=b
                            PopCon(i,3)= -(obj.THETA_(i,1)- a);
                            PopCon(i,4)= obj.Sx(i,1)-1;
                            PopCon(i,5)= -obj.Sx(i,1)+0.96;
                            PopCon(i,6)= 0;
                        elseif obj.THETA_(i,1)>b
                            PopCon(i,3)=-obj.THETA_(i,1)+c;
                            PopCon(i,4)= obj.Sx(i,1)-1;
                            PopCon(i,5)= -obj.Sx(i,1)+0.96;
                            PopCon(i,6)= 0;
                        end
                    end
                end
                
                PopCon(PopCon <= 0) = 0;
                PopCon = abs(PopCon);
                PopCon = sum(PopCon,2);
                Outcome=[PopObj PopCon];
end
       