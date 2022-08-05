library(ecospat)
library(raster)

CreateShape = function(data) {
  
  library(sp)
  
  data$X_obs=data$x
  data$Y_obs=data$y
  
  shp=data
  coordinates(shp)=~X_obs+Y_obs
  proj4string(shp)<- CRS("+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  
  return(shp)
  
}

Level3c=raster("G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/fromZsofia_Stratification/fromZsofia_Stratification/Results/202208week1/Strat_forest_dry_Level3c.tif")
Level3d=raster("G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/fromZsofia_Stratification/fromZsofia_Stratification/Results/202208week1/Strat_forest_wet_Level3d.tif")

# placing points

for_Level3c=Level3c+Level3c
for_Level3d=Level3d+Level3d

prop_Level3c <- ecospat.recstrat_prop(for_Level3c,100)
prop_Level3d <- ecospat.recstrat_prop(for_Level3d,100)

prop_Level3c_shp=CreateShape(prop_Level3c)
prop_Level3d_shp=CreateShape(prop_Level3d)

# export

shapefile(prop_Level3c_shp,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220804/simple/prop_Level3c.shp",overwrite=TRUE)
shapefile(prop_Level3d_shp,"G:/My Drive/_Aarhus/_PostDoc/Co_Authorproject/Kattrup/Results_20220804/simple/prop_Level3d.shp",overwrite=TRUE)
