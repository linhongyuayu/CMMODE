function [ps,pf,cons]=CMMODE(fname,xl,xu,M,N,Max_Gen)
D=size(xl,2);
feval_max=Max_Gen*N;
gen=ceil(feval_max/N);
feval_count=0;
Pop=zeros(N,D);

%% Initialize and Evaluate Population
for i=1:N
    Pop(i,1:D) = xl+(xu-xl).*rand(1,D);
end
for i=1:N
    Pop(i,D+1:D+M+1)=feval(fname,Pop(i,1:D));
    feval_count=feval_count+1;
end
        p=rand;
        P=0.5;
%% Iteration
for g=1:gen
    Fitness=CalFitness(Pop,D,M);    %% Calculate the fitness
    [~,index]=sort(Fitness,'ascend'); %% Sort the fitness and population
    popsort=Pop(index,:);
    sorted_Fitness=Fitness(index,1);
    clear spop;
    
%%  Generate Species
    for i=1:N/10
        popsort_dec=popsort(:,1:2);
        [~, k]=sort(sqrt(sum    (    (ones(size(popsort_dec,1),1)*popsort_dec(1,:)-popsort_dec)   .^2,2)     ));
        spop(i).seed=popsort(1,:);                              %%Select seeds in the Sorted_Population
        spop(i).seed_fitness=sorted_Fitness(1,1);      
        checker=ones(size(popsort,1),1);
        checker(k(1:10),:)=0;                                       %% The nearst K individuals to seeds in the Sorted_Population
        spop(i).pop=popsort(checker==0,:);
        spop(i).Fitness=sorted_Fitness(checker==0,1);   
        popsort=popsort(checker==1,:);                    %% Delete the selected individuals
        sorted_Fitness=sorted_Fitness(checker==1,1);
    end
 
    if g<gen*(0.5)
        %% The First Phase       

        for i=1:size(spop,2)
            for j=1:size(spop(i).pop,1)    
                popold=spop(i).pop(j,:);    
                poprand=spop(i).pop;        %% Randly select an individual in each spop
                popbest=spop(i).seed;       %% Select the best individual in each spop
                popold_dec=popold(:,1:D);
                popbest_dec=popbest(:,1:D);   
                poprand_dec1=poprand(randperm((size(spop(randperm(10,1)).pop,1))  ,1),1:D);
                poprand_dec2=poprand(randperm(size(spop(i).pop,1)  ,1),1:D);
                poprand_dec3=poprand(randperm(size(spop(i).pop,1)  ,1),1:D);
                if rand<P
                    Offspring(j,1:D)=OperatorDE(popold_dec,poprand_dec1,poprand_dec2,poprand_dec3,xl,xu);      %%Current-to-rand
                else
                    Offspring(j,1:D)=OperatorDE(popold_dec,popbest,poprand_dec1,poprand_dec2,xl,xu);                %%Current-to-best
                end
                Offspring(j,D+1:D+M+1)=feval(fname,Offspring(j,1:D));
                feval_count=feval_count+1;
                Offsprings(i).off=Offspring;
            end
            [nPop(i).Population,~,~] = EnvironmentalSelection([Offspring;spop(i).pop],D,M,size(spop(i).pop,1));    
            clear Offspring
        end
        aa=[];
        for jj=1:length(nPop)
            bb=nPop(jj).Population;
            aa=[aa;bb];
        end
        Pop=aa;
        
    else
%% The Second Phase 
        Population=[];
        for i=1:size(spop,2)
            for j=1:size(spop(i).pop,1)
                popold=spop(i).pop(j,:);
                poprand=spop(i).pop;
                popbest=spop(i).seed;
                popold_dec=popold(:,1:D);
                popbest_dec=popbest(:,1:D);
                poprand_dec1=poprand(randperm((size(spop(randperm(10,1)).pop,1))  ,1),1:D);
                poprand_dec2=poprand(randperm(size(spop(i).pop,1)  ,1),1:D);
                poprand_dec3=poprand(randperm(size(spop(i).pop,1)  ,1),1:D);
                if rand<P
                    Offspring(j,1:D)=OperatorDE(popold_dec,poprand_dec1,poprand_dec2,poprand_dec3,xl,xu);
                else
                    Offspring(j,1:D)=OperatorDE(popold_dec,popbest,poprand_dec1,poprand_dec2,xl,xu);
                end
                Offspring(j,D+1:D+M+1)=feval(fname,Offspring(j,1:D));
                feval_count=feval_count+1;
                Offsprings(i).off=Offspring;
            end
            
%%    The union of spops and Offsprings
            Population=[Population;spop(i).pop];
        end
        off=[];
        for o=1:length(Offsprings)
            a=Offsprings(o).off;
            off=[off;a];
        end
        [Pop,~,~] = EnvironmentalSelection([off;Population],D,M,N);
    end
end
ps=Pop(:,1:D);
pf=Pop(:,D+1:D+M);
cons=Pop(:,end);
end

function Offspring=OperatorDE(Parent1,Parent2,Parent3,Parent4,Lower,Upper)
% Parameter setting
D=2;
Parent1=Parent1(:,1:D);
Parent2=Parent2(:,1:D); 
Parent3=Parent3(:,1:D); 
Parent4=Parent4(:,1:D);
[N,D]   = size(Parent1);
Lower = repmat(Lower,N,1);
Upper = repmat(Upper,N,1);
numberF=unidrnd(3);
F_pool=[0.6,0.8,1];
F=F_pool(numberF);

numberCR=unidrnd(3);
CR_pool=[0.1,0.2,1];
CR= CR_pool(numberCR);
proM=1; disM=20;
%% Differental evolution
Site = rand(N,D) < CR;
Offspring       = Parent1;
Offspring(Site) = Offspring(Site) + F*(Parent2(Site)-Parent1(Site))+F*(Parent3(Site)-Parent4(Site));
%% Polynomial mutation
Site  = rand(N,D) < proM/D;
mu    = rand(N,D);
temp  = Site & mu<=0.5;
Offspring       = min(max(Offspring,Lower),Upper);
Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*...
    (1-(Offspring(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1))-1);
temp = Site & mu>0.5;
Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*...
    (1-(Upper(temp)-Offspring(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1)));
end

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