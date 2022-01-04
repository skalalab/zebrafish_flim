## Software
* SPCImage 7.4
* Matlab 2019b
* CellProfiler 3.1.8


<hr>
### Contents 
* CellProfiler_macrophage segmenting - 
* FLIM Python graphing
* FLIM analysis_Fig2 TNF - 
* Matlab_ASCtoTIFF
* Matlab_flim_analysis_macro_redox
* Matlab_rename_SDT
* Statistical codes
* rename_SDT

<hr>
### 1. Rename B&H data files to match fish name:


Each fish has a folder with a set of files. One of those files is a B&H data file with a very long name (LifetimeData_cycle….). They have the same name in all the folders, so we have to rename them for the name of the fish.

Use “rename_SDT” code in Matlab. To use it, open folder in the left side workspace and set path by right clicking in the white space and select path/current folder. Highlight the top lines of code before it says “new section”, right click and hit “run this section” green arrow up in the tool bar. It will then prompt you to select the folder that contains your raw data files. Select main folder, not subfolders.

Note: put the code in its own folder, so that when you open the folder which has the code and set path/current folder, it has only one code in it. Otherwise, I think it will confuse matlab and won’t know which code to run from that folder.

### 2. Fit lifetime images:
Drag in your B&H data file – M1 and 3 channels
Channel 1 – mCherry, Channel 2 – FAD (and GFP), Channel 3 – NADH
Instrument response function: Open file for IRFch2, controlA and controlC to copy paste into spcimage – in spcimage go to irf tab and click on paste from clipboard in channel 2, do the same for channel 3
IRF is measured by taking picture of a urea crystal 
The IRF takes into account how fast our electronics can measure data and adjusts the recorded data according to that. Fitting is fitting a bi-exponential decay line to the histogram of lifetimes that we gather during data acquisition. And then for FAD we do a three component exponential to account for the NADH bleed through.
Channel 3 - components: 2
Channel 2 - components: 3, t3 is fixed and change to 3500 
We do three components for channel 2 due to the wavelength mixing. There is a possibility of NADH bleedthrough so we set a third component to a value representative of NADH to try to remove that. Otherwise, the 2 components are to fit the short and long lifetimes of the coenzymes

**Set shift**

Channel 3 - Pick a median value for shift – drag around the cursor in the image to see how the shift value changes. Pick a median number. Lock shift and enter the value. You may have to go to options/model and change shift variation to 10.0 if you see shift value not changing when moving cursor around. Then drag around to see how the chi square value changes. 1 is best, but 0.8-1.5 is okay. Set threshold to 10. Then select Calculate/decay matrix (selected channel).
The threshold of 10 gets rid of background signal to produce a better fit, but it doesn’t need to be perfect because we get rid of the background manually in cell profiler when we are making masks.
Do the same in channel 2
Channel 1 - just go to calculate decay matrix 
Save file to save settings – keep fish name and just add “settings”
To do batch processing – go to calculate/batch processing (all channels). Some computers will crash if you select too many files at a time; I do in batches of 20-25 files. Select all the B&H files you want to batch calculate.
To export – go to file/export, select t1, t2, a1%, a2%, chi2, pixel intensities, batch export, and all channels

### 3. Convert ASC files to TIFF in Matlab using ASCtoTIFF code:
Right click in white space on the left panel – choose add path/current folder – select folder with Matlab command (ASCtoTIFF) and then hit run. This will ask you to select the folder with your images. Answer NO to higher level directory. Pause button will turn back to green when it’s done.

### 4. Segmenting cells in CellProfiler – trace mCherry macrophages to create masks to calculate lifetimes in macrophages only
After export, you can delete asc files. 
Search in file by “photons.tiff”, click on one and control A to select all, and drag into drop box of cell profiler
Go to namesandtypes and hit update and then file/save project
Start test mode, keep hitting “Step”. This will let you go through each image set one by one and check masking for each image. Cross-check images in SPCImage. Check lifetime of mCherry signal in each cell; lifetime of mCherry will be different if a cell is dead or if it is a non-specific signal. You can delete these spots in Fiji so they are not used by Matlab to calculate lifetimes.
Do 5 files at a time so you can track images/macrophages in SPCImage (use SPCImage file for tracking, that one generated from fitting data)

