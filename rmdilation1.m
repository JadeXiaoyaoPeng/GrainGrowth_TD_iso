function [ ind3 ] = rmdilation1(ind2,rmlist )
   ls=ismember(ind2,rmlist);
   ind3=ind2(ls==0);        
end

