
rm(list=ls())

library(tidyverse)
library(ggfortify)
library(GGally)

#test data
compensation <- read.csv("~/Studium/19FS/Bio144/Data/Beckerman/compensation.csv")
plant_gr <- read.csv("~/Studium/19FS/Bio144/Data/Beckerman/plant.growth.rate.csv")


####Data Wrangling####

#gives the different entries without repetition
unique(compensation$Grazing)
#similar, but for factors
levels(compensation$Grazing)

#gives nr of rows, columns and overview od data type and headers
glimpse(compensation)

#produces new data frame with only given column. Use eg. -Root for all columns except Root.
select(compensation, Root)

#produces new data frame with only the indicated rows. Use either a number (5), a sequence (2:7) or a collection (c(2,4))
slice(compensation, c(1,3,8))

#produces new data frame containing only rows for wich the boolean is true. To combine booleans, use | for 'or' and & for 'and'
filter(compensation, Fruit>80)

#produces a data frame with a new column added to it
mutate(compensation, logFruit = log(Fruit))

#useful for finding nnumber of occurences in categorical variable (data from exercise week 5)
table(ratdata$caste)

#used this to find the position of Switzerland in a list when ordered by a certain factor
which(dd[order(dd$rugged),]$country=='Switzerland', arr.ind=T)

#%>% is for piping: gives output as argument to next function
#group_by to do calculations per group
#combine with summarise for quick statistics
#for ANOVA: sd = sd(Fruit)/sqrt(n()) ->the n() counts rows per group. careful, also counts NaNs
x <- compensation %>%
  group_by(Grazing) %>%
  summarise(mean = mean(Fruit), sd = sd(Fruit))

#to gather entries from multiple columns into one, and add a new one thst contains the headers from the columns the values come from.
#key and value define new headers, the c() contains the headers to combine. (see exercise 10.2)
#the function spread() does the opposite
dd <- gather(dd, key=Measurement, value=RT, c(RT_main_1, RT_main_2, RT_main_3, RT_main_4, RT_main_5))



####Visualization####

#example for expression
expression("Algal cover - square root cm"^"2")

#nice overview of variables and their connections
ggpairs(compensation)

#give data frame and aesthetic; colour and shape distinguish between the factors of Grazing
#display data as points with parameters (alpha is transparency), could manually set colour or shape here as well
#labelling
#get rid of grey background
ggplot(compensation, aes( x = Root, y = Fruit, colour = Grazing, shape = Grazing ))+
  geom_point(size = 2, alpha = 0.9)+
  xlab('Root Biomass') + ylab('Fruit Production')+
  theme_bw()

#other layers for ggplot:

#does what you'd think it does
geom_boxplot()

#only takes one argument in aes()! The y-axis is generated automatically. Use either bins or binwidth, not both (or use neither)
geom_histogram(bins = 10, binwidth = 15)

#splits output into multiple graphs, one per factor of Grazing
facet_wrap(~Grazing)

#you guessed it. see summarise for easy way of getting means and sds per group
geom_errorbar(aes(ymin = mean-sd, ymax = mean+sd), width = 0.1)

#switch x and y, even with boxplot
coord_flip()

#multiple panels, example in 06
facet_wrap(~height+herbivores)

#jitterdodge avoids points overlapping(jitter), but still keeps groups away from each other(dodge)
geom_point(position=position_jitterdodge(jitter.width = 0.2))

####Simple Linear Regression####

#fits a linear model, with hypothesis: growth rate is function of soil moisture, given data from plant_gr
model_pgr <- lm(plant.growth.rate ~ soil.moisture.content, data=plant_gr)

#provides useful plots if given an lm() model
autoplot(model_pgr, smooth.colour = NA)

#produces sums-of-squares table (not ANOVA - comparison of means)
anova(model_pgr)

#more info, intercept and slope can be found here. Specific values can be extracted by adding eg. $r.squared after the bracket.
summary(model_pgr)

#shows confidence intervals of coefficients
confint(model_pgr)

