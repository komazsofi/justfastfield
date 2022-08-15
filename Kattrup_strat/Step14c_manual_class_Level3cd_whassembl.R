library(raster)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/")

#Import raster layers

rasterfiles=list.files(pattern = "*.tif$")
layers=stack(rasterfiles)

# Masks

OpenClose=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Level1_forleaflet.tif")
FinalRaster_drywet_open=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_drywet_forest_Level2b.tif")

# Apply mask and select layers

layers_open <- mask(layers, OpenClose,maskvalue=1,inverse=FALSE)
layers_open_wet <- mask(layers_open, FinalRaster_drywet_open,maskvalue=2,inverse=TRUE)
layers_open_dry <- mask(layers_open, FinalRaster_drywet_open,maskvalue=2,inverse=FALSE)

# export forest quality and height bins for dry and wet classes

writeRaster(layers_open_wet[["forest_qualcomb_corr"]],"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/toDerek/forest_qualcomb_corr_wet.tif")
writeRaster(layers_open_dry[["forest_qualcomb_corr"]],"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/toDerek/forest_qualcomb_corr_dry.tif")

writeRaster(layers_open_wet[["lidar_vegetation_heightclass_v3"]],"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/toDerek/forest_heightbins_wet.tif")
writeRaster(layers_open_dry[["lidar_vegetation_heightclass_v3"]],"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/toDerek/forest_heightbins_dry.tif")

# combine classified layers

comb_forestdry=layers_open_dry[["lidar_vegetation_heightclass_v4"]]+(layers_open_dry[["forest_qualcomb_corr"]]+1)*10
writeRaster(comb_forestdry,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/toDerek/comb_forestdry.tif",overwrite=TRUE)

comb_forestdry_simpl=comb_forestdry
comb_forestdry_simpl[comb_forestdry_simpl==31 | comb_forestdry_simpl==32 | comb_forestdry_simpl==33]<-30
comb_forestdry_simpl[comb_forestdry_simpl==41 | comb_forestdry_simpl==42 | comb_forestdry_simpl==43]<-40

writeRaster(comb_forestdry_simpl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/toDerek/comb_forestdry_simpl.tif",overwrite=TRUE)

comb_forestdry_simpl[comb_forestdry_simpl==11 | comb_forestdry_simpl==12]<-11
comb_forestdry_simpl[comb_forestdry_simpl==13]<-12

comb_forestdry_simpl[comb_forestdry_simpl==21 | comb_forestdry_simpl==22]<-21
comb_forestdry_simpl[comb_forestdry_simpl==23]<-22

writeRaster(comb_forestdry_simpl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/toDerek/comb_forestdry_simpl2.tif",overwrite=TRUE)

comb_forestwet=layers_open_wet[["lidar_vegetation_heightclass_v4"]]+(layers_open_wet[["forest_qualcomb_corr"]]+1)*10
writeRaster(comb_forestwet,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/toDerek/comb_forestwet.tif",overwrite=TRUE)

comb_forestwet_simpl=comb_forestwet
comb_forestwet_simpl[comb_forestwet_simpl==31 | comb_forestwet_simpl==32 | comb_forestwet_simpl==33]<-30
comb_forestwet_simpl[comb_forestwet_simpl==41 | comb_forestwet_simpl==42 | comb_forestwet_simpl==43]<-40

writeRaster(comb_forestwet_simpl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/toDerek/comb_forestwet_simpl.tif",overwrite=TRUE)

comb_forestwet_simpl[comb_forestwet_simpl==11 | comb_forestwet_simpl==12]<-11
comb_forestwet_simpl[comb_forestwet_simpl==13]<-12

comb_forestwet_simpl[comb_forestwet_simpl==21 | comb_forestwet_simpl==22]<-21
comb_forestwet_simpl[comb_forestwet_simpl==23]<-22

writeRaster(comb_forestwet_simpl,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/toDerek/comb_forestwet_simpl2.tif",overwrite=TRUE)
