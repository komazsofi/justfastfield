library(raster)
library(rgeos)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/")

rasterfiles=list.files(pattern = "*.tif$")
kattruparea=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_graense_jan2022.shp")

# stack rasters

layers=stack(rasterfiles)

plot(layers[[1:12]])
plot(layers[[13:24]])

# only kattrup area

layers_crop=crop(layers,kattruparea)
layers_crop_mask <- mask(layers_crop, kattruparea)

plot(layers_crop_mask[[1:12]])
plot(layers_crop_mask[[13:24]])

# PCA

