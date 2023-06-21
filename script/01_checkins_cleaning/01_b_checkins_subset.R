
# 从sdc/原始数据中获取大于2018-10-01的签到数据，截取其中的五个属性列。

#--------- initial -------
# setwd("~/weibo/17_checkins_cleaning/03_full_sample/")

library(tidyverse)
library(lubridate)
library(data.table)
library(gtools)

args <- commandArgs(trailingOnly=TRUE)
index1 <- args[1]
index2 <- args[2]

# -------- path -----------
idir <- "/sdc/Weibo/footprint_16M/data/04_parsed/"
idir_origin <- "/sdc/Weibo/footprint_16M/data/04_parsed_origin/"

odir <- "data/processed/01_checkins_cleaning/01_checkins_subset/"

# -------- main process ---------
filename <- list.files(idir) %>% mixedsort()
filename_origin <- list.files(idir_origin) %>% mixedsort()

for(i in index1:index2){
  
  # start time
  startime <- Sys.time()

  checkins <- 
    fread(paste0(idir, filename[i]), 
          select = c("userid", 
                     "created_at", 
                     "containerid", 
                     "city",
                     "bid")) %>%
    .[created_at >= ymd("2018-10-01")]
  
  checkins_origin <- 
    fread(paste0(idir_origin, filename_origin[i]),
          select = c("userid", 
                     "created_at", 
                     "containerid", 
                     "city",
                     "bid")) %>%
    .[created_at >= ymd("2018-10-01")]
  
  
  checkins_bind <- 
    rbind(checkins, checkins_origin)
    # unique(by = "bid")
  
  # save result
  name <- gsub(".csv.gz", "", filename[i])
  fwrite(checkins_bind, paste0(odir, name, "_subset.csv"))

  
  # print spending time
  endtime <- Sys.time()
  duration <- difftime(endtime, startime, units="secs")
  print(paste0(filename[i]," spending time: ", duration))
}










