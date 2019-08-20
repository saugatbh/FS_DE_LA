function [ f_index ] = view_f( pop )

%%%call this func from lade and input pop(gbest,:).
j=1;
for k=1:256
if (pop(k)>0.5)
    f_index(j)=k;
    j=j+1;
end;
end;

end

