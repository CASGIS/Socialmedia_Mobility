
# 归并整理文件，得到一个省份，省份拼音，省份拼音缩写，省份所属地域的表格文件
# 为后续和usercount_city_level文件连接做准备

# --------- initial -------
setwd("~/SMobility_paper_v2/02_data_validation/")

library(tidyverse)
library(lubridate)
library(data.table)
library(sf)


# ------- path -------
# ifile_adm_city_pr <- 
#   "~/Administrative_division/ChinaAdminDivisonSHP/00_shp_datacleaning/01_city_adm_CMI_validation/city_adm_CMI_validation.shp"

ifile_adm_city_pr <-
  "~/Administrative_division/adm_for_join/result/01_adm_for_join.csv"

ifile_adm1 <-
  "/sdd/gadm/boundary/adm1.shp"

ifile_pr_abbre <-
  "data/01_b_province_abbre.csv"

ifile_pr_region <-
  "data/01_b_province_region.csv"

odir_result <-
  "result/"

# ------- input data ------
# adm_city_pr <- 
#   st_read(ifile_adm_city_pr, quiet = T) %>%
#   as.data.table() %>%
#   .[, .(city_name, pr = pr_name)]

adm_city_pr <-
  fread(ifile_adm_city_pr) %>%
  .[, .(city_join, pr = pr_name)]
  
adm1 <-
  st_read(ifile_adm1, quiet = T) %>%
  as.data.table() %>%
  .[NAME_0 == "China", .(pr_name = NL_NAME_1, pr_pinyin = NAME_1)]

pr_abbre <-
  fread(ifile_pr_abbre) %>%
  .[, .(pr, abbreviation)]

pr_region <- 
  fread(ifile_pr_region)


# ------- main process ------
# 增加一列pr_name,用以join连接
adm_city_pr %>%
  .[, pr_name := str_replace(pr, "市$", "")] %>%
  .[str_detect(pr, "省$"), pr_name := str_replace(pr, "省$", "")]

# 修改pr_name列
adm1 %>%
  .[, pr_name := str_replace(pr_name, "^(\\w)*\\|", "")] %>%
  .[pr_pinyin == "Heilongjiang", pr_name := "黑龙江"]

# 得到每一个省份对应的拼音
adm_city_pr_pinyin <-
  merge(adm_city_pr, 
        adm1, 
        all.x = T, 
        by = "pr_name")

# 连接省份拼音缩写，连接省份对应地区
adm_city_pr_pinyin_join <-
  merge(adm_city_pr_pinyin,
        pr_abbre,
        all.x = T,
        by = c("pr")) %>%
  merge(pr_region,
        all.x = T,
        by = c("pr"))


# ------- save_result ------
# fwrite(adm_city_pr_pinyin_join,
#        paste0(odir_result, "01_b_province_info.csv"))
















