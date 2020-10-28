rm(list=ls())

#1a)
?volcano
#it is called Maunga Whau. The Dataset shows topographical information on that volcano.

#b)
?image
image(volcano)

#c)
#install.packages('fields') -> only done once
library(fields)
image.plot(volcano)

#d)
?demo
demo()
demo(persp)
max(z)

#2a)
?mtcars
#Unlike volcano, which contains only numerical entries, and where the x and y-axis of the data correspond to actual directionality, mtcars is a csv with headers, where the columns observed values of the different cars in each row.

#b)
library(skimr)
skim(mtcars)
hist(mtcars$qsec, xlab='Seconds',main='Seconds for quarter mile in mtcars')
#Shows the distribution of one of the variables (seconds per quarter mile) for all cars
pairs(mtcars[,3:4],gap=0)
#Shows the relation between horsepower and displacement. The higher the hp is, the more displacement.
boxplot(mtcars$wt,main='Boxplot of weights')
#Shows the statistics for the distribution of weights.

#3a)
womo <- read.csv("~/Studium/19FS/Sta120/Worksheets/01wolvesmoose.csv")
boxplot(womo[,3])#Moose
boxplot(womo$Wolf)#Wolf
qqnorm(womo[,3])#Moose
qqline(womo[,3],col=2)
qqnorm(womo[,2])#Wolf
qqline(womo[,2],col=2)
#The Wolf population is much smaller than the moose population overall, and a normal distribution is not a perfect fit, but it's pretty good.

#b)
with(womo, plot(Year,Wolf,  type="l", col="red3",xlab='Year', ylab='Wolf',main='Population Sizes',ylim=c(0,55)))
par(new = T)
with(womo, plot(Year,Moose,  type="l", col="blue", axes=F, xlab=NA, ylab=NA,ylim=c(0,2550)))
axis(side = 4)
mtext(side = 4, line = 0, text = 'Moose')
legend("topleft",
       legend=c('Wolf', "Moose"),
       lty=c(1,1), col=c("red3", "blue"))
#It seems that the spike pattern of the wolf is the same as the one from the moose, but shifted to the right, though the amplitude of the spikes is not obviously correlated to me, and the wolf data is generally more 'jittery', since the population is small enough to see the 'discreteness' clearly.
#Still, it's possible to see that an increase in wolf population leads to a decrease in moose pop, an increase in moose pop leads to an increase in wolf pop, and decreasing of either leads to the opposite effect.