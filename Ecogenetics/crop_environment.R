library(terra)
library(foreign)
library(tidyverse)
library(tm)
library(sf)
library(landscapemetrics)

library(cluster)  
library(factoextra)

fncols <- function(data, cname) {
  add <-cname[!cname%in%names(data)]
  
  if(length(add)!=0) data[add] <- 0
  data
}

# import

cropmap=vect("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/_inputdata/Markblokke.shp")
cropmap_centers=vect("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/cropmap_centers.shp")
basemap=rast("O:/Nat_Sustain-proj/_user/HanneNicolaisen_au704629/Data/Land_cover_maps/Basemap/Basemap03_public_geotiff/basemap03_2011_2016_2018/lu_agg_2018.tif")
classes <- read.dbf("O:/Nat_Sustain-proj/_user/HanneNicolaisen_au704629/Data/Land_cover_maps/Basemap/Basemap03_public_geotiff/basemap03_2018/lu_00_2018.tif.vat.dbf")
areaofint=vect("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/CA_plots_nov2022.shp")
  
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
#writeRaster(basemap_reclass,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/Basemap_reclass.tif")

# create cropmap centroids (inside the plots)

#cropmap$area=expanse(cropmap,unit="ha", transform=TRUE)
#cropmap_centers=centroids(cropmap, inside=TRUE)
#writeVector(cropmap_centers, "O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/cropmap_centers.shp", overwrite=TRUE)

key <- classes %>% dplyr::select(C_11, C_13) %>% distinct() %>% rename(value = C_11, habitat_type = C_13)
key$habitat_type <- tm::removeNumbers(as.character(key$habitat_type)) %>% str_trim()
key$value[23]<-0
key$habitat_type[23]<-"Other"

centers <- sf::st_as_sf(cropmap_centers)
centers$plotID=seq(1,dim(cropmap_centers)[1])

# reduce for area of interests

aoi=buffer(areaofint,width=5000)

CAplot_stat_df <- data.frame(matrix(ncol = 19, nrow = 0))
x <- c("plotID","Name","descriptio","timestamp","begin","end","altitudeMo","tessellate","extrude","visibility","drawOrder","icon","Agriculture, intensive, permanent crops",
       "Agriculture, intensive, temporary crops","Forest","Forest, wet","Lake","Nature, dry","Nature, wet")

colnames(CAplot_stat_df) <- x

# calc stat for the CA plots

for (i in 1:length(aoi)) { 
  
  basemap_reclass_crop=crop(basemap_reclass,aoi[i])
  
  aoi_sf <- sf::st_as_sf(aoi[i])
  aoi_sf$plotID=i
  
  # calculate proportion of land use classes
  
  start_time <- Sys.time()
  
  prop_classes_CAfield=sample_lsm(basemap_reclass_crop, y = aoi_sf, size = 2500,plot_id=i, what = "lsm_c_pland",all_classes = TRUE)
  
  end_time <- Sys.time()
  print(end_time - start_time)
  
  prop_classess_wnames_CAfield=merge(x=prop_classes_CAfield,y=key,by.x="class",by.y="value")
  
  prop_classess_wnames_CAfield$value[is.na(prop_classess_wnames_CAfield$value)]=0
  prop_classess_wnames_CAfield_sel=prop_classess_wnames_CAfield[c(7,6,9)]
  
  prop_classess_wnames_CAfield_sel_t=prop_classess_wnames_CAfield_sel %>% 
    spread(habitat_type, value) 
  
  aoi_sf_all <- sf::st_as_sf(aoi)
  aoi_sf_all$plotID=seq(1,dim(aoi_sf_all)[1])
  
  centers_merge_CAfield=merge(x=aoi_sf_all,y=prop_classess_wnames_CAfield_sel_t,by.x="plotID",by.y="plot_id")
  
  centers_merge_CAfield_all=fncols(centers_merge_CAfield, c("Agriculture, intensive, permanent crops","Agriculture, intensive, temporary crops","Forest","Forest, wet","Lake","Nature, dry","Nature, wet"))
  #print(centers_merge_CAfield_all)
  
  newline <- data.frame(t(c(plotID=centers_merge_CAfield_all$plotID,
                            Name=centers_merge_CAfield_all$Name,
                            descriptio=centers_merge_CAfield_all$descriptio,
                            timestamp=centers_merge_CAfield_all$timestamp,
                            begin=centers_merge_CAfield_all$begin,
                            end=centers_merge_CAfield_all$end,
                            altitudeMo=centers_merge_CAfield_all$altitudeMo,
                            tessellate=centers_merge_CAfield_all$tessellate,
                            extrude=centers_merge_CAfield_all$extrude,
                            visibility=centers_merge_CAfield_all$visibility,
                            drawOrder=centers_merge_CAfield_all$drawOrder,
                            icon=centers_merge_CAfield_all$icon,
                            `Agriculture, intensive, permanent crops`=centers_merge_CAfield_all$`Agriculture, intensive, permanent crops`,
                            `Agriculture, intensive, temporary crops`=centers_merge_CAfield_all$`Agriculture, intensive, temporary crops`,
                            Forest=centers_merge_CAfield_all$Forest,
                            `Forest, wet`=centers_merge_CAfield_all$`Forest, wet`,
                            Lake=centers_merge_CAfield_all$Lake,
                            `Nature, dry`=centers_merge_CAfield_all$`Nature, dry`,
                            `Nature, wet`=centers_merge_CAfield_all$`Nature, wet`)))
  
  #print(newline)
  
  CAplot_stat_df <- rbind(CAplot_stat_df, newline)
  
  gc()
  
}

