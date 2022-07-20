library(raster)
library(rgdal)

library(factoextra)
library(corrplot)

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

# apply distance from road mask

layers[[7]][layers[[7]] < 30] <- NA

layers_wroadmask <- mask(layers, layers[[7]])

# PCA

set.seed(42)
layers_crop_samp <- sampleRandom(layers_crop_mask, size = 1000)
layers_crop_samp_df <- as.data.frame(layers_crop_samp )

res.pca <- prcomp(layers_crop_samp_df, scale = FALSE)
fviz_eig(res.pca)

fviz_pca_var(res.pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

var1 <- get_pca_var(res.pca)
corrplot(var1$contrib, is.corr=FALSE)

res.pca_cont <- prcomp(layers_crop_samp_df[c(8:24)], scale = TRUE)
fviz_eig(res.pca_cont)

fviz_pca_var(res.pca_cont,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

var <- get_pca_var(res.pca_cont)
corrplot(var$contrib, is.corr=FALSE)

res.pca_whhum <- prcomp(layers_crop_samp_df[c(1:6,8:24)], scale = FALSE)
fviz_eig(res.pca_whhum )

fviz_pca_var(res.pca_whhum ,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

var2 <- get_pca_var(res.pca_whhum )
corrplot(var2$contrib, is.corr=FALSE)