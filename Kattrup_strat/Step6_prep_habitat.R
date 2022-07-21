library(rgdal)
library(raster)
library(tidyverse)
library(rgeos)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_extent_w500mbuffer.shp")
asreference=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_vegetation_density.tif")

ph3_habitats=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Rast_p3_klit_Croped.tif")
natura2000=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Rast_Natura2000_Croped.tif")

natura2000_habitats=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kortlægning_naturtyper_flader.shp")

# crop to area of interest

ph3_habitats_crop=crop(ph3_habitats,study_area)
natura2000_crop=crop(natura2000,study_area)

# prep natura-2000 habitats

natura2000_habitats_crop=crop(natura2000_habitats,study_area)
shapefile(natura2000_habitats_crop,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kortlægning_naturtyper_flader_crop.shp")

natura2000_habitats_r <- raster()

extent(natura2000_habitats_r) <- extent(asreference)
res(natura2000_habitats_r) <- res(asreference) 

## rasterize natura-2000 habitats

natura2000_habitats_crop@data$Naturtype=as.factor(natura2000_habitats_crop@data$Naturtype)
natura2000_habitats_r_c_all <- rasterize(natura2000_habitats_crop, natura2000_habitats_r,"Naturtype")

crs(natura2000_habitats_r_c_all)<-crs(asreference)

## reclassify natura-2000 raster (wet-dry habitats)

natura2000_habitats_reclass_wetdry=reclassify(natura2000_habitats_r_c_all,c(-Inf,1,NA,1,2,0,2,3,1,3,5,0,5,6,2,6,10,1,10,12,4,12,14,3,14,Inf,NA))

# reclassify ph3 raster (area,wet-dry habitats)

ph3_habitats_crop_reclass=reclassify(ph3_habitats_crop,c(-Inf,7,1,7,Inf,NA))
ph3_habitats_crop_reclass_wetdry=reclassify(ph3_habitats_crop,c(-Inf,-1,NA,-1,3,1,3,4,2,4,6,0,6,Inf,NA))

# combine §3 and natura-2000 aggregated habitat map

aggregated_habitat_map=natura2000_habitats_reclass_wetdry

aggregated_habitat_map[is.na(aggregated_habitat_map)] <- ph3_habitats_crop_reclass_wetdry

aggregated_habitat_map <- overlay(natura2000_habitats_reclass_wetdry, ph3_habitats_crop_reclass_wetdry, fun=function(x, y) ifelse(is.na(x) & !is.na(y), y, x)) 
crs(aggregated_habitat_map)=crs(asreference)

# export

writeRaster(ph3_habitats_crop,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/habitat_ph3_klit.tif")
writeRaster(natura2000_crop,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/habitat_natura2000area.tif")
writeRaster(ph3_habitats_crop_reclass,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/habitat_ph3area.tif",overwrite=TRUE)

writeRaster(natura2000_habitats_r_c_all,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/habitat_natura2000habitats.tif",overwrite=TRUE)
writeRaster(aggregated_habitat_map,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/habitat_aggregated_wetrdyopenclose.tif",overwrite=TRUE)