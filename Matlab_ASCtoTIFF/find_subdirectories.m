function [dirlist, topdir] = find_subdirectories(startdir) 

topdir = uigetdir(startdir,...
    'Select the highest level data directory containing only data associated with the specified calibration images');

clc
disp('Finding folders...')

currentdir = topdir;

dirlist(1).path = currentdir;
dirlist(1).dir = [];


outercount = 0;
innercount = 1;

while outercount ~= innercount
 
outercount = outercount + 1;

    if outercount == 1
        cd(currentdir)
    else
        cd(strcat(dirlist(outercount).path, '\', dirlist(outercount).dir));
        currentdir = pwd;
    end

    d = dir;
    for n = 1:size(d,1)
        if d(n).isdir == 1 && ~(strcmp(d(n).name,'.') || strcmp(d(n).name,'..'))
            innercount = innercount + 1;
            directory = d(n).name;
            dirlist(innercount).path = currentdir;
            dirlist(innercount).dir = directory;
        end
    end

end
clc