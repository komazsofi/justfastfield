library(sf)
library(raster)
library(tidyverse)
library(GeoStratR)


# import

study_area=st_read("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/GIS/GIS/Kattrup_Vildnis_graense_jan2022.shp")

Shapes <- list(study_area) %>% purrr::map(~st_buffer(.x,dist = 100)) %>% 
  purrr::map(st_union) %>% 
  purrr::map(st_as_sf)

## TWI

start_time <- Sys.time()

Wetness_lidar_files <- list.files(path = "O:/Nat_Ecoinformatics-tmp/au634851/EcoDes-DK15_v1.1.0/outputs/twi/", full.names = T, pattern = ".vrt")
Wetness_lidar_files <- raster(Wetness_lidar_files)

end_time <- Sys.time()

print(end_time - start_time)

Twis <- Shapes %>% 
  purrr::map(~crop(Wetness_lidar_files, .x)) %>% 
  purrr::map2(Shapes,~mask(.x, .y))

## Canopy height

Canopy_Cover <- list.files(path = "O:/Nat_Ecoinformatics-tmp/au634851/EcoDes-DK15_v1.1.0/outputs/canopy_height/", full.names = T, pattern = ".vrt")
Canopy_Cover <- raster(Canopy_Cover)


Canopy_Heights <- Shapes %>% 
  purrr::map(~crop(Canopy_Cover, .x)) %>% 
  purrr::map2(Shapes,~mask(.x, .y))

## Vegetation density

Vegetation_dens <- list.files(path = "O:/Nat_Ecoinformatics-tmp/au634851/EcoDes-DK15_v1.1.0/outputs/vegetation_density/", full.names = T, pattern = ".vrt")
Vegetation_dens <- raster(Vegetation_dens)

VegDens <- Shapes %>% 
  purrr::map(~crop(Vegetation_dens, .x)) %>% 
  purrr::map2(Shapes,~mask(.x, .y))

## Slope

slope <- list.files(path = "O:/Nat_Ecoinformatics-tmp/au634851/EcoDes-DK15_v1.1.0/outputs/slope/", full.names = T, pattern = ".vrt")
slope <- raster(slope)

Slope <- Shapes %>% 
  purrr::map(~crop(slope, .x)) %>% 
  purrr::map2(Shapes,~mask(.x, .y))

## Solar Radiation


Solar <- list.files(path = "O:/Nat_Ecoinformatics-tmp/au634851/EcoDes-DK15_v1.1.0/outputs/solar_radiation/", full.names = T, pattern = ".vrt")
Solar <- raster(Solar)

Solar_Rad <- Shapes %>% 
  purrr::map(~crop(Solar, .x)) %>% 
  purrr::map2(Shapes,~mask(.x, .y))

# Stack together export

Kattrup <- stack(Twis[[1]], Canopy_Heights[[1]], VegDens[[1]], Slope[[1]], Solar_Rad[[1]]) %>% readAll()
saveRDS(Kattrup, "O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/Kattrup.rds")

# Make stratification

stratified <- Stratify(Kattrup,LowGroup = 2, HighGroup = 2)

FinalRaster <- stratified$FinalStack

## MinDist is the minimum distance in meters,
## N is the number of samples to get per strata and n_to_test, is the number of inicial
## Random points to get n.

Points <- Random_Stratified_Min_Dist(ClassRaster = FinalRaster,
                                     MinDist = 10,
                                     n = 10,
                                     n_to_test = 50)

Export_Points(Points, name = "Selected")




