rm(list=ls())
library(tidyverse)
library(ggfortify)
library(MASS)
library(MuMIn)
library(AICcmodavg)
library(readr)
options(na.action='na.fail')

dd <- read_csv("Studium/19FS/Bio144/Data/parkinsons_updrs.data")

#start by brute forcing a model without trying to understand anything
lmdd <- lm(total_UPDRS~.-motor_UPDRS,dd) #there are two response variables: motor and total UPDRS. Using one to predict the other is useless.
emp <- lm(total_UPDRS~1,dd)

back <- stepAIC(lmdd, direction = c("backward"), trace=FALSE, scope=list(upper=lmdd,lower=emp))
forw <- stepAIC(emp, direction = c("forward"), trace=FALSE, scope=list(upper=lmdd,lower=emp))
both <- stepAIC(lmdd, direction = c("both"), trace=FALSE, scope=list(upper=lmdd,lower=emp))

models <- list(full=lmdd, back=back,forw=forw,both=both)
model.sel(models)
#The best model is forward. Backward and Both use the same amount of variables(13), and are only minimally worse, so they would still be viable models, especially if procuring their variables is easier than the ones in the forward model.

#Now to try and think about what I'm doing
hist(dd$total_UPDRS)
autoplot(lmdd)
#I can see patterns, namely lines coming out og the coloud of points. I assume they represent single patints. The averages are still fine, thanks to the massive amount of observations. There are a few outliers though, and since they are on one line, I'll try to see if the come from one patient, and remove them if so.
temp <- filter(dd, subject!=30)
autoplot(lm(total_UPDRS~.-motor_UPDRS,temp))
#this definitely improved it, especially the reid vs fit, but there is still one outlier in the reis vs lever plot. Time to look into that.
#Comparing that one recording to others from the same patient shows, that almost all measurements are at least one order of magnitude larger than the others from the same patient, at similar times into the treatment/data collection. I will remove that row.
temp <- filter(temp,!(subject==14&test_time==21.4060&Jitter_Abs==0.00019884))
autoplot(lm(total_UPDRS~.-motor_UPDRS,temp))
#still not perfect, but significantly better, I'll work with this
dd1 <- temp

#now to remove some useless columns from the lm: subject (since that will not apply to new measurements), motor_UPDRS again
dd2 <- dplyr::select(dd1, -motor_UPDRS,-subject)

#find new models from this data
lmdd2 <- lm(total_UPDRS~.,dd2) #there are two response variables: motor and total UPDRS. Using one to predict the other is useless.
emp2 <- lm(total_UPDRS~1,dd2)

back2 <- stepAIC(lmdd2, direction = c("backward"), trace=FALSE, scope=list(upper=lmdd2,lower=emp2))
forw2 <- stepAIC(emp2, direction = c("forward"), trace=FALSE, scope=list(upper=lmdd2,lower=emp2))
both2 <- stepAIC(lmdd2, direction = c("both"), trace=FALSE, scope=list(upper=lmdd2,lower=emp2))

models2 <- list(full=lmdd2, back=back2,forw=forw2,both=both2)
model.sel(models2)
#my work dropped the lowest AICc from 42842.2 to 42189.1. Also, all three stepAIC's produced the same model now.

plot(dd2$total_UPDRS,predict(back2))

#I don't know how much the different jitter and shimmer values depend on each other, so ill try some models where I force it to use only one each
dd3 <- dplyr::select(dd2,-Jitter_DDP,-Jitter_Perc,-Jitter_PPQ5,-Jitter_RAP,-Shimmer_APQ11,-Shimmer_APQ3,-Shimmer_APQ5,-Shimmer_dB,-Shimmer_DDA)

lmdd3 <- lm(total_UPDRS~.,dd3) #there are two response variables: motor and total UPDRS. Using one to predict the other is useless.
emp3 <- lm(total_UPDRS~1,dd3)

back3 <- stepAIC(lmdd3, direction = c("backward"), trace=FALSE, scope=list(upper=lmdd3,lower=emp3))
forw3 <- stepAIC(emp3, direction = c("forward"), trace=FALSE, scope=list(upper=lmdd3,lower=emp3))
both3 <- stepAIC(lmdd3, direction = c("both"), trace=FALSE, scope=list(upper=lmdd3,lower=emp3))

models3 <- list(full=lmdd3, back=back3,forw=forw3,both=both3)
model.sel(models3)
#this brought AICc up to 42302.1, and it is now using the full model I 'provided' it with. So the prediction from dd2 is still in the lead

#What about using motor_UPDRS?
dd4 <- dplyr::select(dd1, -total_UPDRS, -subject)

lmdd4 <- lm(motor_UPDRS~.,dd4) #there are two response variables: motor and total UPDRS. Using one to predict the other is useless.
emp4 <- lm(motor_UPDRS~1,dd4)

