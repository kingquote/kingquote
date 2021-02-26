load("L5_workspace.rdata")
library("lme4")

#group comparisons
kruskal.test(rats$Glycogen ~ rats$Treatment)

avrat <- tapply(rats$Glycogen, list(rats$Treatment, rats$Rat), mean)
avrat
treat <- gl(3, 1, length = 6)
kruskal.test(as.vector(avrat) ~ treat)

#rat example

#nested levels
rat <- rats$Treatment:rats$Rat
liver <- rats$Treatment:rats$Rat:rats$Liver

#model
modelrats <- lmer(Glycogen ~ Treatment + (1 | rat) + (1 | liver), data = rats)
summary(modelrats)
modelrats_null <- lmer(Glycogen ~ (1 | rat) + (1 | liver), data = rats)
anova(modelrats_null, modelrats)

#relevelling
rats$Treatment <- relevel(rats$Treatment, ref = "2")


#variance components analysis
vars <- c(14.167, 36.065, 21.167)
100 * vars / sum(vars)

#Multilevel modelling
attach(childfull)

#define multilevel nested structure
d <- town:district
s <- town:district:street
h <- town:district:street:house

#no fixed effect and four nested random effects:
schools_null <- lmer(response ~ (1 | town) + (1 | d) + (1 | s) + (1 | h))
summary(schools_null)

#one fixed effect (gender) and four nested random effects:
schools_full <- lmer(response~gender + (1 | town) + (1 | d) + (1 | s) + (1 | h))
summary(schools_full)

#significance test
anova(schools_null, schools_full)

#variance components analysis
v <- c(4.0817, 15.6746, 168.3500, 36.9757, 36.2406)
vc <- v / sum(v)
vc

#plotting
hist(response[town == "Coventry"], main = "Coventry", breaks = seq(40, 150, 5),
     xlab = "response")
plot(response ~ district, subset = (town == "Coventry"), main = "Coventry")

#generalised mixed effects
#logistic model
library("MASS")

#bacterial infection
head(bacteria, 10)
table(bacteria$y, bacteria$trt)

#proportion test
prop.test(c(84, 44, 49), c(96, 62, 62))
pairwise.prop.test(c(84, 44, 49), c(96, 62, 62))

#logistic regression not controlling for pseudoreplication
inf <- glm(y ~ trt, binomial, data = bacteria)
summary(inf)
step(inf)

#ID as random effect
infection <- glmer(y ~ trt + (1 | ID), family = binomial, data = bacteria)
summary(infection)

#significance
infection_null <- glmer(y ~ (1 | ID), family = binomial, data = bacteria)
anova(infection, infection_null)
