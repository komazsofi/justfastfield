library(raster)
library(classInt)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/")

#Import raster layers

rasterfiles=list.files(pattern = "*.tif$")
layers=stack(rasterfiles)

# Masks

OpenClose=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Level1_forleaflet.tif")
FinalRaster_drywet_open=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/202208week1/Strat_drywet_forest_Level2b.tif")

# Apply mask and select layers

layers_open <- mask(layers, OpenClose,maskvalue=1,inverse=FALSE)
#layers_open_dry <- mask(layers_open, FinalRaster_drywet_open,maskvalue=2,inverse=TRUE)
layers_open_dry <- mask(layers_open, FinalRaster_drywet_open,maskvalue=2,inverse=FALSE)
layers_open_dry_c <- mask(layers_open_dry, layers_open_dry[["lidar_topo_solrad"]])

layers[["human_distfromroad"]][layers[["human_distfromroad"]] < 30] <- NA
layers_open_dry_c2 <- mask(layers_open_dry_c, layers[["human_distfromroad"]])

layers_open_dry_c_sel=layers_open_dry_c2[[c("forest_qualcomb_corr","forest_assembly_kattrup")]]

# combine classified layers

comb_opendry=layers_open_dry_c_sel[["forest_assembly_kattrup"]]+layers_open_dry_c_sel[["forest_qualcomb_corr"]]*10

# export

writeRaster(comb_opendry,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/20220805/Manual_forestdry_assemb_qual_level3c.tif")
#writeRaster(comb_opendry,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/20220805/Manual_forestwet_assemb_qual_level3d.tif")