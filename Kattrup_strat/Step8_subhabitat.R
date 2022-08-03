library(raster)
library(rgdal)

library(GeoStratR)

library(factoextra)
library(corrplot)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/")

#Import raster layers

rasterfiles=list.files(pattern = "*.tif$")
layers=stack(rasterfiles)

########## Level 1

# Open-Close

## forest mask

layers[["forest_mask"]]=layers[["forest_treetype"]]

layers[["forest_mask"]][layers[["forest_mask"]] > 0] <- 1

layers_forest <- mask(layers, layers[["forest_mask"]])
layers_open <- mask(layers, layers[["forest_mask"]],inverse=TRUE)

writeRaster(layers[["forest_mask"]],"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_openclose_hardclass_Level1.tif",overwrite=TRUE)
openclose_poly=rasterToPolygons(layers[["forest_mask"]], fun=NULL, n=4, na.rm=FALSE, digits=3, dissolve=TRUE)
shapefile(openclose_poly,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_openclose_hardclass_Level1.shp",overwrite=TRUE)

# Open-Close automatic

## Select set of variables for stratification to get open-close

#layers_sel=layers[[c(10,14,17)]]

## Unsupervised clustering

#stratified <- Stratify(layers_sel,LowGroup = 2, HighGroup = 2)
#FinalRaster <- stratified$FinalStack
#plot(FinalRaster)

#writeRaster(FinalRaster,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_selcontlayers_openclose_v4.tif")

########## Level 2

# Dry-wet (Open)

## Select set of variables for stratification to get dry-wet in open areas

layers_sel_drywet_open=layers_open[[c("lidar_topo_dtm","lidar_topo_slope","lidar_topo_solrad","soil_agsand","soil_carbon","soil_clay","soil_sum_shal")]]

## Unsupervised clustering

stratified_drywet_open <- Stratify(layers_sel_drywet_open,LowGroup = 2, HighGroup = 2)
FinalRaster_drywet_open <- stratified_drywet_open$FinalStack
plot(FinalRaster_drywet_open)

writeRaster(FinalRaster_drywet_open,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_drywet_open_Level2a.tif")
drywet_open_poly=rasterToPolygons(FinalRaster_drywet_open, fun=NULL, n=4, na.rm=FALSE, digits=3, dissolve=TRUE)
shapefile(drywet_open_poly,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_drywet_open_Level2a.shp",overwrite=TRUE)

# Dry-wet (Closed)

## Select set of variables for stratification to get dry-wet in open areas

layers_sel_drywet_forest=layers_forest[[c("lidar_topo_dtm","lidar_topo_slope","lidar_topo_solrad","soil_agsand","soil_carbon","soil_clay","soil_sum_shal")]]

## Unsupervised clustering

stratified_drywet_forest <- Stratify(layers_sel_drywet_forest,LowGroup = 2, HighGroup = 2)
FinalRaster_drywet_forest <- stratified_drywet_forest$FinalStack
plot(FinalRaster_drywet_forest)

writeRaster(FinalRaster_drywet_forest,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_drywet_forest_Level2b.tif")
drywet_forest_poly=rasterToPolygons(FinalRaster_drywet_forest, fun=NULL, n=4, na.rm=FALSE, digits=3, dissolve=TRUE)
shapefile(drywet_forest_poly,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_drywet_forest_Level2b.shp",overwrite=TRUE)

########## Level 3

# Open dry

layers_open_dry <- mask(layers_open, FinalRaster_drywet_open,maskvalue=1)

## Select set of variables for stratification to get dry-wet in open areas

layers_open_dry_sel=layers_open_dry[[c("lidar_canopy_height","lidar_vegetation_density","lidar_vegetation_sddsm","lidar_vegetation_sddens",
                                       "satelite_L_NDVI_med_30y","satelite_S2_NDVI_p90","satelite_S2_NDWI_p90")]]

## Unsupervised clustering

stratified_open_dry <- Stratify(layers_open_dry_sel,LowGroup = 2, HighGroup = 3)
FinalRaster_open_dry <- stratified_open_dry$FinalStack
plot(FinalRaster_open_dry)

writeRaster(FinalRaster_open_dry,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_open_dry_Level3a.tif")
open_dry_poly=rasterToPolygons(FinalRaster_open_dry, fun=NULL, n=4, na.rm=FALSE, digits=3, dissolve=TRUE)
shapefile(open_dry_poly,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_open_dry_Level3a.shp",overwrite=TRUE)

# Open wet

layers_open_wet <- mask(layers_open, FinalRaster_drywet_open,maskvalue=2)

## Select set of variables for stratification to get dry-wet in open areas

layers_open_wet_sel=layers_open_wet[[c("lidar_canopy_height","lidar_vegetation_density","lidar_vegetation_sddsm","lidar_vegetation_sddens",
                                       "satelite_L_NDVI_med_30y","satelite_S2_NDVI_p90","satelite_S2_NDWI_p90","soil_sum_shal")]]

## Unsupervised clustering

stratified_open_wet <- Stratify(layers_open_wet_sel,LowGroup = 2, HighGroup = 3)
FinalRaster_open_wet <- stratified_open_wet$FinalStack
plot(FinalRaster_open_wet)

writeRaster(FinalRaster_open_wet,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_open_wet_Level3b.tif")
open_wet_poly=rasterToPolygons(FinalRaster_open_wet, fun=NULL, n=4, na.rm=FALSE, digits=3, dissolve=TRUE)
shapefile(open_wet_poly,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_open_wet_Level3b.shp",overwrite=TRUE)

# Forest dry (with continuous layers)

layers_forest_dry <- mask(layers_forest, FinalRaster_drywet_forest,maskvalue=2)

## Select set of variables for stratification to get dry-wet in open areas

layers_forest_dry_sel=layers_forest_dry[[c("lidar_canopy_height","lidar_vegetation_density","forest_qualsimple","lidar_vegetation_stdheight")]]

## Unsupervised clustering

stratified_forest_dry <- Stratify(layers_forest_dry_sel,LowGroup = 2, HighGroup = 3)
FinalRaster_forest_dry <- stratified_forest_dry$FinalStack
plot(FinalRaster_forest_dry)

writeRaster(FinalRaster_forest_dry,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_forest_dry_Level3c.tif")
forest_dry_poly=rasterToPolygons(FinalRaster_forest_dry, fun=NULL, n=4, na.rm=FALSE, digits=3, dissolve=TRUE)
shapefile(forest_dry_poly,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_forest_dry_Level3c.shp",overwrite=TRUE)

# Forest wet (with continuous layers)

layers_forest_wet <- mask(layers_forest, FinalRaster_drywet_forest,maskvalue=1)

## Select set of variables for stratification to get dry-wet in open areas

layers_forest_wet_sel=layers_forest_wet[[c("lidar_canopy_height","lidar_vegetation_density","forest_qualsimple","lidar_vegetation_stdheight","soil_sum_shal")]]

## Unsupervised clustering

stratified_forest_wet <- Stratify(layers_forest_wet_sel,LowGroup = 2, HighGroup = 3)
FinalRaster_forest_wet <- stratified_forest_wet$FinalStack
plot(FinalRaster_forest_wet)

writeRaster(FinalRaster_forest_wet,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_forest_wet_Level3d.tif")
forest_wet_poly=rasterToPolygons(FinalRaster_forest_wet, fun=NULL, n=4, na.rm=FALSE, digits=3, dissolve=TRUE)
shapefile(forest_wet_poly,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_forest_wet_Level3d.shp",overwrite=TRUE)

# Forest dry (with hardclass layers)

## Select set of variables for stratification to get dry-wet in open areas

layers_forest_dry_sel2=layers_forest_dry[[c("lidar_canopy_height","lidar_vegetation_density","forest_qualsimple","lidar_vegetation_stdheight","forest_age_kattrup",
                                            "forest_species_kattrup","forest_treetype")]]

## Unsupervised clustering

stratified_forest_dry2 <- Stratify(layers_forest_dry_sel2,LowGroup = 2, HighGroup = 3)
FinalRaster_forest_dry2 <- stratified_forest_dry2$FinalStack
plot(FinalRaster_forest_dry2)

writeRaster(FinalRaster_forest_dry2,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_forest_dry_Level3c_hardclass.tif")
forest_dry_poly2=rasterToPolygons(FinalRaster_forest_dry2, fun=NULL, n=4, na.rm=FALSE, digits=3, dissolve=TRUE)
shapefile(forest_dry_poly2,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_forest_dry_Level3c_hardclass.shp",overwrite=TRUE)

# Forest wet (with hardclass layers)

## Select set of variables for stratification to get dry-wet in open areas

layers_forest_wet_sel2=layers_forest_wet[[c("lidar_canopy_height","lidar_vegetation_density","forest_qualsimple","lidar_vegetation_stdheight","soil_sum_shal",
                                            "forest_age_kattrup","forest_species_kattrup","forest_treetype")]]

## Unsupervised clustering

stratified_forest_wet2 <- Stratify(layers_forest_wet_sel2,LowGroup = 2, HighGroup = 3)
FinalRaster_forest_wet2 <- stratified_forest_wet2$FinalStack
plot(FinalRaster_forest_wet2)

writeRaster(FinalRaster_forest_wet2,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_forest_wet_Level3d_hardclass.tif")
forest_wet_poly2=rasterToPolygons(FinalRaster_forest_wet2, fun=NULL, n=4, na.rm=FALSE, digits=3, dissolve=TRUE)
shapefile(forest_wet_poly2,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_forest_wet_Level3d_hardclass.shp",overwrite=TRUE)
