library(rgdal)
library(raster)
library(tidyverse)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/fussingo_forlidar.shp")
study_area_buff=buffer(study_area,500)

# LiDAR - Vegetation structure

## Canopy height

Canopy_height_f <- list.files(path = "D:/Zsofia/ecodes-dk-lidar-test-fussingo/data/outputs_15m/canopy_height/", full.names = T, pattern = ".vrt")
Canopy_height <- raster(Canopy_height_f)

Canopy_height_crop <- crop(Canopy_height,extent(study_area_buff))
Canopy_height_crop_t=Canopy_height_crop/100

writeRaster(Canopy_height_crop_t,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/lidar_canopy_height_15.tif",overwrite=TRUE)

## Density (vegetation)

vegetation_density_f <- list.files(path = "D:/Zsofia/ecodes-dk-lidar-test-fussingo/data/outputs_15m/point_count/vegetation_point_count_00m-50m/", full.names = T, pattern = ".vrt")
vegetation_density <- raster(vegetation_density_f)

vegetation_density_crop <- crop(vegetation_density,extent(study_area_buff))

## Density (total)

all_density_f <- list.files(path = "D:/Zsofia/ecodes-dk-lidar-test-fussingo/data/outputs_15m/point_count/total_point_count_-01m-50m/", full.names = T, pattern = ".vrt")
all_density <- raster(all_density_f)

all_density_crop <- crop(all_density,extent(study_area_buff))

# vegetation density

vegetation_density=vegetation_density_crop/all_density_crop

writeRaster(vegetation_density,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/lidar_vegetation_density_15.tif")

## Standard deviation of vegetation height

stdheight_f <- list.files(path = "D:/Zsofia/ecodes-dk-lidar-test-fussingo/data/outputs_15m/normalized_z/normalized_z_sd/", full.names = T, pattern = ".vrt")
stdheight <- raster(stdheight_f)

stdheight_crop <- crop(stdheight,extent(study_area_buff))
stdheight_crop_t=stdheight_crop/100

writeRaster(stdheight_crop_t,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/lidar_vegetation_stdheight_15.tif")

# LiDAR - Topography

## TWI

twi_f <- list.files(path = "D:/Zsofia/ecodes-dk-lidar-test-fussingo/data/outputs_15m/twi/", full.names = T, pattern = ".vrt")
twi <- raster(twi_f)

twi_crop <- crop(twi,extent(study_area_buff))
twi_crop_t=twi_crop/1000

writeRaster(twi_crop_t,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/lidar_topo_twi_15.tif",overwrite=TRUE)

## Slope

slope_f <- list.files(path = "D:/Zsofia/ecodes-dk-lidar-test-fussingo/data/outputs_15m/slope/", full.names = T, pattern = ".vrt")
slope <- raster(slope_f)

slope_crop <- crop(slope,extent(study_area_buff))
slope_crop_t=slope_crop/10

writeRaster(slope_crop_t,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/lidar_topo_slope_15.tif",overwrite=TRUE)

## Solar radiation

solrad_f <- list.files(path = "D:/Zsofia/ecodes-dk-lidar-test-fussingo/data/outputs_15m/solar_radiation/", full.names = T, pattern = ".vrt")
solrad <- raster(solrad_f)

solrad_crop <- crop(solrad,extent(study_area_buff))
solrad_crop_t=solrad_crop/1000

writeRaster(solrad_crop_t,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/lidar_topo_solrad_15.tif",overwrite=TRUE)

