rm(list=ls())
library(tidyverse)
#11a)
#Yes. 'success' is being color-blind
#b)
#pML = X/n = 8/95 = 0.0842 -> 8.4%
#w = p/(1-p) = 0.0842/(1-0.0842) = 0.0920 -> 9.2%
#c)
#I can already see that np(1-p) < 9, so using the normal approximation is not appropriate.
#the grid line just sets up a regular sequence for the x axis
#next ,over that grid, we plot a theoretical CDF for a binomial distribution with the same lenght as the empirical data, and using the estimated p
#then the same thing is done, but witha normal distribution instead, using the SE as an estimator of sigma
#the summary line shows the distribution of the absolute difference between the CDF's, or in other words, the error of the approximation
#d)
n <- 95
x <- 8
p <- x/n
bin <- binom.test(x, n, p, alternative = 'two.sided')
prop <- prop.test(x, n, p, alternative = 'two.sided')
tab <- rbind('Bin' = bin$conf.int, 'Prop' = prop$conf.int)
colnames(tab) <- c('Lower','Upper')
tab
#The CIs are very similar. It seems that the true proportion could really be X/n.
#e)
#The p-value gives the probability to see the observed results under the null-hypothesis. They are shown to be 1 here, though I assume that is due to rounding, but it definitely is close to one.
#f)
WilsonCI <- function(x, n){
  mid <- (x + 1.96^2/2)/(n + 1.96^2)
  se <- sqrt(n)/(n+1.96^2)*sqrt(x/n*(1-x/n)+1.96^2/(4*n))
  cbind( pmax(0, mid - 1.96*se),  pmin(1, mid + 1.96*se))
}
tab <- rbind(tab,'Wilson' = WilsonCI(x,n))
rownames(tab) <- c('Bin', 'Prop', 'Wilson')
tab
#The Wilson CI is almost the same as the one from prop.test.

#12a)
ac <- 9
an <- 18
bc <- 5
bn <- 22
a <- 0.05
tab2 <- rbind('Cleared' = c(ac,bc), 'Not cleared' = c(an,bn))
colnames(tab2) <- c('Treatment A','Treatment B')

WaldCI <- function(x, n){
  mid <- x/n
  se <- sqrt(x*(n-x)/n^3)
  cbind( pmax(0, mid - 1.96*se),  pmin(1, mid + 1.96*se))
}

CIa <- cbind(WaldCI(ac,an+ac),WilsonCI(ac,an+ac))
CIb <- cbind(WaldCI(bc,bn+bc),WilsonCI(bc,bn+bc))
CItab <- rbind(CIa,CIb)
rownames(CItab) <- c('A','B')
colnames(CItab) <- c('Wald lower','Wald upper','Wilson lower','Wilson upper')
CItab
#b)
chisq.test(tab2)
#I was unsure what was asked of me here, so I did what I thought made sense with the data, which is to test wether there is a difference in proportions via an established test.
#It seems like the two treatments don't show significantly different proportions.
#c)
print( RR <- ( tab2[1,1]/ sum(tab2[1,])) /  ( tab2[2,1]/ sum(tab2[2,])) )
s <- sqrt( 
  1/tab2[1,1] + 1/tab2[2,1] - 1/sum(tab2[1,]) - 1/sum(tab2[2,]) )
exp( log(RR) + qnorm(c(.025,.975))*s)

print( OR <- tab2[1]*tab2[4]/(tab2[2]*tab2[3]))
s <- sqrt( sum( 1/tab2) )
exp( log(OR) + qnorm(c(.025,.975))*s)
#d)
#The new estimate would be one divided by the previous estimate.
