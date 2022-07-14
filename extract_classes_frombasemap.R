library(terra)

# Set working directory
workingdirectory="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/"
setwd(workingdirectory)

basemapfile="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/forHanne_basemap_extract/lu_00_2018.tif"

# Import

basemap=rast(basemapfile)

# Automatically extract the ?3 and natura-2000 habitats (a 0-1 mask)

listofcodes=c(30000100,30000200,30000300,30000400,30000500,30000600,
              40121000,40122000,40123000,40131000,40132000,40133000,40134000,
              40211000,40212000,40213000,40214000,40216000,40217000,40218000,40219000,
              40225000,40231000,40232000,40233000,40401000,40403000,40513000,40612000,
              40621000,40623000,40641000,40643000,40711000,40712000,40714000,40715000,
              40721000,40722000,40723000,40822000,40910100,40910200,40911000,40912000,
              40913000,40915000,40916000,40917000,40919000)

for (i in listofcodes) {
  print(i)
  
  basemap_layer <- clamp(basemap, i, i,values=FALSE) 
  writeRaster(basemap_layer,paste("basemap_class_",i,".tif",paste=""),overwrite=TRUE)
  
}

# only ph3

basemap_layer_ph3 <- clamp(basemap, 30000100, 30000600,values=FALSE) 
writeRaster(basemap_layer_ph3,paste("basemap_class_ph3all.tif",paste=""),overwrite=TRUE)

# only natura-2000

basemap_layer_nat2000 <- clamp(basemap, 40121000, 40919000,values=FALSE) 
writeRaster(basemap_layer_nat2000,paste("basemap_class_nat2000all.tif",paste=""),overwrite=TRUE)

# only ph3 eng and mose

ph3_eng <- clamp(basemap, 30000100, 30000100,values=FALSE)
ph3_mose <- clamp(basemap, 30000300, 30000300,values=FALSE)

ph3_eng_mose <- merge(ph3_eng,ph3_mose)
writeRaster(ph3_eng_mose,paste("ph3_eng_mose.tif",paste=""),overwrite=TRUE)



