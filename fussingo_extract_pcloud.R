library(lidR)
library(rgdal)

# import

study_area=readOGR(dsn="O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/fussingo_forlidar.shp")

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/PointClouds/")

ctg <- readLAScatalog("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/fussingo/PointClouds/DHM2018plus/")

clipped=clip_rectangle(ctg,549765.8,6258048,552993.4,6260929)

writeLAS(clipped,"Fussingo.laz")