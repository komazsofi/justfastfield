library(rgdal)
library(raster)
library(tidyverse)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_extent_w500mbuffer.shp")
asreference=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_vegetation_density.tif")

# import satellite data

S2_NDVI_p90=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_satellite_datasets/S2_NDVI_p90_utm_2021.tif")
S2_NDWI_p90=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_satellite_datasets/S2_NDWI_p90_utm_2021.tif")

# align with raster

S2_NDVI_p90_resampl=resample(S2_NDVI_p90,asreference)
S2_NDWI_p90_resampl=resample(S2_NDWI_p90,asreference)

# export

writeRaster(S2_NDVI_p90_resampl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/satelite_S2_NDVI_p90.tif")
writeRaster(S2_NDWI_p90_resampl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/satelite_S2_NDWI_p90.tif")