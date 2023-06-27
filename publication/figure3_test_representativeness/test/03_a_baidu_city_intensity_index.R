
# 根据BAIDU的CMI原数据，计算每个城市的相对访问量


# -------- initial --------
setwd("~/SMobility_paper_v2/02_data_validation/")
library(tidyverse)
library(lubridate)
library(zoo)
library(data.table)


# ------- path --------
ifile_CMI_city <- 
  "data/03_a_baidu_city_movement_intensity/City_Movement_Intensity_202001-202004.csv"

# ifile_city_adm <- 
#   "~/Administrative_division/ChinaAdminDivisonSHP/00_shp_datacleaning/01_city_adm_CMI_validation/city_adm_CMI_validation.shp"

odir_result <- 
  "result/" 


# ------- input data -------
CMI_city <-
  fread(ifile_CMI_city, header = T) %>%
  setnames("GbCity_EN", "city") %>%
  melt(id.vars = "city",
       variable.name = "date",
       value.name = "CMI") %>%
  .[, date := ymd(date)] %>%
  .[order(city, date)]


# ------- 7MA -------
CMI_city_7MA <-
  CMI_city[order(city, date)] %>%
  .[, CMI_7MA := rollmean(CMI, k = 7, fill = NA), by = .(city)]


# ------- relative -------
period_before_covid <-
  c(ymd("2020-01-01"):ymd("2020-01-19"))  # 官宣人传人之前作为基准值时间段

baseline_raw <-
  CMI_city_7MA[date %in% period_before_covid] %>%
  .[, .(baseline_raw = median(CMI, na.rm = T)), by = .(city)]

baseline_7MA <-
  CMI_city_7MA[date %in% period_before_covid] %>%
  .[, .(baseline_7MA = median(CMI_7MA, na.rm = T)), by = .(city)]

CMI_city_relative <- 
  merge(CMI_city_7MA,
        baseline_raw,
        all.x = T,
        by = "city") %>%
  merge(baseline_7MA,
        all.x = T,
        by = "city") %>%
  .[, CMI_relative := CMI/baseline_raw-1] %>%
  .[, CMI_7MA_relative := CMI_7MA/baseline_7MA-1]
  

# ------- save result -------
fwrite(CMI_city_relative,
       paste0(odir_result, "03_a_CMI_city_relative.csv"))



