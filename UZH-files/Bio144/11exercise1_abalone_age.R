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

glmdd <- glm(Rings ~ .,dd, family=poisson)
dropterm(glmdd, sorted = TRUE)
#removing length leads to highest decrease in AIC -> length is worst predictor

dt1 <- update(glmdd, .~.-Length_mm)
AICc(dt1)

dropterm(dt1, sorted=TRUE)
dt2 <- update(dt1, .~.-Shell_weight_g)
AICc(dt2)

dropterm(dt2, sorted=TRUE)
dt3 <- update(dt2, .~.-Height_mm)
AICc(dt3) #lowest AICc here: 1806.096

dropterm(dt3, sorted=TRUE)
dt4 <- update(dt3, .~.-Sex)
AICc(dt4)

dropterm(dt4, sorted=TRUE)
dt5 <- update(dt4, .~.-Viscera_weight_g)
AICc(dt5)

dropterm(dt5, sorted=TRUE)
dt6 <- update(dt5, .~.-Diameter_mm)
AICc(dt6)
#Increase larger than 4, take model before this

#check dispersion
summary(dt5)
164.40/396 #=0.4151515

#Comparison between glm and lm models. If both gave same estimates all the time, the points would be on the 1:1 line
#I added the colouring according to sex, because that explains the pattern of the two distinct lines in the lower area of the plot
lmdd <- lm(Rings ~ Sex + Diameter_mm + Whole_weight_g + Shuck_weight_g + Viscera_weight_g, data = dd)
comp <- cbind(dd,lm=fitted(lmdd),glm=fitted(dt5))
ggplot(data=comp, aes(x=glm,y=lm,col=Sex))+
  geom_point()+
  geom_abline(col='red')+
  theme_bw()

