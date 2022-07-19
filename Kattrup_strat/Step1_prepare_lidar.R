library(rgdal)
library(raster)
library(tidyverse)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_extent_w500mbuffer.shp")

# LiDAR - Vegetation structure

## Canopy height

Canopy_height_f <- list.files(path = "O:/Nat_Ecoinformatics-tmp/au634851/EcoDes-DK15_v1.1.0/outputs/canopy_height/", full.names = T, pattern = ".vrt")
Canopy_height <- raster(Canopy_height_f)

Canopy_height_crop <- crop(Canopy_height,study_area)
Canopy_height_crop_t=Canopy_height_crop/100

writeRaster(Canopy_height_crop_t,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_canopy_height.tif",overwrite=TRUE)

## Vegetation density

vegetation_density_f <- list.files(path = "O:/Nat_Ecoinformatics-tmp/au634851/EcoDes-DK15_v1.1.0/outputs/vegetation_density/", full.names = T, pattern = ".vrt")
vegetation_density <- raster(vegetation_density_f)

vegetation_density_crop <- crop(vegetation_density,study_area)
vegetation_density_crop_t=vegetation_density_crop/10000

writeRaster(vegetation_density_crop_t,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_vegetation_density.tif")

# LiDAR - Topography

## TWI

twi_f <- list.files(path = "O:/Nat_Ecoinformatics-tmp/au634851/EcoDes-DK15_v1.1.0/outputs/twi/", full.names = T, pattern = ".vrt")
twi <- raster(twi_f)

twi_crop <- crop(twi,study_area)
twi_crop_t=twi_crop/1000

writeRaster(twi_crop_t,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_topo_twi.tif",overwrite=TRUE)

## Slope

slope_f <- list.files(path = "O:/Nat_Ecoinformatics-tmp/au634851/EcoDes-DK15_v1.1.0/outputs/slope/", full.names = T, pattern = ".vrt")
slope <- raster(slope_f)

slope_crop <- crop(slope,study_area)
slope_crop_t=slope_crop/10

writeRaster(slope_crop_t,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_topo_slope.tif",overwrite=TRUE)

## Solar radiation

solrad_f <- list.files(path = "O:/Nat_Ecoinformatics-tmp/au634851/EcoDes-DK15_v1.1.0/outputs/solar_radiation/", full.names = T, pattern = ".vrt")
solrad <- raster(solrad_f)

solrad_crop <- crop(solrad,study_area)
solrad_crop_t=solrad_crop/1000

writeRaster(solrad_crop_t,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_topo_solrad.tif",overwrite=TRUE)

