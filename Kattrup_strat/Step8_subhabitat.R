library(raster)
library(rgdal)

library(GeoStratR)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/")

#Import raster layers

rasterfiles=list.files(pattern = "*.tif$")
layers=stack(rasterfiles)

# Masking 

## road

layers[[9]][layers[[9]] < 15] <- NA
layers_wroadmask <- mask(layers, layers[[9]])

layers[[27]]=layers[[3]]

layers[[27]][layers[[27]] > 0] <- 1
names(layers[[27]])<-"forest_mask"

layers_wroadmask_forest <- mask(layers_wroadmask, layers[[27]])
layers_wroadmask_forest_open <- mask(layers_wroadmask, layers[[27]],inverse=TRUE)

# Open-Close

## Select set of variables for stratification to get open-close

layers_sel=layers_wroadmask[[c(10,11,12,14,15,17,18,20,21,22,24)]]
layers_sel_onlyveg=layers_sel[[c(1,4,5,6,7)]]

## Unsupervised clustering

stratified <- Stratify(layers_sel,LowGroup = 2, HighGroup = 3)
FinalRaster <- stratified$FinalStack
plot(FinalRaster)

writeRaster(FinalRaster,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_selcontlayers_openclose.tif")

stratified_onlyveg <- Stratify(layers_sel_onlyveg,LowGroup = 2, HighGroup = 2)
FinalRaster_onlyveg <- stratified_onlyveg$FinalStack
plot(FinalRaster_onlyveg)

writeRaster(FinalRaster_onlyveg,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_selcontlayers_openclose_onlyveg.tif")

# Dry-wet (Open)

## Select set of variables for stratification to get dry-wet in open areas

layers_sel_drywet_open=layers_wroadmask_forest_open[[c(10,11,12,14,15,17,18,20,21,22,24)]]

## Unsupervised clustering

stratified_drywet_open <- Stratify(layers_sel_drywet_open,LowGroup = 2, HighGroup = 2)
FinalRaster_drywet_open <- stratified_drywet_open$FinalStack
plot(FinalRaster_drywet_open)

writeRaster(FinalRaster_drywet_open,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_selcontlayers_drywet_open.tif")

# Dry-wet (Closed)

## Select set of variables for stratification to get dry-wet in open areas

layers_sel_drywet_forest=layers_wroadmask_forest[[c(10,11,12,14,15,17,18,20,21,22,24)]]

## Unsupervised clustering

stratified_drywet_forest <- Stratify(layers_sel_drywet_forest,LowGroup = 2, HighGroup = 2)
FinalRaster_drywet_forest <- stratified_drywet_forest$FinalStack
plot(FinalRaster_drywet_forest)

writeRaster(FinalRaster_drywet_forest,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_selcontlayers_drywet_forest.tif")


