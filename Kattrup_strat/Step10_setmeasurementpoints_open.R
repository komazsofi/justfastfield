library(raster)
library(rgdal)

library(GeoStratR)

library(factoextra)
library(corrplot)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/")

#Import raster layers

subhabitats_drywet_open=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_selcontlayers_drywet_open.tif")

rasterfiles=list.files(pattern = "*.tif$")
layers=stack(rasterfiles)

# Masking 

## road

layers[[9]][layers[[9]] < 15] <- NA
layers_wroadmask <- mask(layers, layers[[9]])

# Dry open sub habitat

subhabitats_drywet_open_mask=subhabitats_drywet_open
subhabitats_drywet_open_mask[subhabitats_drywet_open_mask == 2] <- NA

layers_wroadmask_open_dry <- mask(layers_wroadmask, subhabitats_drywet_open_mask)

## PCA

#allvar: c(1,2,3,10,11,12,14,15,17,18,20,21,22,24)
#onlyveg: c(1,2,3,10,14,15,17,18)

set.seed(42)
layers_open_dry_samp <- sampleRandom(layers_wroadmask_open_dry[[c(10,14,15,17,18)]], size = 1000)
layers_open_dry_samp_df <- as.data.frame(layers_open_dry_samp )

res.pca_open_dry <- prcomp(layers_open_dry_samp_df, scale = FALSE)

fviz_pca_var(res.pca_open_dry,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

var_open_dry <- get_pca_var(res.pca_open_dry)
corrplot(var_open_dry$contrib, is.corr=FALSE)

## stratification

layers_sel_open_dry=layers_wroadmask_open_dry[[c(10,11,12,14,15,17,18,20,21,22,24)]]

stratified_open_dry <- Stratify(layers_sel_open_dry,LowGroup = 2, HighGroup = 2)
FinalRaster_open_dry <- stratified_open_dry$FinalStack
plot(FinalRaster_open_dry)

Points_open_dry <- Random_Stratified_Min_Dist(ClassRaster = FinalRaster_open_dry,
                                     MinDist = 10,
                                     n = 25,
                                     n_to_test = 100)

Export_Points(Points_open_dry, name = "O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_wet_forest_50_2cluster")

# Wet open sub habitat

subhabitats_mask_wet_open=subhabitats_drywet_open
subhabitats_mask_wet_open[subhabitats_mask_wet_open == 1] <- NA

layers_wroadmask_wet_open <- mask(layers_wroadmask, subhabitats_mask_wet_open)

## PCA

set.seed(42)
layers_wet_open_samp <- sampleRandom(layers_wroadmask_wet_open[[c(10,11,12,14,15,17,18,20,21,22,24)]], size = 1000)
layers_wet_open_samp_df <- as.data.frame(layers_wet_open_samp )

res.pca_wet_open <- prcomp(layers_wet_open_samp_df, scale = FALSE)

fviz_pca_var(res.pca_wet_open,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

var_wet_open <- get_pca_var(res.pca_wet_open)
corrplot(var_wet_open$contrib, is.corr=FALSE)

## stratification

layers_sel_wet_open=layers_wroadmask_wet_open[[c(10,11,12,14,15,17,18,20,21,22,24)]]

stratified_wet_open <- Stratify(layers_sel_wet_open,LowGroup = 2, HighGroup = 2)
FinalRaster_wet_open <- stratified_wet_open$FinalStack
plot(FinalRaster_wet_open)

Points_wet_open <- Random_Stratified_Min_Dist(ClassRaster = FinalRaster_wet_open,
                                           MinDist = 10,
                                           n = 25,
                                           n_to_test = 100)

Export_Points(Points_wet_open, name = "O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Strat_dry_forest_50_2cluster")