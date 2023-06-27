# --------------------------------------------------------------
# purpose       : 
# details       : 根据2019-2020签到数据，统计提取每个城市的用户数
#                 (checkins上打卡的用户)
# reference     : 
# producer      : Kaixin
# address       : 
# date          : 2023-3-13
# readme        : 
# --------------------------------------------------------------

# --------- initial -------
setwd("~/SMobility_paper_v2/02_data_validation/")

library(tidyverse)
library(lubridate)
library(data.table)
options(datatable.print.topn = 20)

# ------- path -------
ifile_checkins <- 
  "~/weibo/17_checkins_cleaning/03_full_sample/data/06_checkins_filter.csv.gz"

odir_result <- 
  "result/"

# ------- input data ------
checkins <- 
  fread(ifile_checkins, 
        select = c(userid = "character", 
                   created_at = "Date", 
                   city = "character")) %>%
  .[year(created_at) == 2019 | year(created_at) == 2020]

# ------- main process -------
usercount <-
  checkins[, .(usercount = uniqueN(userid)), by = "city"]

# ------- save result -------
fwrite(usercount, paste0(odir_result, "01_a_usercount_city_level.csv"))