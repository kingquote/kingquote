rm(list=ls())
library(readr)
library(tidyverse)
library(skimr)
library(GGally)
bodyfat <- read_table2("Studium/19FS/Bio144/Data/Lecture/bodyfat.txt")

ggplot(bodyfat,aes(x=bodyfat))+
  geom_histogram()

filter(bodyfat,bodyfat>35)

select(tail(arrange(bodyfat,bodyfat),1),bmi)

ggplot(bodyfat,aes(x=height))+
  geom_histogram()

bodyfat <- mutate(bodyfat,my_bmi=(gewicht/((hoehe/100)**2)))
bodyfat

head(arrange(bodyfat,height))

bodyfat_c <- filter(bodyfat, !(Nr %in% c(1, 2, 3, 4, 5, 6)))
ggpairs(bodyfat)
