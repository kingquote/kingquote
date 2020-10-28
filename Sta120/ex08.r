rm(list=ls())
library(tidyverse)
library(ggfortify)

#17a)
set.seed(5) ## for reproducable simulations
beta0.true <- 1 ## true parameters, intercept
beta1.true <- 2 ## and slope
## observed x values:
x <- c(2.9, 6.7, 8, 3.1, 2, 4.1, 2.2, 8.9, 8.1, 7.9, 5.7, 1.6, 6.6, 3, 6.3)
## simulation of y values:
y <- beta0.true + x * beta1.true + rnorm(15, sd = 2)
dd <- data.frame(x = x, y = y)

plot(dd, col='blue')
cor(dd)
cor(dd, method='spearman')
#Spearmans correlation is more robust than Pearsons. There are three 'outliers' in this data, though they are not far off, which is why the difference in correlation estimates is minimal..

#b)
lmdd <- lm(y~x, dd)
abline(lmdd, col='red')

#c)
points(x, lmdd$fitted.values, col='red')

#d)
segments(x, lmdd$fitted.values, y1=(lmdd$fitted.values+lmdd$residuals), col='blue')

#e)
summary(lmdd)
#standard errors: 1.15 for beta0, .202 for beta1

#g)
#t-values: 1.04 for beta0, 9.30 for beta1
#p-values: .317 for beta0, 3.69*10^-7 for beta1

#i)
new <- expand.grid(x = seq(min(x), max(x), length=100), y = mean(y))
pred.conf <- predict(lmdd, new, interval='confidence')
pred.pred <- predict(lmdd, new, interval='prediction')
matlines(new$x, cbind(pred.conf,pred.pred[,-1]), col=c(1,2,2,3,3), lty=c(1,1,1,2,2))
#The difference is that 'confidence' shows the 95%CI of the estimated mean, while 'prediction' shows the 95%CI of the estimated y, which makes it wider.

#j)
#I couldn't figure out how to restrain the model to (0,0), but looking at the regular model, I can see that the intercept is about 1.1. Since that is not much bigger than one, especially in the context of such a steep slope of about 2, I assume the constraint would not change the slope much, and the fit would still be pretty good.

#k)
dd_outlier <- rbind(dd, data.frame(x = c(10, 11, 12), y = c(9, 7, 8)))
lmdd_out <- lm(y~x, dd_outlier)
summary(lmdd_out)
autoplot(lmdd_out)
autoplot(lmdd)
plot(dd_outlier, col='blue')
points(x,y,col='red')
abline(lmdd, col='red')
abline(lmdd_out, col='blue')
#The outliers strongly influence the model, cutting the slope in half and multiplying the intercept by 6. Luckily, the autoplot clearly shows that this model is a bad fit, so I would not accidently work with such a regression.

#l)
#The formula is ordered as 'response var' ~ 'explanatory vars', so switching the two changes which variable will be used under the line on the formula for beta1, and of course also changes the resulting beta0. Looking at it geometrically, it means that the model would minimize the horizontal error in a x-y-scatterplot, instead of the vertical error.