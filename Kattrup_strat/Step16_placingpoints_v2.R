library(raster)
library(rgdal)
library(sf)

library(GeoStratR)

source("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_code/justfastfield/Kattrup_strat/Random_Stratified_Min_Dist_mod.R")

kattrup=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Input_datasets/Kattrup_Vildnis_graense_jan2022.shp")

Level3a=stack("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/20220805/Manual_forestdry_assemb_qual_level3c.tif")
Level3b=stack("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/20220805/Manual_forestwet_assemb_qual_level3d.tif")

# cropping

crs(kattrup)=crs(Level3a)

Level3a_crop <- crop(Level3a,extent(kattrup))
Level3a_crop <- mask(Level3a_crop, kattrup)

Level3b_crop <- crop(Level3b,extent(kattrup))
Level3b_crop <- mask(Level3b_crop, kattrup)

# calc proportion

Level3a_crop_poly=rasterToPolygons(Level3a_crop, fun=NULL, n=4, na.rm=FALSE, digits=3, dissolve=TRUE)
Level3a_crop_poly_area=area(Level3a_crop_poly)
Level3a_crop_poly_area_df=as.data.frame(Level3a_crop_poly_area)
Level3a_crop_poly_area_df$prop=Level3a_crop_poly_area_df$Level3a_crop_poly_area/sum(Level3a_crop_poly_area_df$Level3a_crop_poly_area[1:20])*100
Level3a_crop_poly_area_df=Level3a_crop_poly_area_df[1:20,]
Level3a_crop_poly_area_df$class=c(1,2,3,4,5,11,12,13,14,15,21,22,23,24,25,31,32,33,34,35)
write.csv(Level3a_crop_poly_area_df,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/20220805/Level3c_crop_poly_area_df.csv")

Level3b_crop_poly=rasterToPolygons(Level3b_crop, fun=NULL, n=4, na.rm=FALSE, digits=3, dissolve=TRUE)
Level3b_crop_poly_area=area(Level3b_crop_poly)
Level3b_crop_poly_area_df=as.data.frame(Level3b_crop_poly_area)
Level3b_crop_poly_area_df$prop=Level3b_crop_poly_area_df$Level3b_crop_poly_area/sum(Level3b_crop_poly_area_df$Level3b_crop_poly_area[1:20])*100
Level3b_crop_poly_area_df=Level3b_crop_poly_area_df[1:20,]
Level3b_crop_poly_area_df$class=c(1,2,3,4,5,11,12,13,14,15,21,22,23,24,25,31,32,33,34,35)
write.csv(Level3b_crop_poly_area_df,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/20220805/Level3d_crop_poly_area_df.csv")

# place point 10 per class for whole region

Points_open_dry <- Random_Stratified_Min_Dist_mod(ClassRaster = Level3a,
                                                  MinDist = 10,
                                                  n = 10,
                                                  n_to_test = 1000)


Points_open_wet <- Random_Stratified_Min_Dist_mod(ClassRaster = Level3b,
                                                  MinDist = 10,
                                                  n = 10,
                                                  n_to_test = 1000)

# place points 10 per class for kattrup

Points_open_dry_kattrup <- Random_Stratified_Min_Dist_mod(ClassRaster = Level3a_crop,
                                                          MinDist = 10,
                                                          n = 10,
                                                          n_to_test = 1000)

Points_open_wet_kattrup <- Random_Stratified_Min_Dist_mod(ClassRaster = Level3b_crop,
                                                          MinDist = 10,
                                                          n = 10,
                                                          n_to_test = 1000)

# export

Export_Points(Points_open_dry,name="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/20220805/Level3c_forestdry_dist10_wreplace.shp")
Export_Points(Points_open_dry_kattrup,name="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/20220805/Level3c_forestdry_kattrup_dist10_wreplace.shp")

Export_Points(Points_open_wet,name="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/20220805/Level3d_forestwet_dist10_wreplace.shp")
Export_Points(Points_open_wet_kattrup,name="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Kattrup_Stratification/Results/20220805/Level3d_forestwet_kattrup_dist10_wreplace.shp")
