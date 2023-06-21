
#!/bin/sh

# path
###
cd ~/Socialmedia_Mobility/data/processed/01_checkins_cleaning/


# 以下无需改动
head -1 01_checkins_subset/user_active_m_s112_subset.csv > 02_checkins_subset_merge.csv
for f in 01_checkins_subset/*.csv
do
    tail -n +2 "$f";
    # printf "\n";
done >> 02_checkins_subset_merge.csv