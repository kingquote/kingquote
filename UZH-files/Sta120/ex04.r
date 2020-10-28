rm(list=ls())
library(tidyverse)
library(gmodels)
#8a)
#Same mean, sigma=sigma/sqrt(n)
#b)
#This is basically a two-sided t-test, and 1.96 corresponds to the 97.5 percentile. Since this is two-sided, P is actually 95% though.
#c)
#Bl = -((q*sigma/sqrt(n))-X) = X - q*sigma/sqrt(n)    (the X's are X(quer))
#Bu = -((-q*sigma/sqrt(n))-X) = X + q*sigma/sqrt(n)   (the X's are X(quer))
#d)
#same as above, but replace X by x
#e)
#The width of a CI is the difference between its bounds, and is influenced by sigma, n and of course what confidence you want the interval to have.
#f)
load("~/Studium/19FS/Sta120/Data/04sickle.RData")
sd <- 1
n <- length(HbSb)
mu <- mean(HbSb)
error <- qnorm(0.95)*sd/sqrt(n)
lower <- mu - error 
upper <- mu + error
CIa.HbSb <- c(lower,upper)
CIa.HbSb

n <- length(HbSS)
mu <- mean(HbSS)
error <- qnorm(0.95)*sd/sqrt(n)
lower <- mu - error 
upper <- mu + error
CIa.HbSS <- c(lower,upper)
CIa.HbSS

#9a)
#t(n-1)
#b)
#I am super confused by the missing sqrt(n), which makes it so I cant just work with a t-distribution, but I can't solve it algebraically in R either.
#c)
#Bl = X - 1.96*sigma/sqrt(n)
#Bu = X + 1.96*sigma/sqrt(n)
#d)
CIb.HbSb <- ci(HbSb, confidence = 0.9)[1:2]
CIb.HbSb
CIb.HbSS <- ci(HbSS, confidence = 0.9)[1:2]
CIb.HbSS

#10a)
#Null-hypothesis: mu = 10, alt-hypothesis: mu != 10
t.test(HbSb, mu=10, conf.level=0.95)
#The p-value is larger than 0.05, so I fail to reject the null-Hypothesis. The true mean can be assumed to be 10.
#b)
#Null-hypothesis: mu(Sb) = mu(SS), alt-hypothesis: mu(Sb) != mu(SS)
t.test(HbSb, HbSS, var=TRUE, conf.level=0.99)
#The p-value is smaller than 0.01, so I reject the null-hypothesis. The means of the two samples can be assumed to be different.
#c)
#Then first of all you need to choose wether you want the lower or the higher tail, and the area under the curve from the cutoff to the end would double on that one tail, since the extra 2.5% or 0.5% respectively would be moved to that same tail.

