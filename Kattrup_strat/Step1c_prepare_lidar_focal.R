library(raster)
library(snow)

workingdirectory="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/"
setwd(workingdirectory)

height=raster("lidar_canopy_height.tif")
vegdens=raster("lidar_vegetation_density.tif")

# horizontal metrics

#height_class=reclassify(height, c(c(-Inf,1,1,1,3,2,3,5,3,5,Inf,4)))
#height_class=reclassify(height, c(c(-Inf,1,1,1,3,2,3,5,3,5,10,4,10,15,5,15,Inf,6)))
height_class=reclassify(height, c(c(-Inf,3,1,3,5,2,5,10,3,10,Inf,4)))

beginCluster(20)

sd_dsm=clusterR(height, focal, args=list(w=matrix(1,9,9), fun=sd, pad=TRUE,na.rm = TRUE))
sd_dens=clusterR(vegdens, focal, args=list(w=matrix(1,9,9), fun=sd, pad=TRUE,na.rm = TRUE))

endCluster()

# export

writeRaster(sd_dsm,"lidar_vegetation_sddsm.tif",overwrite=TRUE)
writeRaster(sd_dens,"lidar_vegetation_sddens.tif",overwrite=TRUE)
writeRaster(height_class,"lidar_vegetation_heightclass_v3.tif",overwrite=TRUE)