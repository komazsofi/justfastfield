library(rgdal)
library(raster)
library(tidyverse)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/fussingo_forlidar.shp")

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/lidar_topo_10/")

rasterfiles=list.files(pattern = "*.tif$")

layers=stack(rasterfiles)

# extract points

intersected=extract(layers,study_area)

intersected=raster::extract(layers,study_area)
merged=cbind(study_area,intersected)

shapefile(merged,"Fussingo_intersected_wLiDARtopo_10m.shp",overwrite=TRUE)

write.csv(merged,"Fussingo_intersected_wLiDARtopo_10m.csv")