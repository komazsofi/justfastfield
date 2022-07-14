library(sf)
library(raster)
library(tidyverse)

# import

study_area=st_read("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/Samplet_au_sinks_2021/Samplet_au_sinks_2021/samplede_AU_pkt_2021.shp")

ph3_eng=stack("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/forHanne_basemap_extract/basemap_class_ 30000100 .tif")
ph3_eng_reclass <- reclassify(ph3_eng, cbind(30000100, 1))

novana_eng=st_read("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/data_plot_5m_onlyeng.shp")

## how many pixels are around from the class at 500 m, 1000 m and 5000 m

v_500 <- raster::extract(ph3_eng_reclass, study_area, buffer=500, fun=function(x, ...) length(na.omit(x)), na.rm = TRUE) 
study_area$ph3_dunes_wbuff500m=v_500[,1]

v_1000 <- raster::extract(ph3_eng_reclass, study_area, buffer=1000, fun=function(x, ...) length(na.omit(x)), na.rm = TRUE) 
study_area$ph3_dunes_wbuff1000m=v_1000[,1]

## how many novana points are around



# export
st_write(study_area,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/sinkplotsmeadow_withbufferzones_v3.shp")





