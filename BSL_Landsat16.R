library("raster")
library("lmodel2")

BSL_16 <-
  function(band3, band4, method = "quantile", ulimit = .99, llimit = .005)
  {
    # find Bare Soil Line and vegetation peak
    
    if(is.character(band3)) {
      band3 <- read.asciigrid(band3)
      band3 <- band3@data[,1]
    } else {
      if(class(band3) == "SpatialGridDataFrame") {
        band3 <- band3@data[,1]
      } else {
        band3 <- as.vector(as.matrix(band3))
      }
    } 
    
    if(is.character(band4)) {
      band4 <- read.asciigrid(band4)
      band4 <- band4@data[,1]
    } else {
      if(class(band4) == "SpatialGridDataFrame") {
        band4 <- band4@data[,1]
      } else {
        band4 <- as.vector(as.matrix(band4))
      }
    } 
    
    
    # find joint minimum and maximum
    bsl.joint <- cbind(band3, band4)
    bsl.joint <- bsl.joint[apply(bsl.joint, 1, function(x)!any(is.na(x))), ]
    bsl.joint <- bsl.joint[apply(bsl.joint, 1, function(x)all(x < 65535)), ]
    
    ratio43 <- bsl.joint[,2]/bsl.joint[,1]
    
    if(method == "quantile") {
      bsl.lmodel2 <- lmodel2(bsl.joint[ratio43 < quantile(ratio43, llimit), 2] ~ bsl.joint[ratio43 < quantile(ratio43, llimit), 1])
    }
    else if(method == "minimum") {
      # want lowest band4 value for each band3 value (lowest NIR for each red)
      bsl.min <- factor(bsl.joint[,1], levels=1:65534)
      bsl.min <- split(bsl.joint[,2], bsl.min, drop=TRUE)
      bsl.min <- lapply(bsl.min, min)
      
      bsl.lmodel2 <- lmodel2(as.numeric(bsl.min) ~ as.numeric(names(bsl.min)))
    }
    else {
      stop("Method not found.\n")
    }
    
    bsl.lm <- unlist(bsl.lmodel2$regression.results[2, 2:3])
    names(bsl.lm) <- c("Intercept", "Slope")
    
    ### next, find top vegetation point
    
    bsl.test <- bsl.joint
    bsl.test[,2] <- 65535 - bsl.test[,2] # want high values of band 4
    bsl.test <- apply(bsl.test, 1, sum)
    
    # want high veg cover
    bsl.top <- bsl.joint[ratio43 > quantile(ratio43, ulimit, na.rm=TRUE), ]
    bsl.test <- bsl.test[ratio43 > quantile(ratio43, ulimit, na.rm=TRUE)]
    bsl.top <- bsl.top[bsl.test == min(bsl.test), ]
    bsl.summary<-bsl.lmodel2
    if(!is.null(dim(bsl.top))) bsl.top <- bsl.top[sample(1:nrow(bsl.top), 1),]
    
    list(BSL=bsl.lm, top=bsl.top, summary=bsl.summary)
  }


#Set your Landsat image and location in line 75...
sat <- brick("C:\\temp\\landsat8_image.tif")

#Landsat band 3 DN is red and Landsat band 4 DN is near infrared (nir)
red <- as(sat[[3]], 'SpatialGridDataFrame')
nir <- as(sat[[4]], 'SpatialGridDataFrame')
result.bsl <- BSL_16(red, nir, method = "quantile", ulimit = 0.99, llimit = 0.01)

#Prints the intercept and slope values for the bare soil line
result.bsl$BSL

#Prints the summary statistics for the bare soil line
result.bsl$summary

#Plot the bare soil line and vegetation pixels, and the top pixels.
plot(as.vector(as.matrix(red)), as.vector(as.matrix(nir)))
abline(result.bsl$BSL, col="red")
points(result.bsl$top[1], result.bsl$top[2], col="green", cex=2, pch=16)
