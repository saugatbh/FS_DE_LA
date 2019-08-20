function [ A ] = check_perf( pop )
%%%call this func from lade and input pop(gbest,:). merge train_data and
%%%train_test into a single group say trainn...take corr class as
%%%train_class...take rem data as validd...and corr class as valid_class

load('al.mat', 'C3train', 'C4train','C3test','C4test','ytrain', 'ytest');

T=load('best.txt');

N1=size(C3train);
N2=size(C3test);

SC3=sum(vertcat(C3train,C3test));
SC4=sum(vertcat(C4train,C4test));

for i=1:N1(2)
C4tr(:,i)=C4train(:,i)/SC4(:,i);
C3tr(:,i)=C3train(:,i)/SC3(:,i);
C4te(:,i)=C4test(:,i)/SC4(:,i);
C3te(:,i)=C3test(:,i)/SC3(:,i);
end

%C4tr=C4train;
%C3tr=C3train;
%C4te=C4test;
%C3te=C3test;

Xtrain=horzcat(C3tr,C4tr);
Xtest=horzcat(C3te,C4te);

for i=1:length(T)
trainn(:,i)=Xtrain(:,T(:,i));
validd(:,i)=Xtest(:,T(:,i));
 end

train_class=ytrain;
valid_class=ytest;

x=256;

 j=1;
for k=1:length(T)
if (pop(k)>0.5)
    f_train(:,j)=pop(k+x)*trainn(:,k);
    f_valid(:,j)=pop(k+x)*validd(:,k);
    j=j+1;
end;
end;
%%%svmtrain using f_train and classify using f_valid
svmstructf=svmtrain(f_train,train_class,'Method','LS');
fclass=svmclassify(svmstructf,f_valid);
A=sum(fclass==valid_class)/size(valid_class,1);
end

