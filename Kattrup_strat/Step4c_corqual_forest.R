library(raster)

forestqualcomb=stack("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/forest_qualcomb.tif")

forestqualcomb[forestqualcomb==0]<-NA
forestqualcomb[forestqualcomb==1]<-0
forestqualcomb[forestqualcomb==2]<-1
forestqualcomb[forestqualcomb==0]<-2

writeRaster(forestqualcomb,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/forest_qualcomb_corr.tif")
