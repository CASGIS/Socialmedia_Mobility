
## 去除国外的定位签到, 去除港澳台定位的签到
## 连接category_name和category_google


library(tidyverse)
library(data.table)
library(sf)

# --------------------- file path ---------------------
ifile_checkins <-
  "data/processed/01_checkins_cleaning/02_checkins_subset_merge.csv"

###
ifile_city_adm <-
  "~/Administrative_division/adm_for_join/result/01_adm_for_join.csv"

ifile_poilib <- 
  "~/weibo/03_POIs/data/poi_20200531_20211225_1110W_preprocess.rds"

ifile_pois_classify <-
  "~/weibo/03_POIs/data/pois_weibo_classify_v2.csv"
###

odir <-
  "data/processed/01_checkins_cleaning/"


# --------------------- file input ---------------------
checkins <-
  fread(ifile_checkins,
        nThread = 12)

city_adm <-
  fread(ifile_city_adm)

poilib <- 
  readRDS(ifile_poilib) %>% 
  as.data.table(key = "poiid") %>%
  .[, .(poiid, category_name)]

pois_classify <-
  fread(ifile_pois_classify) %>%
  .[, .(category_name, category_google)]


# --------------------- main process ---------------------
checkins_filter <-
  checkins[city_adm$city_join, on = "city", nomatch = 0] %>%
  .[(city!= "香港") & (city != "澳门") & (city != "台湾")]

pois_category <-
  merge(poilib,
        pois_classify,
        all.x = T,
        by = "category_name")

checkins_result <-
  merge(checkins_filter,
        pois_category,
        all.x = T,
        by.x = "containerid",
        by.y = "poiid")


# --------------------- save result ---------------------
fwrite(checkins_result,
       paste0(odir, "03_checkins.csv.gz"))






















