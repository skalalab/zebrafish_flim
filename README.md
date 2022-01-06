## Contents 

* CellProfiler_macrophage segmenting
* FLIM Python graphing
* FLIM analysis_Fig2 TNF
* Matlab_ASCtoTIFF
* Matlab_flim_analysis_macro_redox
* Matlab_rename_SDT
* Statistical codes
* Source data files

<hr>

## Software for FLIM image analysis
* SPCImage 7.4
* Matlab 2019b
* CellProfiler 3.1.8

<hr>

## I. Analyzing FLIM images

Steps 1-5 describes the workflow to process and obtain lifetime data per macrophage. During image acquistion we keep track of the number of larvae imaged per condition, number of images collected per larvae, and the number of macrophages per field of view (FOV). This information will be useful during data analysis, presentation, and statistical analysis.

### 1. Rename B&H data files to match folder name in Matlab:
When acquiring lifetime images, SPCImage generates a folder with a set of files for every image. Each folder is named according to the user's personal preference, for example FOV1, FOV2 etc. One of those files is a .sdt/B&H data file with a very long name (LifetimeData_cycle….). They have the same name in every folder, so we have to rename them to differentiate them. This code will rename each of these .sdt/B&H data file according to the folder name. Use “rename_SDT” code in Matlab. 

### 2. Fit lifetime images in SPCImage:
* Channel 1 – mCherry, Channel 2 – FAD (and GFP), Channel 3 – NADH
* Apply IRF for Channel 2 and 3.
* Channel 3 - components: 2
* Channel 2 - components: 3, t3 is fixed and change to 3500. We do three components for channel 2 due to the wavelength mixing. There is a possibility of NADH bleedthrough so we set a third component to a value representative of NADH to remove that. Otherwise, the 2 components are to fit the short and long lifetimes of the coenzymes.
* Set shift so that the chi square value 1. 1 is best, but 0.8-1.5 is okay. 
* Set threshold to 10. Select Calculate>Decay matrix (selected channel). Do this in Channel 2 and 3.
* Channel 1 - just go to calculate decay matrix; mCherry does not need to be fit.
* Save file to save settings.
* Perform batch processing – go to Calculate>Batch processing (all channels). Some computers will crash if you select too many files at a time; I do in batches of 20-25 files. Select all the B&H files you want to batch calculate. Fitting will generate .img/SPCImage document files.
* To export fitted files – go to File>Export, select t1, t2, a1%, a2%, chi2, pixel intensities, batch export, and all channels. These will be .asc files.

### 3. Convert ASC files to TIFF in Matlab:
The exported files from SPCImage will be .asc files. They have to be converted to .tiff before they can used in CellProfiler and Matlab in downstream steps. Use "ASCtoTIFF" code in Matlab. Put all asc files to be converted into a folder; the Matlab code will ask for this folder. All tiff files will be deposited into the same folder. After the tiff files were generated, the asc files can be deleted; this is optional.

### 4. Segmenting cells in CellProfiler:
This step will trace macrophages in each image/FOV based on mCherry signal, and will generate a mask that will be used in Step 5 to calculate the lifetimes in macrophage area only.
Use code from "CellProfiler_macrophage segmenting" folder. Use this code for all the data, except the data in Figure 2. For Figure 2, use CellProfiler pipeline from "FLIM analysis_Fig2 TNF" folder; this pipeline will create a mask in the mCherry and GFP channels, which will be used in Matlab to designate each macrophage as GFP negative or positive.

* Go to the folder where all the tiff files are located and select files ending in "...photons.tiff" for every channel (Ch1/mCherry, Ch2/FAD or GFP, Ch3/NADH) for every image set. Drag these files into CellProfiler in the "Images" step. Drag in 5 image sets (15 files) at a time.
* Go to "namesandtypes" step and hit update and then file>save project.
* Go to "SaveImages" step to designate where the files will be saved; this should be the same folder where all the other tiff files are located.
* Start test mode, keep hitting “Step”. This will let you go through each image set one by one and check masking for each image. Sometimes the threshold level needs to be modified; go to "Threshold" step and adjust value in "Manual threshold".  
* Cross-check images in SPCImage. Check lifetime of mCherry signal of every macrophage; lifetime of mCherry will be different if a cell is dead or if it is a non-specific signal. You can delete these spots in Fiji so they are not used by Matlab to calculate lifetimes. 
* CellProfiler will generate a file ending in "...photonsallmacro.tiff" for Ch1 only.

### 5. Calculate lifetimes in Matlab
This step will perform calculations of lifetimes using masks generated in CellProfiler. Use code "flim_analysis_macro_redox" in Matlab. Use this code for all the data, except the data in Figure 2. For Figure 2, use Matlab code from "FLIM analysis_Fig2 TNF" folder.

