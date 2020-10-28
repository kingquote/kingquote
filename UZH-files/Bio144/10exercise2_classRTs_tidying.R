rm(list=ls())
library(tidyverse)

dd <- read_csv("Studium/19FS/Bio144/Data/classRTs.csv")
names(dd) <- c("Time", "ID", "Sex", "RT_main_1", "verbal", "number", "visual", "weight", "handedness", "RT_off_avg", "RT_main_2", "RT_main_3", "RT_main_4", "RT_main_5", "RT_main_avg", "rand")
dd <- select(dd, ID, Sex, RT_main_1, RT_main_2, RT_main_3, RT_main_4, RT_main_5)

dd <- gather(dd, key=Measurement, value=RT, c(RT_main_1, RT_main_2, RT_main_3, RT_main_4, RT_main_5))

