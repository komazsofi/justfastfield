library(data.table)
library(sf)
library(raster)
library(rgdal)

library(tidyverse)
library(openxlsx)

CreateShape = function(data) {
  
  library(sp)
  
  data$X_obs=data$UTM_X_orig
  data$Y_obs=data$UTM_Y_orig
  
  shp=data
  coordinates(shp)=~X_obs+Y_obs
  proj4string(shp)<- CRS("+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  
  return(shp)
  
}

# Import

data<-as.data.frame(fread("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/_PostDoc_Paper1_plantdivfromlidar/Dataset/fielddata/novana/NOVANAAndP3_tozsofia/NOVANAAndP3_tozsofia.tsv",
                          encoding="UTF-8"))

asreference=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/satelite_S2_NDWI_p90.tif")

# Create plot data shapefile

data_5m=data[is.na(data$Plot5mID)==FALSE,]

data_plot_5m=data_5m %>% 
  group_by(Plot5mID,Yeare,Habitat,HabitatID,ProgNavn,UTM_X_orig,UTM_Y_orig) %>%
  summarize(SpRichness=n())

data_plot_5m_shp=CreateShape(data_plot_5m)

# for Kattrup area

Kattrup <- raster::extract(asreference, data_plot_5m_shp) 

data_plot_5m_shp$kattrup=Kattrup

data_plot_5m_kattrup=data_plot_5m_shp@data 
data_plot_5m_kattrup_filt=na.omit(data_plot_5m_kattrup)
data_plot_5m_kattrup_filt=data_plot_5m_kattrup_filt[,c(1,2,3,4,5,6,7,8)]

data_plot_5m_kattrup_filt_shp=CreateShape(data_plot_5m_kattrup_filt)
crs(data_plot_5m_kattrup_filt_shp)<-crs(asreference)

CRS.new=CRS("+init=epsg:4326")
data_plot_5m_kattrup_filt_shp_wgs84 <- spTransform(data_plot_5m_kattrup_filt_shp, CRS.new)
data_plot_5m_kattrup_filt_shp_wgs84_df <- as.data.frame(data_plot_5m_kattrup_filt_shp_wgs84)

#export

write.xlsx(data_plot_5m_kattrup_filt, "O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/toSigne/data_plot_5m_kattrup_filt.xlsx",overwrite=TRUE)
shapefile(data_plot_5m_kattrup_filt_shp,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/toSigne/data_plot_5m_kattrup_filt.shp",overwrite=TRUE)
writeOGR(data_plot_5m_kattrup_filt_shp,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/toSigne/data_plot_5m_kattrup_filt.kml",driver="KML",layer="Habitat")
write.xlsx(data_plot_5m_kattrup_filt_shp_wgs84_df, "O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/toSigne/data_plot_5m_kattrup_filt_wgs84.xlsx",overwrite=TRUE)

# export per program

programs=unique(data_plot_5m_kattrup_filt$ProgNavn)

for (i in 1:13) {
  print(i)
  
  data_sel=data_plot_5m_kattrup_filt[data_plot_5m_kattrup_filt$ProgNavn==programs[i],]
  
  #write.xlsx(data_sel, paste0("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/toSigne/",programs[i],"_kattrup_filt.xlsx"),overwrite=TRUE)
  
  data_sel_shp=CreateShape(data_sel)
  shapefile(data_sel_shp,paste0("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/toSigne/",programs[i],"_kattrup_filt.shp"),overwrite=TRUE)
  
}

