library(raster)
library(rgdal)

library(GeoStratR)

library(factoextra)
library(corrplot)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/")

#Import raster layers

rasterfiles=list.files(pattern = "*.tif$")
layers=stack(rasterfiles)

# Masking 

## fill up holes

#layers[[12]][is.na(layers[[12]])] <- 0
#layers[[20]][is.na(layers[[20]])] <- 0
#layers[[21]][is.na(layers[[21]])] <- 0
#layers[[22]][is.na(layers[[22]])] <- 0

## forest mask

layers[[27]]=layers[[3]]

layers[[27]][layers[[27]] > 0] <- 1
names(layers[[27]])<-"forest_mask"

layers_wroadmask_forest <- mask(layers, layers[[27]])
layers_wroadmask_forest_open <- mask(layers, layers[[27]],inverse=TRUE)

writeRaster(layers[[27]],"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_selcontlayers_openclose_hardclass.tif",overwrite=TRUE)

# Open-Close

## Select set of variables for stratification to get open-close

layers_sel=layers[[c(10,14,17)]]

## Unsupervised clustering

stratified <- Stratify(layers_sel,LowGroup = 2, HighGroup = 2)
FinalRaster <- stratified$FinalStack
plot(FinalRaster)

writeRaster(FinalRaster,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_selcontlayers_openclose_v4.tif")

# Dry-wet (Open)

## Select set of variables for stratification to get dry-wet in open areas

layers_sel_drywet_open=layers_wroadmask_forest_open[[c(11,12,20,21,22,24)]]

##PCA
set.seed(42)
layers_drywet_open_samp <- sampleRandom(layers_sel_drywet_open, size = 1000)
layers_drywet_open_samp_df <- as.data.frame(layers_drywet_open_samp )

res.pca_drywet_open <- prcomp(layers_drywet_open_samp_df, scale = FALSE)

fviz_pca_var(res.pca_drywet_open,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

## Unsupervised clustering

stratified_drywet_open <- Stratify(layers_sel_drywet_open,LowGroup = 2, HighGroup = 2)
FinalRaster_drywet_open <- stratified_drywet_open$FinalStack
plot(FinalRaster_drywet_open)

writeRaster(FinalRaster_drywet_open,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_selcontlayers_drywet_open_v4.tif")

# Dry-wet (Closed)

## Select set of variables for stratification to get dry-wet in open areas

layers_sel_drywet_forest=layers_wroadmask_forest[[c(11,12,20,21,22,24)]]

##PCA
set.seed(42)
layers_drywet_forest_samp <- sampleRandom(layers_sel_drywet_forest, size = 1000)
layers_drywet_forest_samp_df <- as.data.frame(layers_drywet_forest_samp )

res.pca_drywet_forest <- prcomp(layers_drywet_forest_samp_df, scale = FALSE)

fviz_pca_var(res.pca_drywet_forest,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

## Unsupervised clustering

stratified_drywet_forest <- Stratify(layers_sel_drywet_forest,LowGroup = 2, HighGroup = 2)
FinalRaster_drywet_forest <- stratified_drywet_forest$FinalStack
plot(FinalRaster_drywet_forest)

writeRaster(FinalRaster_drywet_forest,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_selcontlayers_drywet_forest_v4.tif")


