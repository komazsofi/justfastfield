library(ecospat)
library(raster)
library(classInt)
library(rgdal)

library(factoextra)
library(corrplot)

CreateShape = function(data) {
  
  library(sp)
  
  data$X_obs=data$x
  data$Y_obs=data$y
  
  shp=data
  coordinates(shp)=~X_obs+Y_obs
  proj4string(shp)<- CRS("+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  
  return(shp)
  
}

setwd("G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/fromZsofia_Stratification/fromZsofia_Stratification/Organized_raster_layers/")

#Import raster layers

rasterfiles=list.files(pattern = "*.tif$")
layers=stack(rasterfiles)

# Previous stratification results for maksing

OpenClose=raster("G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/fromZsofia_Stratification/fromZsofia_Stratification/Results/202208week1/Level1_forleaflet.tif")
FinalRaster_drywet_open=raster("G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/fromZsofia_Stratification/fromZsofia_Stratification/Results/202208week1/Strat_drywet_open_Level2a.tif")

########## Level 3

# Open dry

layers_open <- mask(layers, OpenClose,maskvalue=1,inverse=TRUE)
layers_open_dry <- mask(layers_open, FinalRaster_drywet_open,maskvalue=2,inverse=FALSE)
layers_open_dry_c <- mask(layers_open_dry, layers_open_dry[["lidar_topo_solrad"]])

layers_open_dry_c_sel=layers_open_dry_c[[c("lidar_canopy_height","lidar_vegetation_density","lidar_vegetation_sddsm","lidar_vegetation_stdheight",
                                           "satelite_L_NDVI_med_30y","satelite_L_NDVI_std_30y","satelite_S2_NDVI_p90","satelite_S2_NDWI_p90")]]

layers_open_dry_c_sel=layers_open_dry_c[[c("satelite_L_NDVI_med_30y","satelite_L_NDVI_std_30y","satelite_S2_NDVI_p90","satelite_S2_NDWI_p90")]]

# make reclassified layers one by one - just to look at it

vegheight.rcl<-ecospat.rcls.grd(layers_open_dry_c_sel[["lidar_canopy_height"]],5)
vegdens.rcl<-ecospat.rcls.grd(layers_open_dry_c_sel[["lidar_vegetation_density"]],5)
sdsdm.rcl<-ecospat.rcls.grd(layers_open_dry_c_sel[["lidar_vegetation_sddsm"]],5)
vegvertvar.rcl<-ecospat.rcls.grd(layers_open_dry_c_sel[["lidar_vegetation_stdheight"]],5)
NDVI_med_30y.rcl<-ecospat.rcls.grd(layers_open_dry_c_sel[["satelite_L_NDVI_med_30y"]],5)
NDVI_std_30y.rcl<-ecospat.rcls.grd(layers_open_dry_c_sel[["satelite_L_NDVI_std_30y"]],5)
S2_NDVI_p90.rcl<-ecospat.rcls.grd(layers_open_dry_c_sel[["satelite_S2_NDVI_p90"]],5)
S2_NDWI_p90.rcl<-ecospat.rcls.grd(layers_open_dry_c_sel[["satelite_S2_NDWI_p90"]],5)

rcls=stack(vegheight.rcl,vegdens.rcl,sdsdm.rcl,vegvertvar.rcl,NDVI_med_30y.rcl,NDVI_std_30y.rcl,S2_NDVI_p90.rcl,S2_NDWI_p90.rcl)

# PCA anal

##PCA
set.seed(42)
layers_open_dry_c_samp <- sampleRandom(layers_open_dry_c_sel, size = 1000)
#layers_open_dry_c_samp <- sampleRandom(layers_open_dry_c_sel[["satelite_S2_NDWI_p90","lidar_vegetation_sddsm","satelite_L_NDVI_std_30y"]], size = 1000)
layers_open_dry_c_samp_df <- as.data.frame(layers_open_dry_c_samp)

res.pca_open_dry <- prcomp(layers_open_dry_c_samp_df, scale = TRUE)

fviz_pca_var(res.pca_open_dry,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

var1 <- get_pca_var(res.pca_open_dry)
corrplot(var1$contrib, is.corr=FALSE)

## single rasters based on PCA+visual interpret

for_strat_sdsdms=sdsdm.rcl+sdsdm.rcl
for_strat_NDVI_std_30y=NDVI_std_30y.rcl+NDVI_std_30y.rcl
for_strat_S2_NDWI_p90=S2_NDWI_p90.rcl+S2_NDWI_p90.rcl

prop_samples_sdsdms <- ecospat.recstrat_prop(for_strat_sdsdms,20)
prop_samples_NDVI_std_30y <- ecospat.recstrat_prop(for_strat_NDVI_std_30y,20)
prop_samples_S2_NDWI_p90 <- ecospat.recstrat_prop(for_strat_S2_NDWI_p90,20)

prop_samples_sdsdms_shp=CreateShape(prop_samples_sdsdms)
prop_samples_NDVI_std_30y_shp=CreateShape(prop_samples_NDVI_std_30y)
prop_samples_S2_NDWI_p90_shp=CreateShape(prop_samples_S2_NDWI_p90)

# place points

## ecospat combining rasters based on PCA+visual interpret

comb_foropendry=sdsdm.rcl+NDVI_std_30y.rcl*10+S2_NDWI_p90.rcl*100
comb_foropendry=NDVI_std_30y.rcl+S2_NDWI_p90.rcl*10

hist(comb_foropendry,breaks=100,col=heat.colors(81))
plot(comb_foropendry,col=rev(rainbow(81)))
yb<-rainbow(100)[round(runif(81,.5,100.5))]
plot(comb_foropendry,col=yb,main="Stratified map")

# place points

prop_samples_opendry <- ecospat.recstrat_prop(comb_foropendry,50)
prop_samples_opendry_shp=CreateShape(prop_samples_opendry)

# Export

shapefile(prop_samples_opendry_shp,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220804/combined/prop_level3b_openwet.shp")
writeRaster(comb_foropendry,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220804/combined/comb_level3b_openwet.tif")

shapefile(prop_samples_vegdens_shp,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220804/simple/prop_samples_sdsdms_openwet.shp")
shapefile(prop_samples_NDVI_std_30y_shp,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220804/simple/prop_samples_NDVI_std_30y_openwet.shp")
shapefile(prop_samples_S2_NDWI_p90_shp,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220804/simple/prop_samples_S2_NDWI_p90_openwet.shp")

writeRaster(sdsdm.rcl,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220804/simple/sdsdms_openwet.tif")
writeRaster(NDVI_std_30y.rcl,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220804/simple/NDVI_std_30y_openwet.tif")
writeRaster(S2_NDWI_p90.rcl,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220804/simple/S2_NDWI_p90_openwet.tif")