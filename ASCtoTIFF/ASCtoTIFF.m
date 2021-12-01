86%% .ASC to .TIFF Converter
% Skala Lab - 2016 
% This script takes .asc files generated by SPCImage and converts them to
% 32-bit .tiff files. 

% Instructions: Select the highest level folder containing files generated
% from SPCImage. This folder can contain subfolders. 

% Note: Windows and many applications such as Powerpoint do not render
% 32-bit images properly, so you'll still need to use ImageJ to make
% images for displayi in presentations and publications. 

% Required additional .m files:
% find_subdirectories.m
% saveastiff.m
% (https://www.mathworks.com/matlabcentral/fileexchange/35684-save-and-load-a-multiframe-tiff-image)
% loadtiff.m
% (https://www.mathworks.com/matlabcentral/fileexchange/35684-save-and-load-a-multiframe-tiff-image)

clear all
close all
clc

start_dir = pwd;
homedir = pwd;
buttonval = 'Yes';
startind = 1;
while strcmp(buttonval,'Yes')
    
    [tdirlist, ttopdir] = find_subdirectories(start_dir);
    if strcmp(ttopdir(end),'\')
        ttopdir = ttopdir(1:end-1);
    end

    for n = startind:startind+length(tdirlist)-1
        dirlist(n).topdir = ttopdir;
        dirlist(n).dir = tdirlist(n-startind+1).dir;
        dirlist(n).path = tdirlist(n-startind+1).path;
    end   
        
    startind = startind + length(tdirlist);
    
    buttonval = questdlg('Add another top level directory?', ...
        'Input Selection...','Yes', 'No', 'No');

end


for i = 1:length(dirlist)
    filesaves = [];
    currentpath = (strcat(dirlist(i).path,'\',dirlist(i).dir));
    if ~strcmp(currentpath(end),'\')
        currentpath = strcat(currentpath,'\');
    end
    cd(currentpath)
    filelist = dir('*.asc'); % Looks for all .asc files
    tic
    for j = 1:length(filelist)
        fileload = strcat(currentpath,filelist(j).name);
        savename_tiff = strcat(currentpath, filelist(j).name(1:end-4),'.tiff'); 
        % savename_jpg = strcat(currentpath, filelist(j).name(1:end-4),'.jpg'); 

        cd(dirlist(i).topdir)

        if exist(savename_tiff)
            continue
        end


        if ~strcmp(fileload(end),'\')
           image = load(fileload,'-ascii');
        end
        % You can add additional output file formats here.  
        saveastiff(single(image),savename_tiff);
        % imwrite(image,savename_jpg);
    end    
end   
