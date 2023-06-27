# --------------------------------------------------------------
# purpose       : 计算各城市每日出行人数(category_google除了residential其他都算)
# details       : 
# reference     : 
# producer      : Kaixin
# address       : 
# date          : 2023-03-13
# readme        : 
# --------------------------------------------------------------

#--------- initial -------
setwd("/home/kaixin/SMobility_paper_v2/02_data_validation/")
library(tidyverse)
library(lubridate)
library(data.table)
library(zoo)
options(max.print = 50)


# -------- path -----------
ifile_checkins <- 
  "~/weibo/17_checkins_cleaning/03_full_sample/data/06_checkins_filter.csv.gz"

odir_result <- 
  "result/"


# -------- inpout data -------
checkins <- 
  fread(ifile_checkins, nThread = 14) %>%
  .[, .(created_at, userid, city, category_google)]

checkins <-
  checkins[category_google != "" & category_google != "Others" & category_google != "Education" & category_google != "Residential"]


# -------- daily_usercount ---------
# 某用户某天内只要在non-residential上进行打卡，即为当天的出行用户
period_focus <- c(ymd("2020-01-01"):ymd("2020-05-02"))
period_before_covid <- c(ymd("2020-01-01"):ymd("2020-01-19"))

daily_usercount_travel <-
  checkins[created_at %in% period_focus] %>%
  .[, .(usercount = uniqueN(userid)), by = .(created_at, city)] %>%
  # 7 days moving average
  .[order(city, created_at)] %>%
  .[, usercount_7MA := rollmean(usercount, k = 7, fill = NA), by = .(city)]


# baseline
baseline_raw <-
  daily_usercount_travel[created_at %in% period_before_covid] %>%
  .[, .(baseline_raw = median(usercount, na.rm = T)), by = .(city)]

baseline_7MA <-
  daily_usercount_travel[created_at %in% period_before_covid] %>%
  .[, .(baseline_7MA = median(usercount_7MA, na.rm = T)), by = .(city)]


# relative
daily_usercount_travel_relative <-
  merge(daily_usercount_travel,
        baseline_raw,
        all.x = T,
        by = "city") %>%
  merge(baseline_7MA,
        all.x = T,
        by = "city") %>%
  .[, usercount_relative := usercount/baseline_raw-1] %>%
  .[, usercount_7MA_relative := usercount_7MA/baseline_7MA-1]


# -------- city_postcount_ranking ---------
# 筛选checkins数量前列的城市
city_postcount_ranking <- 
  # checkins[created_at %in% period_focus] %>%
  checkins %>%
  .[, .(postcount = .N), by = .(city)] %>%
  .[, postcount_prop := postcount/sum(postcount, na.rm = T)] %>%
  .[order(-postcount_prop)]


# -------- save result --------
# fwrite(daily_usercount_travel_relative,
#        paste0(odir_result, "03_b_daily_usercount_travel_relative.csv"))

fwrite(city_postcount_ranking, 
       paste0(odir_result, "03_b_city_postcount_ranking.csv"))













