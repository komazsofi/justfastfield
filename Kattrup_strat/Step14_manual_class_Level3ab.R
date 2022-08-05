library(ecospat)
library(raster)
library(classInt)

setwd("G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/fromZsofia_Stratification/fromZsofia_Stratification/Organized_raster_layers/")

#Import raster layers

rasterfiles=list.files(pattern = "*.tif$")
layers=stack(rasterfiles)

# Masks

OpenClose=raster("G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/fromZsofia_Stratification/fromZsofia_Stratification/Results/202208week1/Level1_forleaflet.tif")
FinalRaster_drywet_open=raster("G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/fromZsofia_Stratification/fromZsofia_Stratification/Results/202208week1/Strat_drywet_open_Level2a.tif")

# Apply mask and select layers

layers_open <- mask(layers, OpenClose,maskvalue=1,inverse=TRUE)
layers_open_dry <- mask(layers_open, FinalRaster_drywet_open,maskvalue=2,inverse=TRUE)
#layers_open_dry <- mask(layers_open, FinalRaster_drywet_open,maskvalue=2,inverse=FALSE)
layers_open_dry_c <- mask(layers_open_dry, layers_open_dry[["lidar_topo_solrad"]])

layers[["human_distfromroad"]][layers[["human_distfromroad"]] < 30] <- NA
layers_open_dry_c2 <- mask(layers_open_dry_c, layers[["human_distfromroad"]])

layers_open_dry_c_sel=layers_open_dry_c2[[c("satelite_L_NDVI_std_30y","satelite_S2_NDVI_p10")]]

# visualization

plot(layers_open_dry_c_sel)
hist(layers_open_dry_c_sel[[1]])
hist(layers_open_dry_c_sel[[2]])

plot(layers_open_dry_c_sel[[1]],layers_open_dry_c_sel[[2]])

# introduce the classes manually

landsat_class_dry=reclassify(layers_open_dry_c_sel[[1]], c(c(-Inf,0.07,1,0.07,Inf,2)))
sentinel_class_dry=reclassify(layers_open_dry_c_sel[[2]], c(c(-Inf,0.1,1,0.1,Inf,2)))

comb_opendry=landsat_class_dry+sentinel_class_dry*10

# Export
writeRaster(comb_opendry,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220805/comb_opendry_std30y_ndvip10.tif",overwrite=TRUE)
#writeRaster(comb_opendry,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220805/comb_openwet_std30y_ndvip10.tif",overwrite=TRUE)