#new part: geom_smooth(method='lm'); this adds linear regression with standard error in grey, works well with only one determining component
ggplot(plant_gr, aes(x=soil.moisture.content, y=plant.growth.rate)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  ylab('Plant growth rate (mm/week)') +
  theme_bw()

####Multiple Linear Regression####

dd <- read_delim("Studium/19FS/Bio144/Data/Lecture/bodyfat.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
dd <- select(dd,bodyfat,weight,abdomen)

#to choose what factor should be the reference: (here, the factor DBC is chosen as the reference for all factors that are part of HYBRID)
d.mais <- mutate(d.mais,HYBRID = relevel(HYBRID,ref='DBC'))

#to be able to compare slopes: scale variables
dd <- mutate(dd, scaledweight=scale(weight), scaledabdomen=scale(abdomen))

#As in simple lin reg, but multiple explanatory variables are listed with + in between here for common slope, with * in between for different slopes)
#put . in place of explanatory variables to choose everything in dataset except for the response variable
modelbw <- lm(bodyfat ~ weight + abdomen, data=dd)

#create data with model
new_data <- expand.grid(weight = seq(min(dd$weight), max(dd$weight), length=100), abdomen = mean(dd$abdomen))

#shows prediction of the model for every observation, or predicts new values 
predict(model_pgr)
p1 <- predict(modelbw, newdata=new_data, interval='confidence')

#column bind
n1 <- cbind(new_data,p1)

#use geom_smooth to plot predictions with confidence interval
ggplot(n1) +
  geom_smooth(mapping=aes(x = weight, y = fit, ymin = lwr, ymax = upr), stat = 'identity')


####ANOVA####

#gives ANOVA table, takes linear model as input. For two-way-anova, just enter a linear model with + or * between explanatory variables.
#CAUTION: with interaction, p-values are not meaningful: seperate anovas per value of one factor necessary
anova(input)


####Model/Variable selection####

options(na.action='na.fail')

#to find model for EXPLANATION, choose specific hypothesis, choose variables and model a priori, ideally only a single model.
#can also do exploratory analysis for explanation (choose vars and model after), but this is specifically for speculations, to find new hypothesis that will then be checked with new data

#minimizes AICc by modifying an input lm model, direction could also be 'forward' or 'backward', this optimizes for PREDICTION
library(MASS)
library(AICcmodavg)
r.AIC <- stepAIC(lmdd, direction = c("both"), trace = FALSE,AICc=TRUE)

#stepAIC does the same work that dropterm + update + models.sel does
#creates new models from given one, each with one variable dropped, gives list with: term dropped, Degree of Freedom, SSE, something, AIC
dropterm(lm_dd, sorted=TRUE)

#manually remove a term from model
update(lm_dd, . ~ . -variablename)

#list models in order of AIC, using list of models as input.the name=model is used to name the rows in the models.sel output (use series of dropterm to create the different models)
mods <- list(full=lmdd, dt1=dt1, dt2=dt2, dt3=dt3, dt4=dt4)
model.sel(mods)

#creates every possible model from complete model
drdg <- dredge(lmdd)

#to make sense of dredge
get.models(drdg, subset = delta < 1)


####Interpretation####

#Do an LMG (R-squared decomposition)
library(relaimpo)
calc.relimp()


####Count Data####

#Do a GLM. Family needs to be specified, but (link=xxx) can be left out thanks to R-defaults.
soay.glm <- glm(fitness ~ body.size, data=soay, family = poisson(link=log))

#anova(), summary(), autoplot() can still be used, but outputs are slightly different

#to quantify the effect in the summary table:
exp(estimate)

#if res. deviance is not about equal to df, there is over-/underdispersion. Then we try using:
x <- glm(x~y, data=x, family=quasipoisson())
#or negative binom. regr. in MASS package:
glm.nb()


####Binary Data####

#For aggregate data: model using GLM with family=binomial, but needs nr of success AND nr of failure
glm( cbind(nrsuccess, nrfailure) ~ predictor, data=x, family=binomial)

#analysis similar, see lecture for details
anova(glmresult, test="Chisq")

#analyse for over-/underdispersion. If resulting p is small, dispersion is not good.If thats the case, use family=quasibinomial
pchisq(ResidualDeviance, df, lower.tail=F)

#if only small n per y-value: plotting makes no sense, so use this instead:
#also, residDeviance vs df as well as checking residuals has no meaning in these cases ->overdispersion not detectable
#also, the glm now only needs one response variable, no cbind anymore
cdplot()


####Measurement Errors####

#SIMEX procedure to account for error in LM:
library(simex)
r.simex <- simex(linearmodel, SIMEXvariable="NameOfErrorProneVariable", measurement.error=sqrt(4), lambda=seq(0.1,2.5,0.1), B=100, fitting.method="quadratic")


####Mixed Models####

library(lme4)
#see lecture 12.2, starting about halfway through the slides, but the gist of it:
#fixed variables as before
#random variables as (this_varies_by | this)


####Some more stuff####

#gives correlation. standard is Pearson, use argument method='spearman' or 'kendall' for others
cor(dd)

#set script to fail on NAs
options(na.action='na.fail')
