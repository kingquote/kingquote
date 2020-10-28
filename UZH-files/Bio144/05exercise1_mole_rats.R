rm(list=ls())
library(tidyverse)
library(ggfortify)
library(GGally)
ratdata <- read_csv("Studium/19FS/Bio144/Data/Lecture/moleratlayabouts.csv")

#to find number of individuals in each caste
table(ratdata$caste)

#check distributions
ggplot(ratdata) +
  geom_histogram(mapping=aes(Energy), binwidth = 12)

ggplot(ratdata) +
  geom_histogram(mapping=aes(Mass), binwidth = 12)

#seems skewed, so log transform
ratdata <- mutate(ratdata, log10Mass = log10(Mass))
ratdata <- mutate(ratdata, log10Energy= log10(Energy))

#linear regression model
ratmodel <- lm(log10Energy ~ log10Mass * caste, ratdata)
autoplot(ratmodel) #looks good
summary(ratmodel)

#visualize result
ggplot(ratmodel, aes(x=log10Mass, y=log10Energy, color = caste)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  theme_bw()

#visualize regression model with only one slope: use predict as a workaround
ratmodel2 <- lm(log10Energy ~ log10Mass + caste, ratdata)

new_data <- expand.grid(log10Mass=seq(min(ratdata$log10Mass), max(ratdata$log10Mass), length=100), caste=unique(ratdata$caste))
p <- predict(ratmodel2, newdata=new_data, interval='confidence')
n <- cbind(new_data,p)
ggplot(n) +
  geom_smooth(mapping=aes(x = log10Mass, y = fit, ymin = lwr, ymax = upr, color = caste), stat = 'identity') +
  theme_bw()


  