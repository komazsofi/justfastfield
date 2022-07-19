library(rgdal)
library(raster)
library(tidyverse)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_extent_w500mbuffer.shp")
asreference=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_vegetation_density.tif")

# import satellite data

S2_NDVI_p90=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_satellite_datasets/S2_NDVI_p90_utm_2021.tif")
S2_NDWI_p90=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_satellite_datasets/S2_NDWI_p90_utm_2021.tif")

L_NDVI_std_30y=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_satellite_datasets/NDVIstd_timeseries_std_utm_1990_2020.tif")
L_NDVI_med_30y=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_satellite_datasets/NDVIstd_timeseries_med_utm_1990_2020.tif")

# align with raster

S2_NDVI_p90_resampl=resample(S2_NDVI_p90,asreference)
S2_NDWI_p90_resampl=resample(S2_NDWI_p90,asreference)

L_NDVI_std_30y_resampl=resample(L_NDVI_std_30y,asreference)
L_NDVI_med_30y_resampl=resample(L_NDVI_med_30y,asreference)

# export

writeRaster(S2_NDVI_p90_resampl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/satelite_S2_NDVI_p90.tif")
writeRaster(S2_NDWI_p90_resampl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/satelite_S2_NDWI_p90.tif")

writeRaster(L_NDVI_std_30y_resampl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/satelite_L_NDVI_std_30y.tif")
writeRaster(L_NDVI_med_30y_resampl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/satelite_L_NDVI_med_30y.tif")