back4 <- stepAIC(lmdd4, direction = c("backward"), trace=FALSE, scope=list(upper=lmdd4,lower=emp4))
forw4 <- stepAIC(emp4, direction = c("forward"), trace=FALSE, scope=list(upper=lmdd4,lower=emp4))
both4 <- stepAIC(lmdd4, direction = c("both"), trace=FALSE, scope=list(upper=lmdd4,lower=emp4))

models4 <- list(full=lmdd4, back=back4,forw=forw4,both=both4)
model.sel(models4)
#This time, we get AICc down to 39194.0. So given our variables, a model to predict the Parkinsons measurement for motor skills specifically works better than one predicting the total measurement.

plot(dd2$total_UPDRS,predict(back4))
#I'm still not happy with this, but I think the problem is that these relations are not linear. I'll try to find out what I should log transform.

dd5 <- dplyr::select(dd1,-subject)

current <- dd$PPE
hist(current)
hist(log(current))

#I ran the code above this for each variable to see if log transforming would make it more normal. I yes, I did this as well next:
dd5 <- mutate(dd5, logJitter_Perc=log10(Jitter_Perc), logJitter_Abs=log10(Jitter_Abs), logJitter_RAP=log10(Jitter_RAP),
              logJitter_PPQ5=log10(Jitter_PPQ5), logJitter_DDP=log10(Jitter_DDP), logShimmer=log10(Shimmer),
              logShimmer_dB=log10(Shimmer_dB), logShimmer_APQ3=log10(Shimmer_APQ3), logShimmer_APQ5=log10(Shimmer_APQ5),
              logShimmer_APQ11=log10(Shimmer_APQ11), logShimmer_DDA=log10(Shimmer_DDA), logNHR=log10(NHR))
#and in the very end, I deleted the untransformed values
dd5 <- dplyr::select(dd5,-Jitter_Perc, -Jitter_Abs, -Jitter_RAP, -Jitter_PPQ5, -Jitter_DDP, -Shimmer, -Shimmer_dB,
                     -Shimmer_APQ3, -Shimmer_APQ5, -Shimmer_APQ11, -Shimmer_DDA, -NHR)

#looking at motor_UPDRS first
dd6 <- dplyr::select(dd5, -total_UPDRS)

lmdd6 <- lm(motor_UPDRS~.,dd6) #there are two response variables: motor and total UPDRS. Using one to predict the other is useless.
emp6 <- lm(motor_UPDRS~1,dd6)

back6 <- stepAIC(lmdd6, direction = c("backward"), trace=FALSE, scope=list(upper=lmdd6,lower=emp6))
forw6 <- stepAIC(emp6, direction = c("forward"), trace=FALSE, scope=list(upper=lmdd6,lower=emp6))
both6 <- stepAIC(lmdd6, direction = c("both"), trace=FALSE, scope=list(upper=lmdd6,lower=emp6))

models6 <- list(full=lmdd6, back=back6,forw=forw6,both=both6)
model.sel(models6)
#the previous record for motor was 39194.0, now it is 39142.6

#and then at total_UPDRS
dd7 <- dplyr::select(dd5, -motor_UPDRS)

lmdd7 <- lm(total_UPDRS~.,dd7) #there are two response variables: motor and total UPDRS. Using one to predict the other is useless.
emp7 <- lm(total_UPDRS~1,dd7)

back7 <- stepAIC(lmdd7, direction = c("backward"), trace=FALSE, scope=list(upper=lmdd7,lower=emp7))
forw7 <- stepAIC(emp7, direction = c("forward"), trace=FALSE, scope=list(upper=lmdd7,lower=emp7))
both7 <- stepAIC(lmdd7, direction = c("both"), trace=FALSE, scope=list(upper=lmdd7,lower=emp7))

models7 <- list(full=lmdd7, back=back7,forw=forw7,both=both7)
model.sel(models7)
#The previous record for total was 42189.1, now it is 42229.2

#An overview of the models for total and motor:
motormodels <- list(four=back4, six=back6)
totalmodels <- list(zero=back, two=back2, three=back3, seven=back7)
motorAICcs <- list(four=AICc(back4), six=AICc(back6))
totalAICcs <- list(zero=AICc(back), two=AICc(back2), three=AICc(back3), seven=AICc(back7))
motorAICcs
totalAICcs

#To show the complete best model, including values
bestmotor <- motormodels[which.min(motorAICs)]
model.sel(bestmotor)
besttotal <- totalmodels[which.min(totalAICs)]
model.sel(besttotal)

#Couldn't figure out how to get a lm object out of a list, so here it is manually:
#____MOTOR____
AICc(back6)
summary(back6)
#____TOTAL____
AICc(back2)
summary(back2)
#Again, I'm not convinced these are the best models, but it's as good as I could get it