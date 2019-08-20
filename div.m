
function[X_train,X_test,y_train,y_test]=div(pop)

load('aa.mat', 'C3train','C4train', 'ytrain');

N=size(C3train);

SC3=sum(C3train);
SC4=sum(C4train);

for i=1:N(2)
C4tr(:,i)=C4train(:,i)/SC4(:,i);
C3tr(:,i)=C3train(:,i)/SC3(:,i);
end

%C4tr=C4train;
%C3tr=C3train;
Xtrain=horzcat(C3tr,C4tr);

indices=crossvalind('Kfold',ytrain,5);
for i=1:5
    test=(indices==i);train=~test;
    O=NaiveBayes.fit(Xtrain(train,:),ytrain(train,1));
    class=O.predict(Xtrain(test,:));
 E(i)=sum(class==ytrain(test,:))/size(ytrain(test,:),1);
end
[M I]=max(E);
Te=(indices==I);Tr=~Te;
X_train=Xtrain(Tr,:);
X_test=Xtrain(Te,:);
y_train=ytrain(Tr,:);
y_test=ytrain(Te,:);

%for i=1:20
%[train(:,i),test(:,i)]=crossvalind('Holdout',ytrain,0.4);
%Train=(train(:,i)==1);Test=~Train;
%train_data=xt(Train,:);
%test_data=xt(Test,:);
%y_test_data=ytrain(Test,:);
%y_train_data=ytrain(Train,:);
%svmstruct=svmtrain(train_data,y_train_data);
%class=svmclassify(svmstruct,test_data);
%A(i)=sum(class==y_test_data)/size(y_test_data,1);
%end
%[M I]=max(A);
%Tr=(train(:,I)==1);Te=~Tr;
%X_train=xt(Tr,:);
%X_test=xt(Te,:);
%y_train=ytrain(Tr,:);
%y_test=ytrain(Te,:);
end