function [FrontNo,MaxFNo] = NDSort(Pop,D,M,N)
    nsort  = N;
    PopObj = Pop(:,D+1:D+M);
    PopCon=Pop(:,D+M+1);
        Infeasible = PopCon>0;
        PopObj(Infeasible,:) =repmat(max(PopObj,[],1),sum(Infeasible),1) +...
            repmat(sum(max(0,PopCon(Infeasible,:)),2),1,M);  
        [FrontNo,MaxFNo] = ENS_SS(PopObj,nsort);
end


function [FrontNo,MaxFNo] = ENS_SS(PopObj,nSort)
    [PopObj,~,Loc] = unique(PopObj,'rows');  
    Table   = hist(Loc,1:max(Loc));
    [N,M]   = size(PopObj);
    FrontNo = inf(1,N);
    MaxFNo  = 0;
    while sum(Table(FrontNo<inf)) < min(nSort,length(Loc))
        MaxFNo = MaxFNo + 1;
        for i = 1 : N
            if FrontNo(i) == inf
                Dominated = false;   %Dominated=0
                for j = i-1 : -1 : 1
                    if FrontNo(j) == MaxFNo
                        m = 2;
                        while m <= M && PopObj(i,m) >= PopObj(j,m)
                            m = m + 1;
                        end
                        Dominated = m > M;
                        if Dominated || M == 2
                            break;
                        end
                    end
                end
                if ~Dominated
                    FrontNo(i) = MaxFNo;
                end
            end
        end
    end
    FrontNo = FrontNo(:,Loc);
end