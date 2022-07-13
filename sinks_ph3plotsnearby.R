library(sf)
library(raster)
library(tidyverse)
library(rgdal)
library(stars)
library(rSDM)

# import

study_area=st_read("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/Samplet_au_sinks_2021/Samplet_au_sinks_2021/samplede_AU_pkt_2021.shp")

# how many pixels are around

Shapes <- list(study_area) %>% purrr::map(~st_buffer(.x,dist = 500)) %>% 
  purrr::map(st_as_sf)
studyarea_wbuff250m=Shapes[[1]]


Shapes <- list(study_area) %>% purrr::map(~st_buffer(.x,dist = 1000)) %>% 
  purrr::map(st_as_sf)
studyarea_wbuff500m=Shapes[[1]]

Shapes <- list(study_area) %>% purrr::map(~st_buffer(.x,dist = 5000)) %>% 
  purrr::map(st_as_sf)
studyarea_wbuff1000m=Shapes[[1]]

## ph3 from Biodiversity council processing

#ph3_wdunes=brick("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/Rast_COG_p3_klit.tif")
#ph3_wdunes_one=ph3_wdunes[[1]]

#ph3_wdunes_one_wNA <- clamp(ph3_wdunes_one, lower=1, upper=6, useValues=FALSE)
#writeRaster(ph3_wdunes_one_wNA,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/ph3_wdunes_one_wNA.tif")

ph3_wdunes_NA=brick("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/ph3_wdunes_one_wNA.tif")
ph3_meadow <- clamp(ph3_wdunes_NA, lower=1, upper=1, useValues=FALSE)

ph3_meadow_utm32 <- projectRaster(ph3_meadow,crs = crs(study_area))

## intersection add where ph3 is present at different distances 500 m distance

v_50 <- raster::extract(ph3_meadow, studyarea_wbuff50m,fun = max, na.rm = TRUE) 
study_area$ph3_dunes_wbuff50m=v_50[,1]

v_100 <- raster::extract(ph3_meadow, studyarea_wbuff100m,fun = max, na.rm = TRUE) 
study_area$ph3_dunes_wbuff100m=v_100[,1]

v_250 <- raster::extract(ph3_meadow, studyarea_wbuff250m,fun = max, na.rm = TRUE) 
study_area$ph3_dunes_wbuff250m=v_250[,1]

v_500 <- raster::extract(ph3_meadow, studyarea_wbuff500m,fun = max, na.rm = TRUE) 
study_area$ph3_dunes_wbuff500m=v_500[,1]

v_1000 <- raster::extract(ph3_meadow, studyarea_wbuff1000m,fun = max, na.rm = TRUE) 
study_area$ph3_dunes_wbuff1000m=v_1000[,1]

# export
st_write(study_area,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/sinkplotsmeadow_withbufferzones.shp")





