function [ minval ] = benchmark_func( pop ,NP)
%%%%%%%%%%%%divide data set into 3 parts and normalize all values in the
%%%%%%%%%%%%range [0,10]. the three parts are train_data, train_test and
%%%%%%%%%%%%validation. The first 2 are required here. last one will be
%%%%%%%%%%%%used after lade ends.
%%%%%%%%%%%%if there are x parameters then first x dimensions are used for
%%%%%%%%%%%%masking and next x dimensions will be used for scaling.

%[train_data,train_test,y_train_data,y_train_test]=div(pop);
load('al.mat', 'C3train', 'C4train','C3test','C4test','ytrain', 'ytest');

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

C4tr=C4train;
C3tr=C3train;
C4te=C4test;
C3te=C3test;

train_data=horzcat(C3tr,C4tr);
train_test=horzcat(C3te,C4te);
y_train_data=ytrain;
y_train_test=ytest;

x=256;
s=size(pop);

if (s(1)==NP)
for i=1:NP
    j=1;
for k=1:s(2)/2
if (pop(i,k)>0.5)
    f_train(:,j)=pop(i,k+x)*train_data(:,k);
    f_test(:,j)=pop(i,k+x)*train_test(:,k);
    j=j+1;
end;
end;

%%%%%svmtrain and classify using f_train and f_test and store it in
svmstruct=svmtrain(f_train,y_train_data,'Method','LS');
class=svmclassify(svmstruct,f_test);
%Fit(1,j)=sum(class==y_train_test)/size(y_train_test,1);
%%%%%result(i)
[C order]=confusionmat(class,y_train_test);
sn=C(2,2)/(C(2,2)+C(2,1));
sp=C(1,1)/(C(1,1)+C(1,2));
R=abs(sp-sn)/(sp+sn);
result(i)=R;
minval(i)=result(i);
end;
else
 j=1;
for k=1:s(2)/2
if (pop(1,k)>0.5)
   f_train(:,j)=pop(1,k+x)*train_data(:,k);
    f_test(:,j)=pop(1,k+x)*train_test(:,k);
    j=j+1;
end;
end;
%%%%%svmtrain and classify using f_train and f_test and store it in result
svmstruct=svmtrain(f_train,y_train_data,'Method','LS');
class=svmclassify(svmstruct,f_test);
%Fit(1,j)=sum(class==y_train_test)/size(y_train_test,1);
%%%%%result(i)
[C order]=confusionmat(class,y_train_test);
sn=C(2,2)/(C(2,2)+C(2,1));
sp=C(1,1)/(C(1,1)+C(1,2));
R=abs(sp-sn)/(sp+sn);
result(1)=R;
minval(1)=result(1);
end

