rm(list=ls())
library(readr)
library(tidyverse)
library(skimr)
financing_healthcare <- read_csv("~/Studium/19FS/Bio144/Data/Lecture/financing_healthcare.csv")
skim(financing_healthcare)

length(unique(financing_healthcare$year))

healthcare <- filter(financing_healthcare,!is.na(health_exp_total)&!is.na(child_mort))
healthcare <- filter(healthcare,year==2013)
healthcare <- select(healthcare,year, country, continent, health_exp_total, child_mort, life_expectancy)
healthcare <- drop_na(healthcare)

summarise(group_by(healthcare,continent),mean=mean(child_mort),sd(child_mort))

ggplot(healthcare,aes(x=continent,y=child_mort))+
  geom_boxplot()+
  theme_bw()

ggplot(healthcare,aes(x=health_exp_total,y=child_mort,colour=continent))+
  geom_point()+
  theme_bw()

ggplot(healthcare,aes(x=health_exp_total,y=child_mort))+
  geom_point()+
  facet_wrap(~continent,scales='free')+
  theme_bw()
