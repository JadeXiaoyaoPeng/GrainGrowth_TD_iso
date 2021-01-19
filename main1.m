clear
clc
load('Ni_An4_simu_out2.mat')

% load('grains920.mat')
% load('ori920')
%% input
%vol=[15590,15690,20957,16378,17117,16132];
no=12;
do=1;
grain_number =size(grains,1);
% dt=0.0005/4;
dt=0.0005/8;
ori = 2*pi*rand(grain_number,1); %orientation generate
id=(1:grain_number)';
evol=cell(no,3);
evol{1,1}=grains;
evol{1,2}=ori;
evol{1,3}=id;
%% iteration
tic
for i=2:no    
    [evol{i,1},evol{i,2},evol{i,3}] = gbm3d(do,dt,grains,dims,ori,id,rmlist);    
    grains=evol{i,1};
    %ori=evol{i,2};
    id=evol{i,3};
end
time=toc;
% ave grain size
% ave_size = zeros(size(evol,1),1);
% for i = 1:size(evol,1)
%     ave_size(i) = (prod(dims)-size(rmlist,1))/size(evol{i,1},1);
% end
%% creat ang
% load('evolCV_S54_t80x1_9.mat')
% clear
% load('Ni_An4_simu_CV.mat', 'dataori','rmlist','dims')
% do = 1;
% i = 6;
for i=2:no    
   out( evol{i,1},dims,evol{i,3},rmlist,dataori, i )    
end

%% check
 for t =1:5
    grains=evol{t,1};
    grainsize=zeros(size(grains,1),1);
    for i = 1:size(grains,1)
        ind = grains{i,1}; % Pixels within a nhd. of grain.
        val = grains{i,2}; % Lev. set. vals. at those pixels. 
        grainsize(i)=size(ind(val>0),1);
    end
    total=sum(grainsize)
%     
 end
 %% grainnum
 grainnum=zeros(1,size(evol,1));
 for i =1 :size(evol,1)
    grainnum(i)=size(evol{i,1},1); 
 end
 %% metric 
 mName = 'metricNi43_NO3.mat';
%   mName = 'metricNi54_CVZ.mat';
%  mName = 'metric.mat';
 evol_met=cell(size(evol,1),4);
 for i = 1:size(evol,1)
      [ evol_met{i,1}, evol_met{i,2}, evol_met{i,3}, evol_met{i,4} ] = metNi( mName,evol{i,1}, evol{i,3} );      
 end 
%% metric 20
 evol_met20=cell(size(evol,1),4);
 for i = 1:size(evol,1)
      [ evol_met20{i,1},evol_met20{i,2},evol_met20{i,3},evol_met20{i,4} ] = metNi20( evol{i,1}, evol{i,3} );      
 end
 %% 30
 evol_met30=cell(size(evol,1),4);
 for i = 1:size(evol,1)
      [ evol_met30{i,1},evol_met30{i,2},evol_met30{i,3},evol_met30{i,4} ] = metNi30( evol{i,1}, evol{i,3} );      
 end
 %% new metric 
 evol_met=cell(size(evol,1),4);
 totmatid=zeros(size(evol,1),1);
 numGleft=zeros(size(evol,1),1);

 for i = 1:size(evol,1)
     [ evol_met{i,1}, evol_met{i,2},evol_met{i,3},evol_met{i,4}] = nmetNi10( evol{i,1}, evol{i,3} );
     totmatid(i)=sum(evol_met{i,4});
     
     
 end