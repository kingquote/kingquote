rm(list=ls())
library(tidyverse)
#6a
#In poisson distributions, the variance and expected value are both equal to lambda
#b
x <- c(0:13)
pdf <- dpois(x, 5.5)
cdf <- 1*pdf
for (i in 2:length(pdf)){
  cdf[i] <- pdf[i]+cdf[i-1]
}
plot(stepfun(0:12,cdf),xlim=c(-1,14),ylab='cdf',main='Poisson lambda=5.5')
par(new=T)
plot(x=x,y=pdf,xlim=c(-1,14),main=NA,xlab=NA,ylab=NA, col='red',type='o',axes=F)
axis(side = 4)
mtext(side = 4, line = -1, text = 'pdf')
legend("topleft",
       legend=c('cdf', "pdf"),
       lty=c(1,1), col=c('black', "red"))
x <- c(0:4)
pdf <- dpois(x, 1)
cdf <- 1*pdf
for (i in 2:length(pdf)){
  cdf[i] <- pdf[i]+cdf[i-1]
}
plot(stepfun(0:3,cdf),xlim=c(-0.5,5),ylab='cdf',main='Poisson lambda=1')
par(new=T)
plot(x=x,y=pdf,xlim=c(-0.5,5),main=NA,xlab=NA,ylab=NA, col='red',type='o',axes=F)
axis(side = 4)
mtext(side = 4, line = -1, text = 'pdf')
legend("bottomright",
       legend=c('cdf', "pdf"),
       lty=c(1,1), col=c('black', "red"))
#c
pois <- rpois(1000,5.5)
hist(pois,main='Poisson lambda=5.5',xlab='x')
pois <- rpois(1000,1)
hist(pois,main='Poisson lambda=1',xlab='x',breaks = 7)
#These histograms fit the previous pdf's very well, and the higher m gets, the better that fit becomes
#d

#e

#f
pdf <- dpois(0:1000,3)
pXse2 <- sum(pdf[0:2])
pXse2
pXs2 <- sum(pdf[0:(2-0.1)])
pXs2
pXle3 <- sum(pdf[3:1000])
pXle3
#g
#In a continuous distribution, a single point has probability 0, therefore removing the single point 2 from the probability will not change it.

#7a
library(spam)
data(Oral)
?Oral
#b
summary(Oral)
head(Oral[order(-Oral$E),],1)
#region 328
#c
Oral2 <- filter(Oral,35<E&E<45)
qqplot(ppoints(35),Oral2$Y,main='QQplot empirical')
summary(Oral2)
r <- rpois(35,36)
qqplot(ppoints(35),r,main='QQplot random')
hist(Oral2$Y,breaks=7,main='Histogram empirical')
hist(r,breaks = 7,main='Histogram random')
#Especially the qqplot shows, that the real data and the randomized poisson with lambda=mean are very similar
#d
mean(Oral$SMR) + sd(Oral$SMR/sqrt(544)) * qt(c(0.05/2,1-0.05/2), 544-1)
#The CI meanns, 95% of all random normal distributions with the estimated mu and sigma will contain the true mu within their CI. If you think of our Data as one of those randomizations, that means there is a 95% chance our sample belongs to those that contain the true mu in their CI.
