library(sf)
library(raster)
library(tidyverse)
library(rgdal)
library(stars)
library(rSDM)

## import

study_area=st_read("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/Samplet_au_sinks_2021/Samplet_au_sinks_2021/samplede_AU_pkt_2021.shp")

ph3_wdunes_NA=brick("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/ph3_wdunes_one_wNA.tif")
ph3_meadow <- clamp(ph3_wdunes_NA, lower=1, upper=1, useValues=FALSE)

# reproject

study_area_reproj=st_transform(study_area,crs=st_crs(ph3_meadow))
study_area_reproj_sp <- sf:::as_Spatial(study_area_reproj$geom)

#closest point

check.coords <- points2nearestcell(study_area_reproj_sp, ph3_meadow,showmap=FALSE,distance=10000)

# export

raster::shapefile(check.coords,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/movel_points",overwrite=TRUE)

