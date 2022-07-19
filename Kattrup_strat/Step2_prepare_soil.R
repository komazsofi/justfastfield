library(rgdal)
library(raster)
library(tidyverse)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_extent_w500mbuffer.shp")
asreference=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_vegetation_density.tif")

# soil moisture

sum_shal=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/for_Zofia/terraennaert_grundvand_10m/Summer_predict_shallow.tif")
sum_deep=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/for_Zofia/terraennaert_grundvand_10m/Summer_predict_deep.tif")
wint_shal=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/for_Zofia/terraennaert_grundvand_10m/Winter_predict_shallow.tif")
wint_deep=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/for_Zofia/terraennaert_grundvand_10m/Winter_predict_deep.tif")

crs(sum_shal)=crs(asreference)
crs(sum_deep)=crs(asreference)
crs(wint_shal)=crs(asreference)
crs(wint_deep)=crs(asreference)

sum_shal_crop=crop(sum_shal,study_area)
sum_deep_crop=crop(sum_deep,study_area)
wint_shal_crop=crop(wint_shal,study_area)
wint_deep_crop=crop(wint_deep,study_area)

# align with lidar - checked automatically ful filled

writeRaster(sum_shal_crop,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/soil_sum_shal.tif")
writeRaster(sum_deep_crop,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/soil_sum_deep.tif")
writeRaster(wint_shal_crop,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/soil_wint_shal.tif")
writeRaster(wint_deep_crop,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/soil_wint_deep.tif")

# soil types

afsand=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/soiltypes_agro/afsandno.tif")
agsand=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/soiltypes_agro/agsandno.tif")
clay=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/soiltypes_agro/aclaynor.tif")
carbon=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/soiltypes_agro/akulstof.tif")

#align with lidar

afsand_crop=crop(afsand,study_area)
afsand_crop_resampl=resample(afsand_crop,asreference)

agsand_crop=crop(agsand,study_area)
agsand_crop_resampl=resample(agsand_crop,asreference)

clay_crop=crop(clay,study_area)
clay_crop_resampl=resample(clay_crop,asreference)

carbon_crop=crop(carbon,study_area)
carbon_crop_resampl=resample(carbon_crop,asreference)

writeRaster(afsand_crop_resampl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/soil_afsand.tif")
writeRaster(agsand_crop_resampl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/soil_agsand.tif")
writeRaster(clay_crop_resampl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/soil_clay.tif")
writeRaster(carbon_crop_resampl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/soil_carbon.tif")