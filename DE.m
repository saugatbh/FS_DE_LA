clear all;
tic;
%func_num=7;%change accordingly
global initial_flag; % the global flag used in test suite
 initial_flag = 0; % should set the flag to 0 for each run, each function
a=0.01;%learning rate
b=0.01;
run=1;
cr=0.9;
D = 512; % dimensionality of benchmark functions
NP = 50; % population size
Max_FEs = 1e+04; % maximal number of FEs, should be set to 3e+06
f=0.5;
r=zeros(NP,D);
automata=zeros(NP,20);
state=zeros(1,NP);
x1=0;
x2=0;
v=zeros(NP,D);%%%%donor vector%%%%
X=0;
I=0;
u=zeros(NP,D);%%%%trial vector%%%%
resp=zeros(1,NP);
graph=zeros(1,301);
count=2;

 % set the lower and upper bound for each function
lb=0;
ub=1;
  
     
      pop = lb+ (ub-lb)*rand(NP, D);
      val = benchmark_func(pop,NP); % fitness evaluation
      FEs = NP;
      sortval=val;
      sortval=sort(sortval);
      for i=1:NP
          for j=1:NP
          if (sortval(i)==val(j))
             state(j)=i;
             if (i==1)
             gbest=j;
             end;
          end;
          end;
      end;
      automata=0.05*ones(NP,20); 
     
      graph(run,1)=min(val);
      while ((FEs <= Max_FEs-NP))
      for i=1:NP
          %%roulette wheel selection%%%
          expectation=sort(automata(state(i),1:20),'descend');
          F1=selectionroulette(expectation',1)/10;
          F=F1;
           
          
          %%%%mutation%%%%
          while (x1==x2||x2==x3||x3==x1||x1==i||x2==i||x3==i||x3==x4||x4==x1||x4==x2||x4==i)
       x1=round(NP*rand(1));
       x2=round(NP*rand(1));
       x3=round(NP*rand(1));
       x4=round(NP*rand(1));
       if (x1==0) 
           x1=1; 
       end;
       if (x2==0) 
           x2=1; 
       end;
       if (x3==0) 
           x3=1; 
       end;
       if (x4==0) 
           x4=1; 
       end;
       end;
         for dim=1:D
           v(i,dim)=pop(i,dim)+f*(pop(x1,dim)-pop(x2,dim))+f*(pop(gbest,dim)-pop(i,dim));
         end;
 %%%%recombination%%%%
        I=round(D*rand(1));
        for dim=1:D
           X=rand(1);
           if ((X<=cr)||(dim==I))
               u(i,dim)=v(i,dim);
       
           else
               u(i,dim)=pop(i,dim);
           end;
            if (u(i,dim)>ub)
                    u(i,dim)=ub;
           end;
                if (u(i,dim)<lb)
                    u(i,dim)=lb;
                end;
           
        end;
       newval=benchmark_func(u(i,1:D),NP);
       if (newval<=val(i))
           pop(i,1:D)=u(i,1:D);
           automata(state(i),1:20)=automata(state(i),1:20)*(1-a);
           automata(state(i),F1*10)=automata(state(i),F1*10)/(1-a)+a*(1-automata(state(i),F1*10)/(1-a));
           
           val(i)=newval;
       else       
           old=automata(state(i),F1*10);
           automata(state(i),1:20)=b/19+(1-b)*automata(state(i),1:20);
           automata(state(i),F1*10)=(1-b)*old;
           
       end;
       
       
       
      end;
      FEs = FEs + NP
      sortval=val;
      sortval=sort(sortval);
      for i=1:NP
          for j=1:NP
          if (sortval(i)==val(j))
             state(j)=i;
             if (i==1)
             gbest=j;
             end;
          end;
          end;
      end;
      disp(val(gbest));
      
      
      end; 
      T=view_f(pop(gbest,:));
      save('best.txt','T','-ASCII');
      A=check_perf(pop(gbest,:));
     t=toc;
   
   
