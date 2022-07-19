library(rgdal)
library(raster)
library(tidyverse)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_extent_w500mbuffer.shp")
asreference=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_vegetation_density.tif")

forestqual_pred=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/forest_quality_ranger_biowide_cog_epsg3857_v0.9.1_utm.tif")
#forestqual_pred_utm=projectRaster(forestqual_pred,crs = crs(study_area))
#writeRaster(forestqual_pred_utm,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/forest_quality_ranger_biowide_cog_epsg3857_v0.9.1_utm.tif")

forest_type_con=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/for_Zofia/treetype/treetype_bjer_con.tif")
forest_type_dec=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/for_Zofia/treetype/treetype_bjer_dec.tif")

forest_disturb=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/disturbance_since_2015_cog_epsg3857_v0.1.0.tif")
#forest_disturb_utm=projectRaster(forest_disturb,crs = crs(study_area))
#writeRaster(forest_disturb_utm,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/disturbance_since_2015_cog_epsg3857_v0.1.0_utm.tif")

# crop layers to the study area

forestqual_pred_crop <- crop(forestqual_pred_utm,study_area)


## tree type map

forest_type_con_crop <- crop(forest_type_con,study_area)
forest_type_dec_crop <- crop(forest_type_dec,study_area)

#combine two layers to : 1-decidious, 2-conifer
forest_type_crop <- overlay(forest_type_dec_crop, forest_type_con_crop, fun=function(x, y) ifelse(x==0 & y==1, 2, x)) 
forest_type_crop_resamp=resample(forest_type_crop,asreference)
writeRaster(forest_type_crop_resamp,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/forest_treetype.tif",overwrite=TRUE)
