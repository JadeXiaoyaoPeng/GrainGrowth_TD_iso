clear
clc
%% read dream3D data
%Iron data--------------------------------------
% dataid= h5read('/Users/jadepeng/Documents/GrainGrowData/recon/Iron/Fe_An0.dream3d',...
%     '/DataContainers/ImageDataContainer/CellData/FeatureIds');
% dataori= h5read('/Users/jadepeng/Documents/GrainGrowData/recon/Iron/Fe_An0.dream3d',...
%     '/DataContainers/ImageDataContainer/CellFeatureData/AvgEulerAngles');

%Ni data-----------------------------------------
% dataid= h5read('/Users/jadepeng/Documents/GrainGrowData/recon/Ni/Unshifted_Ni_merged/An5_out2.dream3d',...
%     '/DataContainers/ImageDataContainer/CellData/ParentIds');
dataid= h5read('/Users/jadepeng/Documents/GrainGrowData/recon/Ni/Unshifted_Ni_merged/An0_out2.dream3d',...
    '/DataContainers/ImageDataContainer/CellData/FeatureIds');

dataori= h5read('/Users/jadepeng/Documents/GrainGrowData/recon/Ni/Unshifted_Ni_merged/An5_out2.dream3d',...
    '/DataContainers/ImageDataContainer/MergedTwinsFeatureData/AvgEulersAngles');
%------------------------------------------------
dataori=dataori';
% dataea = h5read('/Users/jadepeng/Documents/GrainGrowData/recon/Ni/An0_CV2.dream3d',...
%     '/DataContainers/ImageDataContainer/CellData/EulerAngles');
%% create
createMet = 0; 
N=size(dataori,1)-1;
id=(1:N)';
dims=[size(dataid,2),size(dataid,3),size(dataid,4)];
if createMet == 1
    % create fstate for metric.dat    
    grains = cell(N,1);
    rmlist=find(dataid == 0);
    for i=1:N
        ind=find(dataid == id(i));
        grains{i}=ind;
    end
    fstate = grains;
%     inistate = grains;
else
    % create grains for simu input
    grains = cell(N,3);
    rmlist=find(dataid == 0);
    for i=1:N
        ind=find(dataid == id(i));
        grains{i,1}=ind;
        grains{i,2}=ones(size(grains{i,1},1),1);
        grains{i,3}=zeros(size(grains{i,1},1),1);
    end
    % dilation for input
    tic
    label = -1e10 * ones(dims);
    W = int32(-ones(dims));
    L = int32(zeros(120000000,1));
    for k=1:N % Loop over the grains.
        
        ind = grains{k,1};
        [x,y,z] = ind2sub(dims,ind);
        [x2,y2,z2] = dilation_fixedbd(int32(x),int32(y),int32(z),3,W,L);
        ind2 = sub2ind(dims,x2,y2,z2);
        ind3 = rmdilation1(ind2,rmlist );
        label(ind3) = -1;
        label(ind) = 1;
        grains{k,1} = ind3;
        grains{k,2} = label(ind3);
        grains{k,3} = 0*ind3;       % Convolution vals. init to 0.
        
    end % (for k). Loop over grains ends.
    t1=toc;
    display(t1)
end
%% Exp metric
mName = 'metricNi43_CV.mat'; %load metric
s = load('metricNi32_CV.mat','fstate'); %loading inistate
inistate = s.fstate;
clear s %loading inistate
[ manum, matvol,tot_final_vol,tot_ini_vol ] = metNiEx(mName, inistate );
%% naive metric
load('metricNi10_CV.mat')
load('Ni_An0_noDilation_CV.mat')
idmap=idmap10;
manum=zeros(size(idmap,1),3);
for i = 1:size(idmap,1)
    a=ismember( fstateAn1{idmap(i,1),1}, inistate{idmap(i,2),1});
    manum(i,1)=sum(a);
    manum(i,2)=size(fstateAn1{idmap(i,1),1},1);
    manum(i,3)=size(inistate{idmap(i,2),1},1);   
end
totalvol=sum(manum(:,1));