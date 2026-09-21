function [Pop,FrontNo,SpCrowdDis] = EnvironmentalSelection(Pop,D,M,N)
[FrontNo,MaxFNo] = NDSort(Pop,D,M,N);
Next = FrontNo < MaxFNo;
PopDec=Pop(:,1:2);
PopObj=Pop(:,3:4);

%% Calculate the crowding distance of each solution
SpCrowdDis_Obj = CrowdingDistance(PopObj,FrontNo);
SpCrowdDis_Dec = CrowdingDistance(PopDec,FrontNo);
SpCrowdDis = max(SpCrowdDis_Obj,SpCrowdDis_Dec);

for i = 1 : MaxFNo
    Front   = find(FrontNo==i);
    Avg_Obj = mean(SpCrowdDis_Obj(Front));
    Avg_Dec = mean(SpCrowdDis_Dec(Front));
    replace = SpCrowdDis_Obj(Front)<=Avg_Obj & SpCrowdDis_Dec(Front)<=Avg_Dec;
    SpCrowdDis(Front(replace)) = min(SpCrowdDis_Obj(Front(replace)),SpCrowdDis_Dec(Front(replace)));
end

%% Select the solutions in the last front based on their crowding distances
Last     = find(FrontNo==MaxFNo);
[~,Rank] = sort(SpCrowdDis(Last),'descend');
Next(Last(Rank(1:N-sum(Next)))) = true;

%% Population for next generation
Pop = Pop(Next,:);
FrontNo    = FrontNo(Next)';
SpCrowdDis = SpCrowdDis(Next);
end

function CrowdDis = CrowdingDistance(PopObj,FrontNo)
[N,M] = size(PopObj);
if nargin < 2
    FrontNo = ones(1,N)';
end
CrowdDis = zeros(1,N)';
Fronts   = setdiff(unique(FrontNo),inf)';
for f = 1 : length(Fronts)
    Front = find(FrontNo==Fronts(f));
    Fmax  = max(PopObj(Front,:),[],1);
    Fmin  = min(PopObj(Front,:),[],1);
    for i = 1 : M
        if length(Front)==1
            CrowdDis(Front) = 1;
        elseif length(Front)==2
            [~,Rank] = sortrows(PopObj(Front,i));
            CrowdDis(Front(Rank(1))) = 1;
            CrowdDis(Front(Rank(end))) = 1;
        else
            [~,Rank] = sortrows(PopObj(Front,i));                                                                                                                                                                                                           Dis(Front(Rank(1)))   = inf;
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