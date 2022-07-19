library(sf)
library(raster)
library(tidyverse)
library(writexl)
library(readxl)

resultedfile=st_read("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/sinkplots_withbufferzones_v4_engmose.shp")
my_data <- read_excel("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_input_data/Samplet_au_sinks_2021/Samplet_au_sinks_2021/Seneste tilladelser 18.7.22.xlsx")

my_data_c=my_data[1:32,]

names(my_data_c)[5]<-"PunktID"

joined_sink=merge(resultedfile, my_data_c, by = "PunktID", all.x=TRUE, all.y=FALSE)

joined_sink_sel=joined_sink[,c(1,5,6,7,8,9,10,11,12,18)]

joined_sink_sel$`Tilladelse til besøg`[is.na(joined_sink_sel$`Tilladelse til besøg`)] <- 0

st_write(joined_sink_sel,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/sinkplots_withbufferzones_v4_engmose_withaccess2.shp")

