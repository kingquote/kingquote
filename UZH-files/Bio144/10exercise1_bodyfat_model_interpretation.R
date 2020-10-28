rm(list=ls())
library(readr)
library(tidyverse)
library(skimr)
library(GGally)
dd <- read_table2("Studium/19FS/Bio144/Data/Lecture/bodyfat.txt")

#models as specified:
lmadd <- lm(bodyfat~abdomen, dd)
lmwdd <- lm(bodyfat~weight, dd)
lmawdd <- lm(bodyfat~abdomen+weight, dd)

#compare r-squared:
summary(lmawdd)$r.squared
summary(lmwdd)$r.squared
summary(lmadd)$r.squared
#both: 0.72, weight: 0,38, abdomen: 0.66
#unique to abdomen: 0.72-0.38=0.34
#unique to weight: 0.72-0.66=0.06
#shared by both: 0.72-0.34-0.06=0.32

#significance of units? -> convert pounds to kg and compare models
dd <- mutate(dd, weightkg=0.45*weight)
lmkgdd <- lm(bodyfat~abdomen+weightkg, dd)
summary(lmawdd)
summary(lmkgdd)
#ratio of slopes: (-0.14800)/(-0.32890)=0.4499848

#to be able to compare slopes: scale variables
dd <- mutate(dd, scaledweight=scale(weight), scaledabdomen=scale(abdomen))
lmscaleddd <- lm(bodyfat~scaledabdomen+scaledweight, dd)
summary(lmscaleddd)
summary(lmawdd)