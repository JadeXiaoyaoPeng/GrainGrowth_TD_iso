%  load('Ni_An3_simu_out2.mat', 'rmlist', 'dims')
 i=3; % iteration step

grains=evol{i,1};
id=evol{i,3};

grain0=cell(1,3);
grain0{1,1}=rmlist;
grain0{1,2}=ones(size(rmlist,1),1);
grain0{1,3}=zeros(size(rmlist,1),1);
grains=[grain0;grains];
id=[0;id];

P = -ones(dims);
N = size(grains,1); % Number of grains.
for k=1:N % Loop over grains.
    ind = grains{k,1}; % Pixels within a nhd. of grain.
    val = grains{k,2}; % Lev. set. vals. at those pixels.
    posind = ind(val>0); % Pixels in the interior of grain.
    P(posind) = id(k);        
end

dataid=zeros([1,dims],'int32');
dataid(1,:,:,:)=P;

h5write('/Users/jadepeng/Documents/GrainGrowData/recon/Ni/Unshifted_Ni_merged/An4_out2_simuAn5_t8i3.dream3d',...
    '/DataContainers/ImageDataContainer/CellData/ParentIds',dataid);


% h5write('/Users/jadepeng/Documents/GrainGrowData/recon/Iron/Fe_simuAn1_i3.dream3d',...
%     '/DataContainers/ImageDataContainer/CellData/FeatureIds',dataid);

