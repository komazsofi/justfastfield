library(openxlsx)

setwd("O:/Nat_Sustain-proj/_user/ZsofiaKoma_au700510/Justquick_fielddata/_Ecogenetics_crop/output/")

filelist=list.files(pattern="*.csv")

for (i in 1:length(filelist)) {
  
  data=read.csv(filelist[i],row.names=NULL,header=FALSE)
  
  data_2=data[,c(2:19)]
  
  data_c_df=data_2[-1,]
  names(data_c_df)<-as.character(unlist(data_2[1,]))
  
  write.xlsx(data_c_df, paste0(substr(filelist[i],1,nchar(filelist[i])-3),".xlsx"),overwrite = TRUE)
  
}