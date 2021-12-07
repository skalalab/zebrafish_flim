clear all;
initial = zeros(1000,1);
N_tm_out = initial;
N_t1_out = initial;
N_t2_out = initial;
N_a1_out = initial;
N_chi_out = initial;

mC_t1_out = initial;
mC_a1_out = initial;
mC_chi_out = initial;

GFP_t1_out = initial;
GFP_a1_out = initial;
GFP_chi_out = initial;

Cellpix_out = initial;
Cytopix_out = initial;
Cellnum_out = initial;
NInuc_out = initial;
Ntmnuc_out = initial;
Imnum_out = initial;
D_out = initial;



filefront = 'C:\Users\ktweed\Desktop\091918_fish_macrophages\fish-';
%change this to match location of your data

for a = 42
   
    im_num = [1:50];
    fim_num = [1:50];
%     make these the same and correspond to the numbers on each image file

    mC_mask_image = im2uint8(imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch1-_photonsAllMacro.tiff')));
    %for some reason this mask is originally uint16, this changes it to
    %uint8
    GFP_mask_image = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch2-_photonsGFPposmask.tiff'));
    
    N_photons = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_photons.tiff'));
    N_t1 = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_t1.tiff'));
    N_t2 = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_t2.tiff'));
    N_a1 = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_a1[%].tiff'));
    N_a2 = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_a2[%].tiff'));
    N_chi = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_chi.tiff'));
    N_tm_image = N_t1.*N_a1./100+N_t2.*N_a2./100;
    mC_t1 = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch1-_t1.tiff'));
    mC_a1 = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch1-_a1[%].tiff'));
    mC_chi = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch1-_chi.tiff'));
    
    GFP_t1 = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch2-_t1.tiff'));
    GFP_a1 = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch2-_a1[%].tiff'));
    GFP_chi = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch2-_chi.tiff'));
    
    %reads all of the images
   
    
    mask_image = zeros(size(mC_mask_image));
    GFP_index_mask = GFP_mask_image ~= 0;
    mC_index_mask = mC_mask_image ~= 0;
    mC_double = im2double(mC_mask_image);
    for i = 1:length(mC_mask_image);
        for j = 1:length(mC_mask_image);
         if mC_index_mask(i,j) == GFP_index_mask(i,j)& mC_index_mask(i,j)~=0
                mask_image(i,j) = mC_double(i,j);
%                 mask_image(i,j) = 1;
% use this line of code instead if you want your mask to be just 0 and 1,
% not distinct cell labeling, 
         else
                mask_image(i,j) = 0;
         end
        end
    end
   
%    averagemask = movmean(mask_image, 3, 2);
%    GFP_label = im2double(mask_image.*averagemask>0.34);
   GFP_label = im2uint8(mask_image);
   mask_image = im2uint8(mask_image);
   
   %makes mask of where both masks agree, if you want to keep each cell as having a different value, you need to
   %convert the image you are taking those values from to a double before you
   %can perform the for loop replacement, then you need to convert it to
   %uint8
    
    maskmax = zeros(1,(max(max(mC_mask_image))));
    
    N_tm_cell = maskmax;
    N_t1_cell = maskmax;
    N_t2_cell = maskmax;
    N_a1_cell = maskmax;
    N_chi_cell = maskmax;
    
    mC_t1_cell = maskmax;
    mC_a1_cell = maskmax;
    mC_chi_cell = maskmax;
    
    GFP_t1_cell = maskmax;
    GFP_a1_cell = maskmax;
    GFP_chi_cell = maskmax;
    
    
    Cellpix_cell = maskmax;
    Cytopix_cell = maskmax;
    Cellnum_cell = maskmax;
    Imnum_cell = maskmax;
    D_cell = maskmax;
    NInuc_cell = maskmax;
    Ntmnuc_cell = maskmax;
%     initialize all variables
    
    for i = 1:max(max(mC_mask_image));
      
        [x y] = find(mC_mask_image == i);
        if length(x)>0;
        xleninitial = zeros(1,length(x));
        N_tm_pix = xleninitial;
        N_t1_pix = xleninitial;
        N_t2_pix = xleninitial;
        N_a1_pix = xleninitial;
        N_chi_pix = xleninitial;
        
        mC_t1_pix = xleninitial;
        mC_a1_pix = xleninitial;
        mC_chi_pix = xleninitial;
        
        GFP_t1_pix = xleninitial;
        GFP_a1_pix = xleninitial;
        GFP_chi_pix = xleninitial;
        
        %creates space for each cell by finding what indices correspond to
        %the intensity specified in the for loop, checks many more than
        %exist but will catch all between 1 and the max intensity
        
        for j = 1:length(x);
            
            N_tm_pix(j) = N_tm_image(x(j),y(j));
            N_t1_pix(j) = N_t1(x(j),y(j));
            N_t2_pix(j) = N_t2(x(j),y(j));
            N_a1_pix(j) = N_a1(x(j),y(j));
            N_chi_pix(j) = N_chi(x(j),y(j));
            
            mC_t1_pix(j) = mC_t1(x(j),y(j));
            mC_a1_pix(j) = mC_a1(x(j),y(j));
            mC_chi_pix(j) = mC_chi(x(j),y(j));
            
            GFP_t1_pix(j) = GFP_t1(x(j),y(j));
            GFP_a1_pix(j) = GFP_a1(x(j),y(j));
            GFP_chi_pix(j) = GFP_chi(x(j),y(j));
            
            %replaces the zeros with the values from the images at the cell
            %indices
            
            

        end
        
%         
        N_tm_cell(i) = mean(N_tm_pix(N_tm_pix>0));
        N_t1_cell(i) = mean(N_t1_pix(N_t1_pix>0));
        N_t2_cell(i) = mean(N_t2_pix(N_t2_pix>0));
        N_a1_cell(i) = mean(N_a1_pix(N_a1_pix>0));
        
        mC_t1_cell(i) = mean(mC_t1_pix(mC_t1_pix>0));
        mC_a1_cell(i) = mean(mC_a1_pix(mC_a1_pix>0));
        
        GFP_t1_cell(i) = mean(GFP_t1_pix(GFP_t1_pix>0));
        GFP_a1_cell(i) = mean(GFP_a1_pix(GFP_a1_pix>0));
        
        [cell_x cell_y] = find(mC_mask_image==i);
        Cellpix_cell(i) = length(cell_x);
        Cytopix_cell(i) = length(x);
        Cellnum_cell(i) = i;
        Imnum_cell(i)=a;
        D_cell(i) = pi*(mean([(max(x)-min(x)), (max(y)-min(y))]))^2;
        mC_chi_cell(i) = mean(mC_chi_pix(mC_chi_pix<10));
        GFP_chi_cell(i) = mean(GFP_chi_pix(GFP_chi_pix<10));
        N_chi_cell(i) = mean(N_chi_pix(N_chi_pix<10));
%         NInuc_cell(i) = mean(NInuc_pix(NInuc_pix>0));
%         Ntmnuc_cell(i) = mean(Ntmnuc_pix(Ntmnuc_pix>0));
%         end
        end
    end
        ind1 = length(Cellnum_cell(Cellnum_cell>0))+1;
        ind2 = length(Cellnum_out(Cellnum_out>0))+length(Cellnum_cell);
        
        %this will make it so you can only run one set at a time 
end


    ind = 1:length(N_tm_cell > 0);
    N_tm_out(ind) = N_tm_cell;
    N_t1_out(ind) = N_t1_cell;
    N_t2_out(ind) = N_t2_cell;
    N_a1_out(ind) = N_a1_cell;
    N_chi_out(ind) = N_chi_cell;
    
    mC_t1_out(ind) = mC_t1_cell;
    mC_a1_out(ind) = mC_a1_cell;
    mC_chi_out(ind) = mC_chi_cell;
    
    GFP_t1_out(ind) = GFP_t1_cell;
    GFP_a1_out(ind) = GFP_a1_cell;
    GFP_chi_out(ind) = GFP_chi_cell;
   Cellpix_out(ind) = Cellpix_cell;
   Cytopix_out(ind) = Cytopix_cell;
   Cellnum_out(ind) = Cellnum_cell;
   Imnum_out(ind)=Imnum_cell;
       D_out(ind) = D_cell;
%         NInuc_out(ind) = NInuc_cell;
%         Ntmnuc_out(ind) = Ntmnuc_cell;
%         

N_tm_out = N_tm_out(N_tm_out>0);
N_t1_out = N_t1_out(N_t1_out>0);
N_t2_out = N_t2_out(N_t2_out>0);
N_a1_out = N_a1_out(N_a1_out>0);
N_chi_out = N_chi_out(N_chi_out>0);

mC_t1_out = mC_t1_out(mC_t1_out>0);
mC_a1_out = mC_a1_out(mC_a1_out>0);
mC_chi_out = mC_chi_out(mC_chi_out>0);

GFP_t1_out = GFP_t1_out(GFP_t1_out>0);
GFP_a1_out = GFP_a1_out(GFP_a1_out>0);
GFP_chi_out = GFP_chi_out(GFP_chi_out>0);
Cellpix_out = Cellpix_out(Cellpix_out>0);
Cytopix_out = Cytopix_out(Cytopix_out>0);
Cellnum_out = Cellnum_out(Cellnum_out>0);
Imnum_out=Imnum_out(Imnum_out>0);
D_out = D_out(D_out>0);
% NInuc_out= NInuc_out(NInuc_out>0);
% Ntmnuc_out= Ntmnuc_out(Ntmnuc_out>0);
GFP_label_out = zeros(length(Cellnum_out),1);
for i = 1:length(Cellnum_out);
    index = Cellnum_out(i);
    [x1, y1] = find(GFP_label == index);
    if length(x1) > 5 & length(y1) > 5;
        GFP_label_out(i) = 1;
    else
        GFP_label_out(i) = 0;
    end
end
        
save('C:\Users\ktweed\Desktop\091918_fish_macrophages\FLIM_out_NotInfected_fish5_4.mat','N_tm_out','N_t1_out','N_t2_out','N_a1_out','N_chi_out','Cellpix_out','Cellnum_out','Imnum_out','GFP_label_out');
clear all;
load('C:\Users\ktweed\Desktop\091918_fish_macrophages\FLIM_out_NotInfected_fish5_4.mat')
