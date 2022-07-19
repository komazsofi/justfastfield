library(rgdal)
library(raster)
library(tidyverse)
library(rgeos)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_extent_w500mbuffer.shp")
asreference=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_vegetation_density.tif")

roads=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/human_infrastructure/VEJMIDTE.shp")

# crop to area of interest

roads_crop=crop(roads,study_area)
#shapefile(roads_crop,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/human_infrastructure/VEJMIDTE_crop.shp")

# create a raster which measures the distance from the route

distroad_r <- raster()

extent(distroad_r) <- extent(asreference)
res(distroad_r) <- res(asreference) 

distroad_r_wvalue = gDistance(roads_crop, as(distroad_r,"SpatialPoints"), byid=TRUE)

distroad_r[] = apply(distroad_r_wvalue,1,min)
crs(distroad_r)=crs(asreference)

writeRaster(distroad_r,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/human_distfromroad.tif")

