
# 批量运行R文件

#--------- initial -------
library(tidyverse)
parallel <- TRUE

# -------- parallel setting --------
cluster_num <- 8

if(parallel){
  library(foreach)
  library(doSNOW)
  cl <- makeCluster(cluster_num)
  registerDoSNOW(cl)
}

# -------- path --------
###
ifile_rscript <- "script/01_checkins_cleaning/01_b_checkins_subset.R"

# -------- main process ----------
fileindex <- c(1, 8,
               9, 25,
               26, 50,
               51, 100,
               101, 194,
               195, 205,
               206, 240,
               241, 306)

foreach(i = 1:cluster_num) %dopar% {
  system(paste0('Rscript ', ifile_rscript, ' ', fileindex[2*i-1], ' ', fileindex[2*i]))
}

# -------- stop parallel ------
stopCluster(cl)