areaofint_sf <- sf::st_as_sf(areaofint)

CAfield_wcoord=merge(x=areaofint_sf[c(1,12)],y=CAplot_stat_df,by.x="Name",by.y="Name")
CAfield_wcoord_shp=st_as_sf(CAfield_wcoord,wkt = "geometry")

#add area
cropmap$area=expanse(cropmap,unit="ha", transform=TRUE)
cropmap_sf <- sf::st_as_sf(cropmap)

CAfield_wcoord_shp_intersect=st_intersection(CAfield_wcoord_shp,cropmap_sf)

CAfield_wcoord_shp_wgs84=st_transform(CAfield_wcoord_shp_intersect[c(2,20:29,13:19,30)],crs=4326)
st_write(CAfield_wcoord_shp_wgs84,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/output_2022oct/CAfield_wcoord_shp_wgs84.kml")
write.csv(CAfield_wcoord_shp_wgs84,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/output_2022oct/CAfield_wcoord_shp_wgs84.csv")

# calc stat for fields in surroundings

for (i in 153:length(aoi)) { 
  
  print(i)
  
  basemap_reclass_crop=crop(basemap_reclass,aoi[i])
  centers_crop=crop(vect(centers),aoi[i])
  
  centers_crop_sf <- sf::st_as_sf(centers_crop)
  
  # calculate proportion of land use classes
  
  start_time <- Sys.time()
  
  prop_classes=sample_lsm(basemap_reclass_crop, y = centers_crop_sf, size = 2500,plot_id=centers_crop_sf$plotID, what = "lsm_c_pland",all_classes = TRUE)
  
  end_time <- Sys.time()
  print(end_time - start_time)
  
  # organize data frames
  
  prop_classess_wnames=merge(x=prop_classes,y=key,by.x="class",by.y="value")
  prop_classess_wnames$value[is.na(prop_classess_wnames$value)]=0
  prop_classess_wnames_sel=prop_classess_wnames[c(7,6,9)]
  
  prop_classess_wnames_sel_t=prop_classess_wnames_sel %>% 
    spread(habitat_type, value) 
  
  centers_merge=merge(x=centers_crop_sf,y=prop_classess_wnames_sel_t,by.x="plotID",by.y="plot_id")
  centers_merge_shp=st_as_sf(centers_merge,wkt = "geometry")
  
  # export
  
  # remove points close to the CA field
  
  aoi2=buffer(areaofint[i],width=-2500)
  centers_sel=centers_merge_shp[st_as_sf(aoi2), op = st_disjoint]
  
  centers_sel_wgs84=st_transform(centers_sel,crs=4326)
  st_write(centers_sel_wgs84,paste0("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/output_2022oct/",i,"_centers_envprop_2500m_donut.kml"))
  
  write.csv(centers_sel_wgs84,paste0("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/output_2022oct/",i,"_centers_envprop_2500m_donut.csv"))
  
}


















