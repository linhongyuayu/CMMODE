function Fitness=CalFitness(Pop,D,M)
    N = size(Pop,1);
    PopObj=Pop(:,D+1:D+M);
    PopCon=Pop(:,D+M+1);
    CV = sum(max(0,PopCon),2);                                                                                                                                                                                                                                                                                                            
    %% Detect the dominance relation between each two solutions
    Dominate = false(N);
    for i = 1 : N-1
        for j = i+1 : N
            if CV(i) < CV(j)
                Dominate(i,j) = true;
            elseif CV(i) > CV(j)
                Dominate(j,i) = true;
            else
                k = any(PopObj(i,:)<PopObj(j,:)) - any(PopObj(i,:)>PopObj(j,:));
                if k == 1
                    Dominate(i,j) = true;
                elseif k == -1
                    Dominate(j,i) = true;
                end
            end
        end
    end 
    %% Calculate S(i)
    S = sum(Dominate,2); 
    %% Calculate R(i)
    R = zeros(1,N);
    for i = 1 : N
        R(i) = sum(S(Dominate(:,i)));
    end
    R=R';
    
%% Calculate SCD
[FrontNo,MaxFNo] = NDSort(Pop,D,M,N);
PopDec2=Pop(:,1:2);
PopObj2=Pop(:,3:4);
SpCrowdDis_Obj = CrowdingDistance(PopObj2,FrontNo)';
SpCrowdDis_Dec = CrowdingDistance(PopDec2,FrontNo)';
SpCrowdDis = max(SpCrowdDis_Obj,SpCrowdDis_Dec);
for i = 1 : MaxFNo
    Front   = find(FrontNo==i);
    Avg_Obj = mean(SpCrowdDis_Obj(Front));
    Avg_Dec = mean(SpCrowdDis_Dec(Front));
    replace = SpCrowdDis_Obj(Front)<=Avg_Obj & SpCrowdDis_Dec(Front)<=Avg_Dec;
    SpCrowdDis(Front(replace)) = min(SpCrowdDis_Obj(Front(replace)),SpCrowdDis_Dec(Front(replace)));
end
D=SpCrowdDis;
D = 1./(D+1);

    %% Calculate the fitnesses
Fitness = R + D';
end

function CrowdDis = CrowdingDistance(PopObj,FrontNo)
[N,M] = size(PopObj);
if nargin < 2
    FrontNo = ones(1,N)';
end
CrowdDis = zeros(1,N)';
Fronts   = setdiff(unique(FrontNo),inf)';
for f = 1 : length(Fronts)
    Front = find(FrontNo==Fronts(f));           %索引第几前沿面的所有个体
    Fmax  = max(PopObj(Front,:),[],1);          %所有个体里最大值
    Fmin  = min(PopObj(Front,:),[],1);          %所有个体里最小值
    for i = 1 : M
        if length(Front)==1
            CrowdDis(Front) = 1;
        elseif length(Front)==2
            [~,Rank] = sortrows(PopObj(Front,i));     %每一维都进行排序
            CrowdDis(Front(Rank(1))) = 1;
            CrowdDis(Front(Rank(end))) = 1;
        else
            [~,Rank] = sortrows(PopObj(Front,i));     %每一维都进行排序                                                                                                                                                                                                        Dis(Front(Rank(1)))   = inf;
            CrowdDis(Front(Rank(1))) = 2.*(PopObj(Front(Rank(2)),i)-PopObj(Front(Rank(1)),i))/(Fmax(i)-Fmin(i));
            CrowdDis(Front(Rank(end))) =2.*(PopObj(Front(Rank(end)),i)-PopObj(Front(Rank(end-1)),i))/(Fmax(i)-Fmin(i));
        end
        for j = 2 : length(Front)-1
            if Fmax(i)-Fmin(i)==0
                CrowdDis(Front(Rank(j)))=1;
            else
                CrowdDis(Front(Rank(j))) = CrowdDis(Front(Rank(j)))+(PopObj(Front(Rank(j+1)),i)-PopObj(Front(Rank(j-1)),i))/(Fmax(i)-Fmin(i));
            end
        end
    end
end
end