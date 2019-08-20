
load('aa.mat', 'C3train', 'C4train','C3test','C4test','ytrain', 'ytest');
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

trainn=horzcat(C3tr,C4tr);
validd=horzcat(C3te,C4te);

 for i=1:length(T)
Xtrain(:,i)=trainn(:,T(:,i));
Xtest(:,i)=validd(:,T(:,i));
 end

svmstruct=svmtrain(Xtrain,ytrain,'Method','LS');
class=svmclassify(svmstruct,Xtest);
A=sum(class==ytest)/size(ytest,1);