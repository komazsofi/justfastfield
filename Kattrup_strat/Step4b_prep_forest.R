library(rgdal)
library(raster)
library(tidyverse)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_extent_w500mbuffer.shp")
asreference=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_vegetation_density.tif")

forestmap=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/fromIrina/GIS/Skovkort/kattrup_skovkort_polygon.shp",encoding="UTF-8")

# Filter only important tree species based on irina excel file

forestmap_int=forestmap[forestmap@data$ART %in% c("ALÃ˜","ask","bir","BÃ˜G","dgr","eg","el","KRT","LÃ†R","ngr","ngrj",
                                              "ngrp","nob","nobp","pil","pop","rel","rem","rgr","sgr","skf"
                                              ,"thu","VÃ†R","Ã†GR","Ã†R","v�r"),]

shapefile(forestmap_int,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/fromIrina/GIS/Skovkort/kattrup_skovkort_polygon_selected.shp",overwrite=TRUE)

forestmap_int_sel=forestmap_int[(forestmap_int@data$AARGANG!=9999 & forestmap_int@data$AARGANG!=0),]
plot(forestmap_int_sel$ALDER,forestmap_int_sel$AARGANG,col=factor(forestmap_int_sel$ART),pch=16,xlab="ALDER",ylab="AARGANG")

# group into assemblages

# rasterize info

loc_species_r <- raster()

extent(loc_species_r) <- extent(asreference)
res(loc_species_r) <- res(asreference)

forestmap_int_sel$sp_fact=as.factor(forestmap_int_sel$ART)

loc_species_r_c <- rasterize(forestmap_int_sel, loc_species_r,"sp_fact")
crs(loc_species_r_c)=crs(asreference)
loc_age_r_c <- rasterize(forestmap_int_sel, loc_species_r,"ALDER")
crs(loc_age_r_c)=crs(asreference)
loc_establish_r_c <- rasterize(forestmap_int_sel, loc_species_r,"AARGANG")
crs(loc_establish_r_c)=crs(asreference)

# export
writeRaster(loc_species_r_c,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/forest_species_kattrup.tif",overwrite=TRUE)
writeRaster(loc_age_r_c,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/forest_age_kattrup.tif",overwrite=TRUE)
writeRaster(loc_establish_r_c,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/forest_continiuty_kattrup.tif",overwrite=TRUE)
