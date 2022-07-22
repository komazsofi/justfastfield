library(raster)
library(rgdal)

library(GeoStratR)

library(factoextra)
library(corrplot)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/")

#Import raster layers

subhabitats_forest=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_selcontlayers_drywet_forest.tif")

rasterfiles=list.files(pattern = "*.tif$")
layers=stack(rasterfiles)

# Masking 

## road

layers[[9]][layers[[9]] < 15] <- NA
layers_wroadmask <- mask(layers, layers[[9]])

# Wet forest sub habitat

subhabitats_forest_mask=subhabitats_forest
subhabitats_forest_mask[subhabitats_forest_mask == 2] <- NA

layers_wroadmask_forest_wet <- mask(layers_wroadmask, subhabitats_forest_mask)

## PCA

#allvar: c(1,2,3,10,11,12,14,15,17,18,20,21,22,24)
#onlyveg: c(1,2,3,10,14,15,17,18)

set.seed(42)
layers_forest_wet_samp <- sampleRandom(layers_wroadmask_forest_wet, size = 1000)
layers_forest_wet_samp_df <- as.data.frame(layers_forest_wet_samp )

res.pca_forest_wet <- prcomp(layers_forest_wet_samp_df[c(1,2,3,10,14,15,17,18)], scale = FALSE)

fviz_pca_var(res.pca_forest_wet,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

var_forest_wet <- get_pca_var(res.pca_forest_wet)
corrplot(var_forest_wet$contrib, is.corr=FALSE)

## stratification

layers_sel=layers_wroadmask_forest_wet[[c(1,2,3,10,11,12,14,15,17,18,20,21,22,24)]]

stratified <- Stratify(layers_sel,LowGroup = 2, HighGroup = 2)
FinalRaster <- stratified$FinalStack
plot(FinalRaster)

Points <- Random_Stratified_Min_Dist(ClassRaster = FinalRaster,
                                     MinDist = 10,
                                     n = 25,
                                     n_to_test = 100)

Export_Points(Points, name = "O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_wet_forest_50_2cluster")

# Dry forest sub habitat

subhabitats_mask_dry_forest=subhabitats_forest
subhabitats_mask_dry_forest[subhabitats_mask_dry_forest == 1] <- NA

layers_wroadmask_dry_forest<- mask(layers_wroadmask, subhabitats_mask_dry_forest)

## PCA

set.seed(42)
layers_forest_dry_samp <- sampleRandom(layers_wroadmask_dry_forest, size = 1000)
layers_forest_dry_samp_df <- as.data.frame(layers_forest_dry_samp )

res.pca_forest_dry <- prcomp(layers_forest_dry_samp_df[c(1,2,3,10,11,12,14,15,17,18,20,21,22,24)], scale = FALSE)

fviz_pca_var(res.pca_forest_dry,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

var_forest_dry <- get_pca_var(res.pca_forest_dry)
corrplot(var_forest_dry$contrib, is.corr=FALSE)

## stratification

layers_sel_forest_dry=layers_wroadmask_dry_forest[[c(1,2,3,10,14,15,17,18)]]

stratified_forest_dry <- Stratify(layers_sel_forest_dry,LowGroup = 2, HighGroup = 2)
FinalRaster_forest_dry <- stratified_forest_dry$FinalStack
plot(FinalRaster_forest_dry)

Points__forest_dry <- Random_Stratified_Min_Dist(ClassRaster = FinalRaster_forest_dry,
                                     MinDist = 10,
                                     n = 25,
                                     n_to_test = 100)

Export_Points(Points_forest_dry, name = "O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_dry_forest_50_2cluster")

