clc;
clear all;

tic;
N=50;
D=512;
w = 1/(2*log(2));
c1 = 0.5 + log(2);
c2 = c1;
sta=2000000;
x=zeros(N,D);
global initial_flag;
initial_flag=0;
% velocity
v = zeros(size(x));

FE_max=1*1e+04;

f = zeros(1,N);
lb=0;
ub=1;


LB=lb;
UB=ub;
  
     for i=1:N
         for j=1:D
      pop(i,j) = lb + (ub-lb)*rand(1);
     
         end;
          val(i) = benchmark_func(pop(i,1:D), N); 
     end;
      FEs = N;
     
    
x=pop;
f=val;
      % calculate fitness



% initialize the personal experience
p_x = x;
p_f = f;


% index of the global best particle
[best_f, g] = min(p_f);

%PSO_run = zeros(1,t_max); %a PSO run
FEs=N; % N initialisations.  *****FEs = 0;
%max_FEs = 0;

count = 1;

% K neighbors for each particle -- based on Clerc description 
% http://clerc.maurice.free.fr/pso/random_topology.pdf
% P. 2 (Method 2)
K = 3;

p=1-power(1-1/N,K); % Probability to be an informant

stop=0;
for aa=1:N
    for bb=1:D
        
chhh(aa,bb)=(pop(aa,bb)+3)/6;
    end;
end;
ii=1;
while stop<1
    % In the C version, random permutation is applied here. This is
    % currently not implemented in this code.

        if count > 0  % No improvement in the best solution. So randomize topology
            
      %      L = eye(N,N); % Matlab function, but does not exist in FreeMat
            L=zeros(N,N);
            for s=1:1:N
                L(s,s)=1;
            end

            for s = 1:1:N % Each particle (column) informs at most K other at random   
                for r=1:1:N
                if (r~=s)
                if (alea(0,1)<p)
                    L(s,r) = 1;
                end
                end
                end
            end
            
        end % if
  
   
    for i = 1:1:N  % For each particle (line) ..
         
        %  ...find the best informant g
				MIN = Inf;  
        for s=1:1:N
            if (L(s,i) == 1)
                if p_f(s) < MIN
                    MIN = p_f(s);
                    g_best = s;
                end
            end
        end

		% define a point p' on x-p, beyond p
        p_x_p = x(i,:) + c1*(p_x(i,:) - x(i,:));
        % ... define a point g' on x-g, beyond g
        p_x_l = x(i,:) + c2*(p_x(g_best,:) - x(i,:));
        
        if (g_best == i) % If the best informant is the particle itself, define the gravity center G as the middle of x-p' 
            G = 0.5*(x(i,:) + p_x_p);
        else % Usual  way to define G
            sw = 1/3;
            G = sw*(x(i,:) + p_x_p + p_x_l);
        end


        rad = norm(G - x(i,:)); % radius = Euclidean norm of x-G       
        x_p = alea_sphere(D,rad)+ G; % Generate a random point in the hyper-sphere around G (uniform distribution)       
for k=1:D
    chhh(i,k)=4*(chhh(i,k))*(1-chhh(i,k));
    v(i,k) = (w*v(i,k) + x_p (k)- x(i,k)); % Update the velocity = w*v(t) + (G-x(t)) + random_vector 
end;																				% The result is v(t+1)
       
                                                                                    
    pops(i,:) = x(i,:) + v(i,:); % Apply the new velocity to the current position. The result is x(t+1)
x(i,:)=pops(i,:);

%Check for constraint violations
for j = 1:1:D
   
        xMin(j)=LB;
        xMax(j)=UB; 
   
       
        
    
    if x(i,j) > xMax(j)
        x(i,j) = xMax(j);
        v(i,j) = -0.5*v(i,j); % variant: 0
    end
    
    if x(i,j) < xMin(j)
        x(i,j) = xMin(j);
        v(i,j) = -0.5*v(i,j); % variant: 0
    end   
end %j
 
   
          f(i) = benchmark_func(x(i,1:D), N); 
          FEs = FEs + 1;
    

        
        if (FEs>=FE_max) % Too many FE
            break; 
        end     
    end %i
   
    % Update personal best
    
    for i=1:1:N
        if f(i) <= p_f(i)
            p_x(i,:) = x(i,:);
            p_f(i) = f(i);
        end %if
    end %i
    
    % Update global best
    [b_f, g] = min(p_f);
    
    if b_f < best_f
        best_f = b_f;
        count = 0;  
    else
        count = count + 1; % If no improvement, the topology will be initialised for the next iteration
    end
    
       
    if  (FEs>=FE_max)
      stop=1;  
    end
    b_f
    FEs
   
    
end %t
 best_x = p_x(g,:);
  T=view_f(pop(g,:));
      save('best.txt','T','-ASCII');
      A=check_perf(pop(g,:));
     t=toc;
   
   





