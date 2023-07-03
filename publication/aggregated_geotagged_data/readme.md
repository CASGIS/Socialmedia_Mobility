# Percentage change in number of visits to six categories of palces across cities

## Data source
We collected 210 million geotagged posts uploaded by 10 million users from Weibo from 2019 to 2020. Weibo, the Chinese version of Twitter, is the most widely used social media platform in China (https://weibo.com).

## Data process
1. Referring to the classification criterion of categories in Google Community Mobility Report (https://www.google.com/covid19/mobility/), we classified POIs attached to geotagged posts into six categories of places by their social function.
2. Counting the daily visits to these categories of places for each cities.
3. Smoothing the daily visits by the method of 7-day moving average.
4. Calculating the percentage change by comparing visits to baseline days. The baseline days represent a normal value for that day of the week and are given as the median value over the period of the second half of 2019. 

## Data description
| Column | Description |
| ----------- | ----------- |
| ct_adcode | city code |
| city_ch | city name (Chinese) |
| city_en | city name (English) |
| pr_adcode | province code |
| pr_ch | province name (Chinese) |
| pr_en | province name (English) |
| created_at | date |
| category | six categories of places (*Residential, Workplaces, Retail & recreation, Parks, Transit stations, and Grocery & pharmacy*) |
| visits_7MA_percentage_change | percentage change in number of visits compared to baseline days |

## 


