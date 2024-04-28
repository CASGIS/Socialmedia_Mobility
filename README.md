# Social media Mobility
This repository provides the data and R code that accompanies the article: Zhu, Cheng & Wang (2024). Please do cite this paper if using the data or codes.

Zhu, K., Cheng, Z. & Wang, J. Measuring Chinese mobility behaviour during COVID-19 using geotagged social media data. Humanit Soc Sci Commun 11, 540 (2024). https://doi.org/10.1057/s41599-024-03050-0

If you have questions or suggestions, please contact Jianghao Wang at wangjh@lreis.ac.cn

## Structure of this repostitory
The folder `publication` contains the R code to reproducing the main results.  
The folder `publication/geotagged_data` contains the geotagged social data to support the findings of the research.  
More details about the geotagged social media are available at https://casgis.github.io/Socialmedia_Mobility/

## Computational requirement
* R-studio with R >= 4.3.0
* Packages
  * Data manipulation: tidyverse, data.table, lubridate, scales, zoo, janitor
  * Spatial data: sf, raster
  * Plots: RcolorBrewer, ggspatial, ggrepel, ggtext, ggdist, grid, lemon, cowplot, patchwork