* The user will have to type in the directory of where all the files are located, for example: filefront = 'C:\Users\Veronika\Desktop\Veronika 102021 stat6\export\fish-'; pay attention to direction of slash signs. "fish-" is just the beginning of all tiff files, but this depends on how the user named the images during acquistion. If the user named each image FOV1, FOV2 etc, then the user will have to input ...export\FOV-'

* The user will have to manually type in the image numbers corresponding with each larva, for example if larva 1 correspond with images 1-12, type in im_num = [1:12];

* The same directory will have to be copy/pasted at the bottom under "save..." and "load...". In addition, the user will also have to define in "save.." and "load..." the name of the file Matlab will generate that will contain all the values per larva. For example, "save('C:\Users\Veronika\Desktop\Veronika 102021 stat6\export\Stat6_larva 1.mat...", same for "load...". Usually our naming scheme includes the condition and larva number.

* This input will generate a Matlab file that contains all the data from images 1-12 for larva 1. To calculate lifetimes for larva 2, change the image range in "im_num = [xx:xx];" and change the name to ...larva 2.mat in "save..." and "load...", and so on for all the larvae. 

* After all the Matlab files were generated for each larvae, the user can open the Matlab file in Matlab and copy/paste the values into an Excel. However, this is time-consuming and tedious; this step can be automated by writingg a code in R to generate an Excel file containing the values from all the Matlab files. 

<hr>

## II. Preparing images for presentation

### 1. Exporting lifetime images from SPCImage:

* In SPCImage, open a fitted SPCImage file (.img). 

**Go to Options>Color**
* Set up range; this is done by looking at what looks good across all the images you want to use; mCherry (ch1) and/or GFP (ch2;FAD) channels will have range of 0-1 so these can’t be modified
* Always use B-G-R (not the default R-G-B)

**Go to file>export**
* in matrix: check a1(%), a2(%), t1, t2, chi, pixel intensities
* in image: check color coded image, intensity image, color legend (separate) and choose TIF for format.
* perform batch export, and export all channels


### 2. Generating redox ratio images:
* After exporting pixel intensities etc as above, it will generate asc files. They need to be converted to TIFF in Matlab using ASCtoTIFF code.
* There should be a file ending in “photons”. Use this file for Ch2 (FAD) and Ch3 (NADH) to open in FIJI. 
* Ch3 may have to be thresholded so everything outside the tail image is set to zero. This is so when you perform image calculations, the area outside the tail remains zero and doesn’t generate signal during calculations. To threshold, go to Image>Adjust>Threshold. The tail area should be covered in red, and outside should stay black or unselected. Hit apply and select set to NaN. The end should be that only the tail area should have signal value, and everywhere where there is no tail, the signal value should be NaN.
* Then go to Process>Image calculator
* The equation for redox ratio is NADH/NADH+FAD, which is Ch3/Ch3+Ch2. Select Ch3 ADD Ch2. This will give a new “results…” file where Ch2 and Ch3 were added. Use this now to DIVIDE Ch3.
* Perform this for all the images you want to place in a figure. Once you have all your redox ratio images, look at the min and max for all the images using Image>Adjust>B&C. Once you compared all the images, set the min and max the same for all the images. Go to Image>Adjust>B&C and the window should have a set button. Click on the set button to manually enter min and max. 
* After this you can apply Fire color to all the images from the look up table. Go to Image>Lookup Tables>Fire. You can also do this from the menu bar by clicking on LUT. 
* Now you need to generate a color legend. Go to Analyze>Tools>Calibration bar. This will generate a color legend but within the image. I was told that you should be able to generate and export the color legend separately, so that it is not part of the image, but I was not able to figure that out. So what I do is generate a copy of the image with the color legend and just crop it in Illustrator. 
* After the redox ratio images were adjusted for min/max and applied the Fire color, they should be set to RGB color; right now they are 32-bit. They will not display in Illustrator as a 32-bit TIF. Go to Image>Type>RGB Color. Save all images as TIF.

<hr>

## III. Graphing lifetime data
To display FLIM data as a composite dot plot and Tukey-adjusted box plot, go to "FLIM Phyton Graphing" folder. Open codes in Jupyter Notebook (Anaconda.navigator). The Excel files containing data values should be in the same folder. Excel files are provided in "Source data files" folder.

<hr>

## IV. Statistics
All FLIM data was analyzed in R; codes provided in "R codes_zebrafish FLIM data" folder in the "Statistical codes" folder. The rest of the data was analyzed in SAS.
