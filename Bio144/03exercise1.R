rm(list=ls())
library(readr)
library(tidyverse)
library(skimr)
financing_healthcare <- read_csv("~/Studium/19FS/Bio144/Data/Lecture/financing_healthcare.csv")

#only interested in 2013, and looking at total spending as well as child mortality, so we don^t want NA there
healthcare <- filter(financing_healthcare,!is.na(health_exp_total)&!is.na(child_mort))
healthcare <- filter(healthcare,year==2013)

#see data
ggplot(healthcare,aes(x=health_exp_total,y=child_mort,colour=continent))+
  geom_point()+
  theme_bw()

#make it more linear (both axes have lots of low and few large values)
healthcare <- mutate(healthcare, log10spending = log10(health_exp_total))
healthcare <- mutate(healthcare, log10mort = log10(child_mort))

#view again
ggplot(healthcare,aes(x=log10spending,y=log10mort,colour=continent))+
  geom_point()+
  #xlim(0,5) +   #run with these for guess of intercept
  #ylim(0,4)+
  theme_bw()

#linear regression
linm <- lm(log10mort ~ log10spending, data=healthcare)

#check fit
autoplot(linm, smooth.colour=NA)

#check statistics
summary(linm)

#make nice plot
ggplot(healthcare, aes(x=log10spending, y=log10mort)) +
  geom_point(aes(colour=continent)) +
  geom_smooth(method = 'lm', colour='red') +
  xlab('Total health care spending per capita 2013 [log10(USD)]') +
  ylab('Child mortality per capita 2013 [log10(Nr of deaths under 5y)]') +
  theme_bw()

#make a graph with regression line on the raw axes
ggplot(data=healthcare, aes(x=health_exp_total, y=child_mort)) +
  geom_point() +
  geom_line(aes(y=10^predict(linm)), col="red")
