rm(list=ls())
library(tidyverse)
library(GGally)
milk <- read_csv("Studium/19FS/Bio144/Data/Lecture/milk_rethinking.csv")

ggplot(milk)+
  geom_histogram(mapping=aes(x=kcal.per.g),bins=6)

ggplot(milk)+
  geom_histogram(mapping=aes(x=mass),bins=6)

ggplot(milk)+
  geom_histogram(mapping=aes(x=neocortex.perc),bins=6)

ggpairs(select(milk,kcal.per.g,mass,neocortex.perc))

model <- lm(kcal.per.g ~ neocortex.perc + mass, milk)
autoplot(model)
summary(model)

new_data1 <- expand.grid(mass = seq(min(milk$mass), max(milk$mass), length=100), neocortex.perc = mean(milk$neocortex.perc))
p1 <- predict(model, newdata=new_data1, interval='confidence')
n1 <- cbind(new_data1,p1)
ggplot(n1) +
  geom_smooth(mapping=aes(x = mass, y = fit, ymin = lwr, ymax = upr), stat = 'identity')

new_data2 <- expand.grid(neocortex.perc = seq(min(milk$neocortex.perc), max(milk$neocortex.perc), length=200), mass = mean(milk$mass))
p2 <- predict(model, newdata=new_data2, interval='confidence')
n2 <- cbind(new_data2,p2)
ggplot(n2) +
  geom_smooth(mapping=aes(x = neocortex.perc, y = fit, ymin = lwr, ymax = upr), stat = 'identity')



r1 <- rnorm(17)
model2 <- lm(kcal.per.g ~ neocortex.perc + mass + r1, milk)
summary(model2)
