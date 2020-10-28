rm(list=ls())
library(tidyverse)
library(ggfortify)
raw <- read_csv("~/Studium/19FS/Bio144/Data/Lecture/rugged.csv")
dd <- select(raw, rugged, rgdppc_2000, cont_africa,country)

hist(dd$rgdppc_2000, breaks = 20)
dd <- mutate(dd, loggdp = log10(rgdppc_2000))
hist(dd$loggdp, breaks = 20)
dd <- mutate(dd, cont_africa = factor(ifelse(cont_africa==1,'Africa','not Africa')))

table(dd$cont_africa)

hist(dd$rugged, breaks=20)

which(dd[order(-dd$rugged),]$country=='Switzerland', arr.ind=T)

table(filter(dd, is.na(rgdppc_2000))$cont_africa)

dd <- na.omit(dd)

ggplot(dd, aes(x=rugged,y=loggdp,col=cont_africa)) +
  geom_point() +
  theme_bw()

mod <- lm(loggdp ~ rugged*cont_africa,dd)
autoplot(mod)
summary(mod)
anova(mod)

new_data1 <- expand.grid(rugged = seq(min(dd$rugged), max(dd$rugged), length=100), cont_africa = 'Africa')
new_data2 <- expand.grid(rugged = seq(min(dd$rugged), max(dd$rugged), length=100), cont_africa = 'not Africa')

p1 <- predict(mod, newdata=new_data1, interval='confidence')
p2 <- predict(mod, newdata=new_data2, interval='confidence')

n1 <- cbind(new_data1,p1)
n2 <- cbind(new_data2,p2)

new <- rbind(n1,n2)

ggplot(new) +
  geom_smooth(mapping=aes(x = rugged, y = fit, ymin = lwr, ymax = upr, col=cont_africa, fill=cont_africa), stat = 'identity') +
  theme_bw()