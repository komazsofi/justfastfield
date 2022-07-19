library(rgdal)
library(raster)
library(tidyverse)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_extent_w500mbuffer.shp")

forestqual_pred=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/forest_quality_ranger_biowide_cog_epsg3857_v0.9.1.tif")
forestqual_pred_utm=projectRaster(forestqual_pred,crs = crs(study_area))

# crop layers to the study area

forestqual_pred_crop <- crop(forestqual_pred,study_area)