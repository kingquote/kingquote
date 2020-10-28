rm(list=ls())
library(tidyverse)
library(ggfortify)
dd <- read.csv("~/Studium/19FS/Sta120/Data/10chemosphere_OC.csv")
dd <- mutate(dd,logOC=log(OC))

#20a)
#view(dd) I commented this to save space in the markdown
ggplot(dd, aes(y=OC, x=Behandlung, col=Monat))+
  geom_point()+
  theme_bw()
#It seems that Treatment A is pretty good, as OC levels are quite low in comparison to both B and C. B and C both have more spread, but I would say C is better than B. I don't see a clear pattern with the months from these dots, so I will look at each months average now.
aggregate(dd[,5],list(dd$Monat),mean)
#Apparently, OC levels were slightly higher in july.

#b)
lm1dd <- lm(logOC~Behandlung, dd)
autoplot(lm1dd)
#Looks acceptable. Biggest problem is dip in high fitted values in the Scale-Location plot.
anova(lm1dd)

#c)
lm2dd <- lm(logOC~Behandlung+Monat, dd)
autoplot(lm2dd)
#Similar to before
summary(lm2dd)
#The (Intercept) column describes the slope defined by BehandlungA and Monatjan. The other estimates are differences to that first intercept reference. The adj. R-squared is not bad with about 45% of the variance explained. At leas one of the Coefficients is significant, according to the overall p-value of 0.001747.

#d)
lm3dd <- lm(logOC~Behandlung*Monat, dd)
autoplot(lm3dd)
interaction.plot(x.factor = dd$Behandlung, trace.factor = dd$Monat, response = dd$logOC)
summary(lm3dd)
#It seems that the interaction term doesn't really help the model. This could also be predicted from the interaction plot, since the lines for jan and jul are almost parallel, which shows that the two effects are mostly additive.

#e)
lm4dd <- lm(logOC~Behandlung+Produktion, dd)
lm5dd <- lm(logOC~Produktion+Behandlung, dd)
anova(lm4dd)
anova(lm5dd)
#The difference between the two obviously stems from the difference in the sum of squares, sice the other differences depend on this value. I don't know why that difference exists though, since the equations for those values don't depend on each other, so I don't see how the order you do them in changes anything.
