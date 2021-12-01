folder_name = uigetdir
sub_folders = genpath(folder_name);
[C, matches] = strsplit(sub_folders,';');
sdt_file = 'LifetimeData_Cycle00001_000001.sdt';
for i = 2:length(C);
    B = dir(char(C(i)));
    for j = 1:length(B);
        if length(B(j).name)==34 & B(j).name == sdt_file;
            
            D = strsplit(char(C(i)),'\');
            movefile(strcat(char(C(i)),'\',sdt_file),strcat(folder_name,'\',char(D(length(D))),'.sdt')),
        end
    end
end
%% new section

NADH = '219-Ch2-';
NADH_new = '001_n_';
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a1[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a2[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'chi.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'photons.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t1.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t2.tiff'));


FAD = '220-Ch1-';
FAD_new = '001_f_';
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a1[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a2[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'chi.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'photons.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t1.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t2.tiff'));

NADH = '223-Ch2-';
NADH_new = '002_n_';
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a1[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a2[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'chi.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'photons.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t1.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t2.tiff'));


FAD = '224-Ch1-';
FAD_new = '002_f_';
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a1[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a2[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'chi.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'photons.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t1.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t2.tiff'));

NADH = '225-Ch2-';
NADH_new = '003_n_';
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a1[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a2[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'chi.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'photons.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t1.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t2.tiff'));


FAD = '227-Ch1-';
FAD_new = '003_f_';
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a1[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a2[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'chi.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'photons.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t1.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t2.tiff'));

NADH = '231-Ch2-';
NADH_new = '004_n_';
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a1[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a2[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'chi.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'photons.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t1.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t2.tiff'));


FAD = '232-Ch1-';
FAD_new = '004_f_';
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a1[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a2[%].tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'chi.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'photons.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t1.tiff'));
movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t2.tiff'));
% % 
% NADH = '017-Ch2-';
% NADH_new = '005_n_';
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a1[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a2[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'chi.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'photons.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t1.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t2.tiff'));
% 
% % 
% FAD = '018-Ch1-';
% FAD_new = '005_f_';
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a1[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a2[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'chi.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'photons.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t1.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t2.tiff'));
% 
% NADH = '022-Ch2-';
% NADH_new = '006_n_';
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a1[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a2[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'chi.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'photons.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t1.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t2.tiff'));
% 
% 
% FAD = '023-Ch1-';
% FAD_new = '006_f_';
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a1[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a2[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'chi.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'photons.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t1.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t2.tiff'));

% NADH = '064';
% NADH_new = '007_n_';
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a1[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a2[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'chi.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'photons.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t1.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t2.tiff'));
% 
% 
% FAD = '067';
% FAD_new = '007_f_';
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a1[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a2[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'chi.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'photons.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t1.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t2.tiff'));

% NADH = '130';
% NADH_new = '008_n_';
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a1[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'a2[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'chi.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'photons.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t1.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',NADH,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',NADH_new,'t2.tiff'));
% 
% 
% FAD = '129';
% FAD_new = '008_f_';
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a1[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a1[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_a2[%].tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'a2[%].tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_chi.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'chi.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_photons.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'photons.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t1.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t1.tiff'));
% movefile(strcat('E:\020718\Dish 17\Tcells-',FAD,'_t2.tiff'),strcat('E:\020718\Dish 17\Tcells-',FAD_new,'t2.tiff'));

