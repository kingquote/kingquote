load("L4_workspace.rdata")

#model 1: smoking and obesity
attach(hypertension)
model_hyper <- glm(hypnonhyp ~ smoking + obesity, binomial, data = hypertension)
summary(model_hyper)
step(model_hyper)

#model 2: obesity
model_hyper2 <- glm(hypnonhyp ~ obesity, binomial)
summary(model_hyper2)

#95% CI
confint(model_hyper)
confint.default(model_hyper)

#odds ratios, probabilities
coef(model_hyper)
exp(cbind("Odds ratio" = coef(model_hyper), confint(model_hyper)))

coef(model_hyper2)
exp(coef(model_hyper2))
exp(-1.676 + 0.76)
1 / (1 + exp(- (-1.676)))
1 / (1 + exp(- (-1.676 + 0.76)))

#menarche analysis

#model menarche
model_menar <- glm(menarche ~ age, binomial, data = menar)
summary(model_menar)
#logits
predict(model_menar)
#probabilities
probs <- predict(model_menar, type = "response")
probs
#probability plot
plot(probs ~ age, data = menar, pch = 16, cex = 0.7, ylab = "menarche")

#plot with frequencies by age
ageintervals <- cut(menar$age,
       c(8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20))
table1 <- table(ageintervals, menar$menarche)
table1
table2 <- prop.table(table1, 1)[, 2]
table2
points(table2 ~ c(8.5, 9.5, 10.5, 11.5, 12.5, 13.5, 14.5, 15.5,
       16.5, 17.5, 18.5, 19.5), pch = 1, cex = 1.5)
#adding menarche by age
points(menarche ~ age, col = "darkgrey", data = menar)

#factors with >2 levels
model_infant <- glm(healthy ~ as.factor(month), binomial, data_infant)
summary(model_infant)
coef(model_infant)
exp(coef(model_infant))


#interactions
model_chd <- glm(chd ~ age * cat * chl, binomial, data = evans)
summary(model_chd)

#model optimisation
model_menar2 <- glm(menarche ~ age * igf1, binomial, data = menar)
summary(model_menar2)
step(model_menar2)
summary(step(model_menar2))
