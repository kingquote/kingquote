rm(list=ls())
library(tidyverse)
library(ggfortify)
library(MASS)
library(MuMIn)
library(AICcmodavg)
library(readr)
options(na.action='na.fail')

dd <- read_csv("Studium/19FS/Bio144/Data/Lecture/abalone_age.csv")
#I would create a new column called age, which is rings+1.5, as that is the actual age, but that is not asked here

hist(dd$Rings, breaks=30)
#quite pointy, possibly skewed

lmdd <- lm(Rings ~ .,dd)
dropterm(lmdd, sorted = TRUE)
#removing length leads to highest decrease in AIC -> length is worst predictor

dt1 <- update(lmdd, .~.-Length_mm)
summary(lmdd)$adj.r.squared - summary(dt1)$adj.r.squared
AICc(dt1)

dropterm(dt1, sorted=TRUE)
dt2 <- update(dt1, .~.-Shell_weight_g)
AICc(dt2)

dropterm(dt2, sorted=TRUE)
dt3 <- update(dt2, .~.-Height_mm)
AICc(dt3)

dropterm(dt3, sorted=TRUE)
dt4 <- update(dt3, .~.-Viscera_weight_g)
AICc(dt4)
#the change in AICc is larger than 4 here, so the last model before this will be used, as indicated by task

forw <- stepAIC(lm(Rings~1,dd), direction = c("forward"), trace = FALSE,AICc=TRUE)
back <- stepAIC(lmdd, direction = c("backward"), trace = FALSE,AICc=TRUE)
both <- stepAIC(lmdd, direction = c("both"), trace = FALSE,AICc=TRUE)

mods <- list(full=lmdd, forw=forw, back=back, both=both, manual=dt3)
model.sel(mods)


stupid <- dredge(lmdd)
model.sel(get.models(stupid, subset=delta < 5))
