library(terra)
library(foreign)
library(tidyverse)
library(tm)
library(sf)
library(landscapemetrics)

# import

cropmap=vect("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/CA_selection_utm.shp")
basemap=rast("O:/Nat_Sustain-proj/_user/HanneNicolaisen_au704629/Data/Land_cover_maps/Basemap/Basemap03_public_geotiff/basemap03_2011_2016_2018/lu_agg_2018.tif")
classes <- read.dbf("O:/Nat_Sustain-proj/_user/HanneNicolaisen_au704629/Data/Land_cover_maps/Basemap/Basemap03_public_geotiff/basemap03_2018/lu_00_2018.tif.vat.dbf")

# prep basemap with relevant classes

class_c <- c(110000, NA,
             121000, NA,
             121110, NA,
             122000, NA,
             122110, NA,
             123000, NA,
             123110, NA,
             124000, NA,
             124110, NA,
             125000, NA,
             125110, NA,
             126000, NA,
             126110, NA,
             130000, NA,
             130110, NA,
             141000, NA,
             142000, NA,
             150000, NA,
             150110, NA,
             160000, NA,
             211000, 211000,
             212000, 212000,
             220000, 220000,
             230000, NA,
             311000, 311000,
             312000, 312000,
             321000, 321000,
             321220, NA,
             322000, 322000,
             322220, NA,
             411000, 411000,
             412000, NA,
             420000, NA,
             800000, NA,
             999999, NA)

class_c_m <- matrix(class_c, ncol=2, byrow=TRUE)
basemap_reclass<- classify(basemap,class_c_m)

# create cropmap centroids (inside the plots)

cropmap$area=expanse(cropmap,unit="ha", transform=TRUE)
cropmap_centers=centroids(cropmap, inside=TRUE)
#writeVector(cropmap_centers, "O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/cropmap_centers.shp", overwrite=TRUE)

# calculate proportion of land use classes

key <- classes %>% dplyr::select(C_11, C_13) %>% distinct() %>% rename(value = C_11, habitat_type = C_13)
key$habitat_type <- tm::removeNumbers(as.character(key$habitat_type)) %>% str_trim()
key$value[23]<-0
key$habitat_type[23]<-"Other"

centers <- sf::st_as_sf(cropmap_centers)
centers$plotID=seq(1,dim(cropmap_centers)[1])

centers_buff=st_buffer(centers,2500)

crop_stat_df <- data.frame(matrix(ncol = 10, nrow = 0))
x <- c("plotID","area","PropAgrTemp","PropAgrPerm","PropAgrExt","PropFor","PropForwet",
       "PropNatdry","PropNatwet","PropLake")

colnames(crop_stat_df) <- x

start_time <- Sys.time()

for (i in 1:dim(centers_buff)[1]) {
  
  print(i)
  
  rast_extr=crop(basemap_reclass,centers_buff[i,])
  
  freq_df=as.data.frame(freq(rast_extr))
  allcells=ncell(rast_extr)
  
  freq_df$prophab=(freq_df$count/allcells)*100
  prop_class_wnames=merge(x=freq_df,y=key,by.x="value",by.y="value")
  
  plotID=centers_buff[i,]$plotID
  area=centers_buff[i,]$area
  PropAgrTemp=prop_class_wnames[prop_class_wnames$habitat_type=="Agriculture, intensive, temporary crops",4]
  PropAgrPerm=prop_class_wnames[prop_class_wnames$habitat_type=="Agriculture, intensive, permanent crops",4]
  PropAgrExt=prop_class_wnames[prop_class_wnames$habitat_type=="Agriculture, extensive",4]
  PropFor=prop_class_wnames[prop_class_wnames$habitat_type=="Forest",4]
  PropForwet=prop_class_wnames[prop_class_wnames$habitat_type=="Forest, wet",4]
  PropNatdry=prop_class_wnames[prop_class_wnames$habitat_type=="Nature, dry",4]
  PropNatwet=prop_class_wnames[prop_class_wnames$habitat_type=="Nature, wet",4]
  PropLake=prop_class_wnames[prop_class_wnames$habitat_type=="Lake",4]
  
  if (length(PropAgrTemp)==0) {PropAgrTemp=0} else {PropAgrTemp=PropAgrTemp}
  if (length(PropAgrPerm)==0) {PropAgrPerm=0} else {PropAgrPerm=PropAgrPerm}
  if (length(PropAgrExt)==0) {PropAgrExt=0} else {PropAgrExt=PropAgrExt}
  if (length(PropFor)==0) {PropFor=0} else {PropFor=PropFor}
  if (length(PropForwet)==0) {PropForwet=0} else {PropForwet=PropForwet}
  if (length(PropNatdry)==0) {PropNatdry=0} else {PropNatdry=PropNatdry}
  if (length(PropNatwet)==0) {PropNatwet=0} else {PropNatwet=PropNatwet}
  if (length(PropLake)==0) {PropLake=0} else {PropLake=PropLake}
  
  newline <- data.frame(t(c(plotID=plotID,area=area,
                            PropAgrTemp=PropAgrTemp,
                            PropAgrPerm=PropAgrPerm,
                            PropAgrExt=PropAgrExt,
                            PropFor=PropFor,
                            PropForwet=PropForwet,
                            PropNatdry=PropNatdry,
                            PropNatwet=PropNatwet,
                            PropLake=PropLake)))
  
  print(newline)
  
  crop_stat_df <- rbind(crop_stat_df, newline)
  
  gc()
  
}

end_time <- Sys.time()
print(end_time - start_time)

# export

names(crop_stat_df) <- c("plotID","area","Agriculture, intensive, temporary crops","Agriculture, intensive, permanent crops","Agriculture, extensive","Forest","Forest, wet",
       "Nature, dry","Nature, wet","Lake")

centers_merge=merge(x=crop_stat_df,y=centers,by.x="plotID",by.y="plotID")
centers_merge_shp=st_as_sf(centers_merge)

centers_merge_shp_wgs84=st_transform(centers_merge_shp,crs=4326)
st_write(centers_merge_shp_wgs84,paste0("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/output/CA_fields_stat.kml"),overwrite=TRUE)

write.csv(centers_merge,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/output/CA_fields_stat.csv")

