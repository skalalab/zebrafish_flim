clear all;
initial = zeros(1000,1);
rr_out = initial;
N_tm_out = initial;
N_t1_out = initial;
N_t2_out = initial;
N_a1_out = initial;
N_chi_out = initial;
F_tm_out = initial;
F_t1_out = initial;
F_t2_out = initial;
F_a1_out = initial;
F_chi_out = initial;
Cellnum_out = initial;
Imnum_out = initial;
NI_out = initial;
FI_out = initial;
filefront = 'C:\Users\Veronika\Desktop\Veronika 102021 stat6\export\fish-';
%change these to match your data
im_num = [31:55];
    fim_num = im_num;
for a = 1:length(im_num)
   
    
%     set up the vectors so that they correspond to NADH and FAD at the
%     same index for pairs

    mask_image = (imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch1-_photonsallmacro.tiff')));
    N_photons = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_photons.tiff'));
    F_photons = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch2-_photons.tiff'));
    N_t1 = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_t1.tiff'));
    N_t2 = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_t2.tiff'));
    N_a1 = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_a1[%].tiff'));
    N_a2 = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_a2[%].tiff'));
    N_chi = imread(strcat(filefront,num2str(im_num(a), '%03.f'),'-Ch3-_chi.tiff'));
    F_t1 = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch2-_t1.tiff'));
    F_t2 = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch2-_t2.tiff'));
    F_a1 = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch2-_a1[%].tiff'));
    F_a2 = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch2-_a2[%].tiff'));
    F_chi = imread(strcat(filefront,num2str(fim_num(a),'%03.f'),'-Ch2-_chi.tiff'));
    rr_image = N_photons./(N_photons+(F_photons.*((F_a1+F_a2)./100)));
    N_tm_image = N_t1.*N_a1./100+N_t2.*N_a2./100;
    F_tm_image = F_t1.*F_a1./100+F_t2.*F_a2./100;
    F_a1 = F_a1./(F_a1 + F_a2);
    
    maskmax = zeros(1,(max(max(mask_image))));
    
    rr_cell = maskmax;
    N_tm_cell = maskmax;
    N_t1_cell = maskmax;
    N_t2_cell = maskmax;
    N_a1_cell = maskmax;
    F_tm_cell = maskmax;
    F_t1_cell = maskmax;
    F_t2_cell = maskmax;
    F_a1_cell = maskmax;
    F_chi_cell = maskmax;
    N_chi_cell = maskmax;
    Cellnum_cell = maskmax;
    Imnum_cell = maskmax;
    NI_cell = maskmax;
    FI_cell = maskmax;
    
    
    for i = 1:max(max(mask_image));
        
        [x y] = find(mask_image == i);
        if length(x)>0;
        xleninitial = zeros(1,length(x));
        rr_pix = xleninitial;
        N_tm_pix = xleninitial;
        N_t1_pix = xleninitial;
        N_t2_pix = xleninitial;
        N_a1_pix = xleninitial;
        F_tm_pix = xleninitial;
        F_t1_pix = xleninitial;
        F_t2_pix = xleninitial;
        F_a1_pix = xleninitial;
        F_chi_pix = xleninitial;
        N_chi_pix = xleninitial;
        NI_pix = xleninitial;
        FI_pix = xleninitial;
        
        for j = 1:length(x);
%            if F_tm_image(x(j),y(j)) > 1000;
%            else
            rr_pix(j) = rr_image(x(j),y(j));
            N_tm_pix(j) = N_tm_image(x(j),y(j));
            N_t1_pix(j) = N_t1(x(j),y(j));
            N_t2_pix(j) = N_t2(x(j),y(j));
            N_a1_pix(j) = N_a1(x(j),y(j));
            F_tm_pix(j) = F_tm_image(x(j),y(j));
            F_t1_pix(j) = F_t1(x(j),y(j));
            F_t2_pix(j) = F_t2(x(j),y(j));
            F_a1_pix(j) = F_a1(x(j),y(j));
            N_chi_pix(j) = N_chi(x(j),y(j));
            F_chi_pix(j) = F_chi(x(j),y(j));
            NI_pix(j) = N_photons(x(j),y(j));
            FI_pix(j) = F_photons(x(j),y(j));
%            end
        end
       
                  
        
        rr_cell(i)= mean(rr_pix(rr_pix>0));
        N_tm_cell(i) = mean(N_tm_pix(N_tm_pix>0));
        N_t1_cell(i) = mean(N_t1_pix(N_t1_pix>0));
        N_t2_cell(i) = mean(N_t2_pix(N_t2_pix>0));
        N_a1_cell(i) = mean(N_a1_pix(N_a1_pix>0));
        F_tm_cell(i) = mean(F_tm_pix(F_tm_pix>0));
        F_t1_cell(i) = mean(F_t1_pix(F_t1_pix>0));
        F_t2_cell(i) = mean(F_t2_pix(F_t2_pix>0));
        F_a1_cell(i) = mean(F_a1_pix(F_a1_pix>0));
        Cellnum_cell(i) = i;
        Imnum_cell(i)=im_num(a);
        F_chi_cell(i) = mean(F_chi_pix(F_chi_pix<10));
        N_chi_cell(i) = mean(N_chi_pix(N_chi_pix<10));
        NI_cell(i) = mean(NI_pix(NI_pix>0));
        FI_cell(i) = mean(FI_pix(FI_pix>0));
        
        end
    end
    if a == 1;
        ind1 = length(rr_out(rr_out>0))+1;
    ind2 = length(rr_out(rr_out>0))+length(rr_cell);
    else
        ind1 = max(find(Imnum_out>0))+1;
        ind2 = ind1+length(rr_cell)-1;
    end
    rr_out(ind1:ind2) = rr_cell;
    N_tm_out(ind1:ind2) = N_tm_cell;
    N_t1_out(ind1:ind2) = N_t1_cell;
    N_t2_out(ind1:ind2) = N_t2_cell;
    N_a1_out(ind1:ind2) = N_a1_cell;
    F_tm_out(ind1:ind2) = F_tm_cell;
    F_t1_out(ind1:ind2) = F_t1_cell;
    F_t2_out(ind1:ind2) = F_t2_cell;
    F_a1_out(ind1:ind2) = F_a1_cell;
    F_chi_out(ind1:ind2) = F_chi_cell;
    N_chi_out(ind1:ind2) = N_chi_cell;
    Cellnum_out(ind1:ind2) = Cellnum_cell;
    Imnum_out(ind1:ind2)=Imnum_cell;
    NI_out(ind1:ind2) = NI_cell;
    FI_out(ind1:ind2) = FI_cell;
end
rr_out = rr_out(rr_out>0);
N_tm_out = N_tm_out(N_tm_out>0);
N_t1_out = N_t1_out(N_t1_out>0);
N_t2_out = N_t2_out(N_t2_out>0);
N_a1_out = N_a1_out(N_a1_out>0);
F_tm_out = F_tm_out(F_tm_out>0);
F_t1_out = F_t1_out(F_t1_out>0);
F_t2_out = F_t2_out(F_t2_out>0);
F_a1_out = F_a1_out(F_a1_out>0);
N_chi_out = N_chi_out(N_chi_out>0);
F_chi_out = F_chi_out(F_chi_out>0);
Cellnum_out = Cellnum_out(Cellnum_out>0);
Imnum_out=Imnum_out(Imnum_out>0);
NI_out = NI_out(NI_out>0);
FI_out = FI_out(FI_out>0);


save('C:\Users\Veronika\Desktop\Veronika 102021 stat6\export\Stat6_fish.mat','rr_out','N_tm_out','N_t1_out','N_t2_out','N_a1_out','F_tm_out','F_t1_out','F_t2_out','F_a1_out','N_chi_out','F_chi_out','Cellnum_out','Imnum_out','NI_out','FI_out');
clear all
load('C:\Users\Veronika\Desktop\Veronika 102021 stat6\export\Stat6_fish.mat')
