library(sf)
library(raster)
library(tidyverse)

CreateShape = function(data) {
  
  library(sp)
  
  data$X_obs=data$X
  data$Y_obs=data$Y
  
  shp=data
  coordinates(shp)=~X_obs+Y_obs
  proj4string(shp)<- CRS("+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  
  return(shp)
  
}

# import

study_area=st_read("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/Samplet_au_sinks_2021/Samplet_au_sinks_2021/samplede_AU_pkt_2021.shp")

ph3_eng=stack("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/forHanne_basemap_extract/basemap_class_ 30000100 .tif")
ph3_eng_reclass <- reclassify(ph3_eng, cbind(30000100, 1))

novana_eng=st_read("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/data_plot_5m_onlyeng.shp")
st_crs(novana_eng)=25832

## how many pixels are around from the class at 500 m, 1000 m and 5000 m

v_500 <- raster::extract(ph3_eng_reclass, study_area, buffer=500, fun=function(x, ...) length(na.omit(x)), na.rm = TRUE) 
study_area$eng_wbuff500m=v_500

v_1000 <- raster::extract(ph3_eng_reclass, study_area, buffer=1000, fun=function(x, ...) length(na.omit(x)), na.rm = TRUE) 
study_area$eng_wbuff1000m=v_1000

## how many novana points are around

study_area_500m=st_buffer(study_area,500)
study_area_500m$eng_count_500m <- lengths(st_intersects(study_area_500m, novana_eng))

study_area_1000m=st_buffer(study_area_500m,500)
study_area_1000m$eng_count_1000m <- lengths(st_intersects(study_area_1000m, novana_eng))

study_area_1000m_df=as.data.frame(study_area_1000m)
study_area_1000m_df_c <- subset(study_area_1000m_df, select = -c(geometry))

study_area_1000m_shp=CreateShape(study_area_1000m_df_c)

# export
#st_write(study_area_500m,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/study_area_500m.shp")
#st_write(study_area_1000m,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/study_area_1000m.shp")

shapefile(study_area_1000m_shp,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/sinkplotsmeadow_withbufferzones_v3.shp")





