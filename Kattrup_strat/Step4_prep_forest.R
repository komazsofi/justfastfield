library(rgdal)
library(raster)
library(tidyverse)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_extent_w500mbuffer.shp")
asreference=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_vegetation_density.tif")

forestqual_pred=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/forest_quality_ranger_biowide_cog_epsg3857_v0.9.1_utm.tif")
#forestqual_pred_utm=projectRaster(forestqual_pred,crs = crs(study_area))
#writeRaster(forestqual_pred_utm,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/forest_quality_ranger_biowide_cog_epsg3857_v0.9.1_utm.tif")

skov_100year=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/fromIrina/GIS/Skovlitraer min. 100 år/gl_skov.shp")
loc_oldtrees=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/fromIrina/GIS/Træer til henfald/træer_til_henfald_samlet.shp")

forest_type_con=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/for_Zofia/treetype/treetype_bjer_con.tif")
forest_type_dec=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/for_Zofia/treetype/treetype_bjer_dec.tif")

forest_disturb=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/disturbance_since_2015_cog_epsg3857_v0.1.0.tif")
#forest_disturb_utm=projectRaster(forest_disturb,crs = crs(study_area))
#writeRaster(forest_disturb_utm,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/disturbance_since_2015_cog_epsg3857_v0.1.0_utm.tif")

# prep combined forest quality map :

forestqual_pred_crop <- crop(forestqual_pred,study_area)
forestqual_pred_crop_resampl=resample(forestqual_pred_crop,asreference,method='ngb')
forestqual_pred_crop_resampl=as.integer(forestqual_pred_crop_resampl)
writeRaster(forestqual_pred_crop_resampl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/forestqual_pred_crop_resampl.tif",overwrite=TRUE)

## rasterizing shapefiles

skov_100year_r <- raster()

extent(skov_100year_r) <- extent(asreference)
res(skov_100year_r) <- res(asreference) 

skov_100year@data$oldforest<-1
skov_100year_r_c <- rasterize(skov_100year, skov_100year_r,"oldforest")

loc_oldtrees_r <- raster()

extent(loc_oldtrees_r) <- extent(asreference)
res(loc_oldtrees_r) <- res(asreference) 

loc_oldtrees@data$oldforest<-1
loc_oldtrees_r_c <- rasterize(loc_oldtrees, loc_oldtrees_r,"oldforest")

## combining layers

oldforest_combined <- overlay(skov_100year_r_c, loc_oldtrees_r_c, fun=function(x, y) ifelse(is.na(x) & y==1, 1, x)) 
crs(oldforest_combined)=crs(asreference)

forestqual_combined <- overlay(forestqual_pred_crop_resampl, oldforest_combined, fun=function(x, y) ifelse(x==1 & y==1, 3, x))
forestqual_combined[is.na(forestqual_combined[])] <- 1
writeRaster(forestqual_combined,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/forest_qualcomb.tif",overwrite=TRUE)

## tree type map

forest_type_con_crop <- crop(forest_type_con,study_area)
forest_type_dec_crop <- crop(forest_type_dec,study_area)

#combine two layers to : 1-decidious, 2-conifer
forest_type_crop <- overlay(forest_type_dec_crop, forest_type_con_crop, fun=function(x, y) ifelse(x==0 & y==1, 2, x)) 
forest_type_crop_resamp=resample(forest_type_crop,asreference,method='ngb')
writeRaster(forest_type_crop_resamp,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/forest_treetype.tif",overwrite=TRUE)
