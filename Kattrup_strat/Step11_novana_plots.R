library(data.table)
library(sf)
library(raster)

library(tidyverse)

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

asreference=raster("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Organized_raster_layers/lidar_vegetation_density.tif")

# Create plot data shapefile

data_5m=data[is.na(data$Plot5mID)==FALSE,]

data_plot_5m=data_5m %>% 
  group_by(Plot5mID,Yeare,Habitat,HabitatID,UTM_X_orig,UTM_Y_orig) %>%
  summarize(SpRichness=n())

data_plot_5m_shp=CreateShape(data_plot_5m)

# Only within eng habitats

eng <- raster::extract(asreference, data_plot_5m_shp) 
data_plot_5m_shp$ph3=eng

data_plot_5m_witheng=data_plot_5m_shp@data 
data_plot_5m_witheng_filt=na.omit(data_plot_5m_witheng)

data_plot_5m_witheng_filt_shp=CreateShape(data_plot_5m_witheng_filt)

#export

shapefile(data_plot_5m_witheng_filt_shp,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/Kattrup_novana_5mplots.shp")