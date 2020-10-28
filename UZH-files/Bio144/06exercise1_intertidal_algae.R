rm(list=ls())
library(tidyverse)
library(ggfortify)
dd <- read_csv("~/Studium/19FS/Bio144/Data/Lecture/intertidalalgae.csv")
dd <- mutate(dd, height = as.factor(height), herbivores = as.factor(herbivores))

ggplot(dd, aes(Area_cm2)) +
  geom_histogram(bins=8) +
  facet_wrap(~height+herbivores)

#task asks for this:
dd <- mutate(dd, Area_cm = sqrt(Area_cm2))

ggplot(dd,aes(x=height, y=Area_cm, col=herbivores)) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2)) +
  theme_bw()

ddsum <- dd %>% group_by(height, herbivores) %>% summarise(mean=mean(Area_cm),sd=sd(Area_cm))
#ignore warning, jitterdodge needs a y, though errorbar doesn't
ggplot() +
  geom_point(data=dd, aes(x=height, y=Area_cm, col=herbivores), position=position_jitterdodge(jitter.width = 0)) +
  geom_point(data=ddsum, aes(x=height,y=mean,col=herbivores), shape = 2, size = 3,position=position_jitterdodge(jitter.width = 0)) +
  geom_errorbar(data=ddsum, aes(x=height, y=mean, ymin=mean-sd, ymax=mean+sd, col=herbivores), width=.2 ,position=position_jitterdodge(jitter.width = 0)) +
  theme_bw()

linm <- lm(Area_cm ~ height*herbivores, data=dd)
autoplot(linm)
anova(linm)

confint(linm)

summary(linm)



