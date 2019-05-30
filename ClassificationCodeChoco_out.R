wd="/Users/Victor/Documents/MyManuscripts/JesusAnaya/Data"
setwd(wd)

# Open required libraries
library("rgdal")
library("raster")
library("RStoolbox")
library("maptools")
library("caret")

# Import data
calib=readOGR(".", "calibration")
valid=readOGR(".", "validation")
rastdata=stack("L8_PALSAR_SUBSET_WGS84.tif")

# Perform supervised classification
supervised=superClass(rastdata, trainData=calib,
                                          responseCol = "RECLASS1")

# Retrieve variable importance
supervised$model$finalModel$importance

# Validate classification
accumatrix=confusionMatrix(factor(extract(supervised$map, valid)), 
                           factor(valid@data$RECLASS1))

# Retrive accuracy results
accumatrix$table # confusion marix
accumatrix$overall # overall error
accumatrix$byClass # accuracy per classes

# Save classified map and classification object
writeRaster(supervised$map, filename="supervised.tif")

save(supervised, file="supervised.RData")
