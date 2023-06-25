
# 筛选2019-2020年的checkins,计算每一个poi地点的微博发文，连接poi对应的经纬度

# --------- initial -------
setwd("~/Socialmedia_Mobility/")
library(tidyverse)
library(data.table)
library(lubridate)

# ------- path -------
ifile_pois_lib <-
  "/sdc/Weibo/footprint_16M/data/05a_poi_merge/pois_20200531.Rds"

ifile_checkins <-
  "data/processed/01_checkins.csv.gz"

odir <- 
  "data/processed/"
  
# ------- input data -------
# 1036万
pois_lib <- 
  readRDS(ifile_pois_lib) %>%
  as.data.table() %>%
  .[!(is.na(lon) | is.na(lat)), ] %>%
  .[, .(poiid, lon, lat)]

# 2.35亿
checkins <- 
  fread(ifile_checkins, select = c(containerid = "character", 
                                   created_at = "Date",
                                   category_google = "character"))

# ------- main process -------
# 94万
checkins_lonlat <-
  checkins[created_at >= ymd("2019-01-01") & created_at <= ymd("2020-12-31"),
           .(checkins_num = .N), by = .(containerid, category_google)] %>%
  merge(pois_lib[, .(poiid, lon, lat)],
        by.x = "containerid",
        by.y = "poiid")


# ------ save result ------
fwrite(checkins_lonlat, paste0(odir, "02_checkins_link_lonlat.csv.gz"))

  
  
  
  
  
  
  
  
  
  







