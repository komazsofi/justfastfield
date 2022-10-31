library(terra)

cropmap=vect("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/_inputdata/Markblokke.shp")
cropmap$area=expanse(cropmap,unit="ha", transform=TRUE)

writeVector(cropmap,"O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/_inputdata/Markblokke_warea.shp")
