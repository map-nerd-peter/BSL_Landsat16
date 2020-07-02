Bare Soil Line (16 Bit) Function for R
========================================

* This is a Bare Soil Line function (BSL_16) that is used to calculate bare soil lines from 16 bit satellite images.  This function is based on the landsat/BSL.R code (https://github.com/cran/landsat/blob/master/R/BSL.R) written by S. Goslee.  The original landsat/BSL.R package only calculates 8 bit values from Landsat images. I have reworked the code so that it can process 16 bit satellite image values (e.g. Landsat 8, RapidEye, etc.). The 16 bit image values have a range between 0 and 65534. 

*__These are the Steps to Run the Program:__*

* Download a Landsat 8 .tif format image from a [Landsat image downloader](https://earthexplorer.usgs.gov/)

* Choose the area the Landsat area that you want to analyze. The image size should not exceed 5 megabytes in size.

* Edit line 75 in the BSL_Landsat16.R script so that it points to the Landsat image that you want to run, and then run it in your R program (e.g. R Studio).

About the Bare Soil Line:
--------------------------

The bare soil line is a linear relationship between bare soil reflectances observed in two different wavelengths.  An example is the relationship between Near Infrared and Red wavelengths which can be used to show the boundary between the soil and vegetation pixels.  The vegetation pixels will be above the soil line. The bare soil line can also [estimate soil properties from remotely sensed images](https://naldc.nal.usda.gov/download/9394/PDF)

![Sample Bare Soil Line Image](example_plots/BSL_sample_image.png "Click to see enlarged plot image")
