Bare Soil Line (16 Bit) Function for R
========================================

This is a Bare Soil Line function (BSL_16) that is used to calculate bare soil lines from 16 bit satellite images.  This function is based on the landsat/BSL.R code (https://github.com/cran/landsat/blob/master/R/BSL.R) written by Sarah Goslee.  The original landsat/BSL.R package only calculates 8 bit values from Landsat images. I have reworked the code so that it can process 16 bit satellite image values (e.g. Landsat 8, RapidEye, etc.). The 16 bit image values have a range between 0 and 65534. 

Example of calling this function in R Studio:
sat <- brick("C:\\github_example\\Landsat8.tif")
#Landsat band 4 is red and Landsat band 5 is near infrared(nir)
red <- as(sat[[4]], 'SpatialGridDataFrame')
nir <- as(sat[[5]], 'SpatialGridDataFrame')
result.bsl <- BSL_16(red, nir, method = "quantile", ulimit = 0.995, llimit = 0.005)
#Prints the intercept and slope values for the bare soil line
result.bsl$BSL
#Prints the summary statistics for the bare soil line 
result.bsl$summary
