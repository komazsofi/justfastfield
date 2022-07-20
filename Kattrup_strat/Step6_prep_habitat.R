library(rgdal)
library(raster)
library(tidyverse)
library(rgeos)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_extent_w500mbuffer.shp")
asreference=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_vegetation_density.tif")

ph3_habitats=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Rast_p3_klit_Croped.tif")
natura2000=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Rast_Natura2000_Croped.tif")

# crop to area of interest

ph3_habitats_crop=crop(ph3_habitats,study_area)
natura2000_crop=crop(natura2000,study_area)

# make p3 protected area raster

ph3_habitats_crop_reclass=reclassify(ph3_habitats_crop,c(-Inf,7,1,7,Inf,NA))

# export

writeRaster(ph3_habitats_crop,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/habitat_ph3_klit.tif")
writeRaster(natura2000_crop,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/habitat_natura2000area.tif")
writeRaster(ph3_habitats_crop_reclass,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/habitat_ph3area.tif")