### 5. Calculate lifetimes in Matlab
Doing calculations of lifetimes using masks generated in CellProfiler
Code: flim_analysis_macro_redox

#### To export lifetime images: 

<hr>
you can use options -> Color to specify the range you want to use. Also, we usually change R-G-B to B-G-R, meaning blue will be short lifetimes and red will be long. For some reason the default is the opposite. Just pay attention to whether or not you have done this if you are using the fact that GFP is blue. if it is changed it'll be red instead.
You can also change which value it is displaying but we usually only use tm which is the default. After it looks good, you go to file -> export and check Color Coded Image with legend. If you don’t like the way their legend looks, you can export one of the color legends and add your own numbers to it (that’s what I usually do). I also usually use the tiff format.


<hr>
### Image presentation for figures
In SPCImage, open a fitted SPCImage. 
**Go to Options>Color:**
* Set up range; this is done by looking at what looks good across all the images you want to use; mCherry (ch1) and/or GFP (ch2;FAD) channels will have range of 0-1 so these can’t be modified
* Always use B-G-R (not the default R-G-B)


**Go to file>export**
* in matrix: check a1(%), a2(%), t1, t2, chi, pixel intensities
* in image: check color coded image, intensity image, color legend (separate) and choose TIF for format.

mCherry and GFP intensity images will be grayscale. If you want to add color, open file in Fiji and go to image>look up table and apply color you want

to add scale bar, use the information from Prairie View software display window when you image. In the image resolution section, the software provides image size, FOV and pixel size. Pixel size will be automatically adjusted if you apply optical zoom during imaging, so just use the values directly to set up scale bar in Fiji. In Fiji, go to Analyze>Set scale and enter the numbers. Then go to Analyze>Tools>Scale bar to apply scale to the image 

generating redox ratio images
1.	after exporting pixel intensities etc as above, it will generate an asc file. This needs to be converted to TIF in Matlab using ASCtoTIFF code.
2.	There should be a file ending in “photons”. Use this file for Ch2 (FAD) and Ch3 (NADH) to open in FIJI. 
3.	Ch3 may have to be thresholded so everything outside the tail image is set to zero. This is so when you perform image calculations, the area outside the tail remains zero and doesn’t generate signal during calculations. To threshold, go to Image>Adjust>Threshold. The tail area should be covered in red, and outside should stay black or unselected. Hit apply and select set to NaN. Sometimes it acts funny and the tail gets blacked out. So then you need to play around. The end should be that only the tail area should have signal value, and everywhere where there is no tail, the signal value should be NaN.
4.	Then go to Process>image calculator
5.	The equation for redox ratio is NADH/NADH+FAD, which is Ch3/Ch3+Ch2. Select Ch3 ADD Ch2. This will give a new “results…” file where Ch2 and Ch3 were added. Use this now to DIVIDE Ch3.
6.	Perform this for all the images you want to place in a figure. Once you have all your redox ratio images, look at the min and max for all the images using Image>Adjust>B&C. Once you compared all the images, set the min and max the same for all the images. Just go to Image>Adjust>B&C and the window should have a set button. Click on the set button to manually enter min and max. 
7.	After this you can apply Fire color to all the images from the look up table. Go to image>Lookup Tables>Fire. You can also do this from the menu bar by clicking on LUT. 
8.	Now you need to generate a color legend. Go to Analyze>Tools>Calibration bar. This will generate a color legend but within the image. I was told that you should be able to generate and export the color legend separately, so that it is not part of the image, but I was not able to figure that out. So what I do is generate a copy of the image with the color legend and just crop it in Illustrator. 
9.	Also, very important, the redox ratio images after they were adjusted for min and max and applied the Fire color, they should be set to RGB color; right now they are 32-bit. They will not display in Illustrator as a 32-bit TIF. Go to Image>Type>RGB Color

