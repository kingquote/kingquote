rm(list=ls())
##4a
#Properties: f(x)>0 for any x and integration from 0 to infinity = 1
#The first property is already fulfilled if c = 0, so c just needs to be non-negative in order for it to stay this way
#For the second property:
#integration of c*exp(-??*x) from 0 to infinity equals c/??, therefore c needs to be equal to ??
#b
#Fx(x)=integration of fx(x) from -infinity to x, in our case the lower bound can also be 0, which equals 1-exp(-??*x)
#c
#E(x)=integration of x*fx(x) over R, which equals -(exp(-??x)*(??x + 1))/?? (+ constant)  -> the internet tells me it should be 1/??, but I don't know how to get there
#Var(x)=E(x^2)-E(x)^2 = -(exp(-??(x^2))*(??(x^2) + 1))/?? - (exp(-2??x)*(??x + 1)^2)/??^2 -> should be 1/??^2, but again I don't know how
#d
#Qx(p)=inverse of Fx(p), which equals -ln(1-p)/??
#The quartiles are Qx(0.25)=-ln(1-0.25)/??=ln(4/3)/??, Qx(0.5)=ln(2)/??, Qx(0.75)=ln(4)/??
#e
#P(X in R) = 1
#P(X >= -10) = 1 (because f(x)= 0 for x<0)
#P(X = 4) = 0 (because f(x) is continuous)
#P(X <= 4) = integration of f(x) from 0 to 4 = 1-exp(-4??) , which is about 0.9997
#P(X <= log(2)/2) = 0.5
#P(3 < X <= 5) = integration of f(x) from 2 to 5 = (exp(4) - 1)/exp(10), which is about 0.0024334
#f
#P(X > s+t | X > t) -> P(X <= t) = 0 -> need to redraw pdf, so that the area under the curve is still zero. Since it goes to infinity, this means that the shape of the curve remains unchanged, it just gets shifted to the right. -> P(X > s)
#It's memoryless because if you think of x as a timescale, it doesn't matter if x has already gone up to t or not, the probability of an event in another s seconds is the same.

#5a
library(tidyverse)

n10 <- rexp(10, rate = 2)
n100 <- rexp(100, rate = 2)
n1000 <- rexp(1000, rate = 2)

hist(n10,breaks=5,xlim=c(0,4),main = 'Exp with n=10',xlab = 'Value')
rug(n10)
par(new=T)
plot(density(n10),axes=F, xlab=NA, ylab=NA,main=NA,xlim=c(0,4),col='red')
par(new=T)
plot(x=seq(0,4,length.out=1000),y=dexp(seq(0,4,length.out=1000),rate=2),axes=F, xlab=NA, ylab=NA,main=NA,xlim=c(0,4),col='green',type='l')
legend('topright',legend=c('theoretical density','empirical density'),lty = c(1,1),col=c('green','red'))

hist(n100,breaks=20,xlim=c(0,4),main = 'Exp with n=100',xlab = 'Value')
rug(n100)
par(new=T)
plot(density(n100),axes=F, xlab=NA, ylab=NA,main=NA,xlim=c(0,4),col='red')
par(new=T)
plot(x=seq(0,4,length.out=1000),y=dexp(seq(0,4,length.out=1000),rate=2),axes=F, xlab=NA, ylab=NA,main=NA,xlim=c(0,4),col='green',type='l')
legend('topright',legend=c('theoretical density','empirical density'),lty = c(1,1),col=c('green','red'))

hist(n1000,breaks=40,xlim=c(0,4),main = 'Exp with n=1000',xlab = 'Value')
rug(n1000)
par(new=T)
plot(density(n1000),axes=F, xlab=NA, ylab=NA,main=NA,xlim=c(0,4),col='red')
par(new=T)
plot(x=seq(0,4,length.out=1000),y=dexp(seq(0,4,length.out=1000),rate=2),axes=F, xlab=NA, ylab=NA,main=NA,xlim=c(0,4),col='green',type='l')
legend('topright',legend=c('theoretical density','empirical density'),lty = c(1,1),col=c('green','red'))
#the empirical density gets closer to the theoretical one as n gets larger

#b
#I don't really understand this question. I know that the variance in the means of realizations will get smaller the larger n gets though.

#c
means <- NULL
mins <- NULL
for (realization in 1:500) {
  realiz <- rexp(100, rate = 2)
 means <- c(means, mean(realiz))
 mins <- c(mins, min(realiz))
}
hist(means, breaks = 20, xlab = 'Mean of Xi', main = 'Histogram of means for X1...X500')
#Unlike the Histogram from a), this looks like a normal distribution.

#d
#I think of this new distribution as a sum of binomial distributions: each realization has the same
#probability of landing above x. This probability is P(X>x)=p1=1-integration of fx(X) from 0 to x.
#Now the binomial will give us the probability that no X was below x: P(k=n)=p1^n
#Now this calculation is done for each x. This gives: g(x)=(1-exp(-x2))^n

#e
theory <- NULL
xs <- seq(0,0.04,by=0.001)
for(num in xs){
  theory <- c(theory, (exp(-num*2))**100)
}
hist(mins, breaks = 20, xlab = 'Min of Xi', main = 'Histogram of mins for X1...X500', xlim=c(0,0.045))
par(new=T)
plot(x=xs,y=theory,axes=F, xlab=NA, ylab=NA,main=NA,xlim=c(0,0.045),col='red',type='l')
legend('topright', legend='theoretical distribution',lty=1,col='red')
#I seems that the theory overlaps quite well with the empirical results here.
