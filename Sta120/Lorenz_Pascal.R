rm(list=ls())

library(tidyverse)
library(ggfortify)
library(GGally)
library(MASS)
library(AICcmodavg)
library(dae)

#Problem 6
#a)
dd6 <- read.csv("~/Studium/19FS/Sta120/Data/happy.csv")
#View(dd6)    commented to save space on markdown
ggpairs(dd6)
#b)
lmdd6 <- lm(happy ~ work+love+sex+money, data=dd6)
#c)
autoplot(lmdd6)
#Not perfectly satisfying, but good enough in my opinion. The worst one is Scale-Location.
#the Q-Q-plot shows very nice normal distribution of residuals though.
#d)
summary(lmdd6)
#apparently, love is a good predictor of happiness, it shows a strong positive correlation (slope about 2). Sex seems to be an exeptionally bad predictor, sporting a p-value of 0.72. Work shows weak significance.
#e)
lmddAIC6 <- stepAIC(lmdd6, direction = c("both"), trace = FALSE,AICc=TRUE)
#First of all, it is important to note, that using automated model selection is only really viable for predictive models, not explanatory ones.
summary(lmddAIC6)
#This supports a removal of sex from the model, but no more than that. Money almost crosses the arbitrary border of significance, so it makes sense to leave it in.
#f)
#Sex is a good candidate for a factor variable, since each datapoint can only belong to one of the two groups. sex, work and possibly even happiness can only belong into few groups too, but since there, the number actually has a meaning, since it is scaled, I would not turn those into factors.

#Problem 7
#a)
mu <- matrix(c(1,2),nrow=2)
Sigma <- array(c(1,2,2,4), c(2,2))
sample <- rmvnorm( 800, sigma=Sigma)
plot(sample, pch='.', xlab='', ylab='')
#b)
require( ellipse)
n <- 800
mu <- c(1,2)
Sigma <- matrix( c(1,2,2,4), 2)
  plot(ellipse( Sigma, cent=mu, level=.95), col='gray',
       xaxs='i', yaxs='i', type='l')
  lines( ellipse( Sigma, cent=mu, level=.5), col='gray')
  sample <- rmvnorm( n, mean=mu, sigma=Sigma)
  points(sample, pch='.', cex=2)
  Sigmahat <- cov( sample)
  muhat <- apply( sample, 2, mean)
  lines( ellipse( Sigmahat, cent=muhat, level=.95), col=2, lwd=2)
  lines( ellipse( Sigmahat, cent=muhat, level=.5), col=4, lwd=2)
  points( rbind( muhat), col=3, cex=2)
  text(-2,4, paste('n =',n))
#c)


#Problem 8
#a)
sleep <- read.csv("~/Studium/19FS/Sta120/Data/sleep.csv")
str(sleep)
delta <- with(sleep, extra[group == 1] - extra[group == 2])
# EDA
par(mfrow = c(1, 2))
hist(delta, breaks = 8, main = "Histogram of Differences")
lines(density(delta))
boxplot(sleep$extra ~ sleep$group, names = c("group1", "group2"),
        ylab = "extra", main = "Boxplots")
#We assume the increased hours of sleep in both groups are normally distributed and each observation is indepedent within each group. Since there are 10 patients with each received drug 1 (group 1) and durg 2 (group 2), we choose to use two-sample t-test. From the EDA, it is also justified to avoid the normality assumption since the boxplots shows both distributions are slightly skewed.

#b)
with(sleep, t.test(extra[group == 1], extra[group == 2], paired = TRUE))
#Based on the p-value of 0.002833, we reject the null hypothesis at 5% significance level, that two drugs have the same increased hours of sleep, therefore the drugs are not equally effective.

#Problem 9
