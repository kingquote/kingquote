load("L3_workspace_BIO206.rdata")
library("lme4")

#example: pitch
t.test(pitch$frequency ~ pitch$attitude)
wilcox.test(pitch$frequency ~ pitch$attitude)


#random intercepts
polite <- lmer(frequency ~ attitude + (1 | subject)
              + (1 | scenario), data = pitch)
summary(polite)
coef(polite)
polite2 <- lmer(frequency ~ attitude + gender
               + (1 | subject) + (1 | scenario), data = pitch)
summary(polite2)
coef(polite2)
#significance test
polite_null <- lmer(frequency ~ gender + (1 | subject) + (1 | scenario),
                    data = pitch)
polite_full <- lmer(frequency ~ attitude + gender
                + (1 | subject) + (1 | scenario), data = pitch)
anova(polite_null, polite_full)

#random slopes model
pol_slope <- lmer(frequency ~ attitude + gender + (1 + attitude | subject)
                    + (1 + attitude | scenario), data = pitch)
summary(pol_slope)
coef(pol_slope)

#to control for random slopes of attitude and gender
pol_slopes2 <- lmer(frequency ~ attitude + gender
        + (1 + attitude + gender | subject)
       + (1 + attitude + gender | scenario), data = pitch)
summary(pol_slopes2)
coef(pol_slopes2)

#mixed effects linear regression
plot(size ~ N, pch = rep(16:19, each = 40), col = farm, data = farms)
summary(lm(size ~ N, data = farms))
mean.size <- data.frame(tapply(farms$size, farms$farm, mean))
mean.N <- data.frame(tapply(farms$N, farms$farm, mean))
plot(mean.size$tapply.farms.size..farms.farm..mean.
     ~mean.N$tapply.farms.N..farms.farm..mean., pch = 16, cex = 1.3)
summary(lm(mean.size$tapply.farms.size..farms.farm..mean.
      ~mean.N$tapply.farms.N..farms.farm..mean.))

#separate regression lines
linear_models <- lmList(size ~ N | farm, data = farms)
summary(linear_models)
#random intercepts only
farm_int <- lmer(size ~ N + (1 | farm), data = farms)
farm_null <- lmer(size ~ (1 | farm), data = farms)
anova(farm_int, farm_null)

summary(farm_int)
coef(farm_int)
#random slopes
farm_slope <- lmer(size~ N + (1 + N | farm), data = farms)
summary(farm_slope)
coef(farm_slope)

#plotting
plot(size ~ N, pch = rep(16:19, each = 40), col = farm, data = farms)
abline(85.82438, 0.69876, lwd = 2)
xyplot(size ~ N, data = farms, type = c("p", "r"),
       col = 1:24, pch = 16, cex = 1.5, groups = farm,
       xlab = "N", ylab = "plant size")



plot(ysimp ~ xsimp, col = group, data = simp)
one <- lm(ysimp ~ xsimp, data = simp)
summary(one)
abline(6.05327, -0.47092, lwd = 2)
one_lms <- lmList(ysimp ~ xsimp | group, data = simp)
summary(one_lms)
#range from -3.55 to 2.13

two <- lmer(ysimp ~ xsimp + (1 | group), data = simp)
two_null <- lmer(ysimp ~ (1 | group), data = simp)
summary(two)
4.911 / (4.911 + 1.421)
anova(two, two_null)

three <- lmer(ysimp ~ xsimp + (1 + xsimp | group), data = simp)
three_null <- lmer(ysimp ~ (1 + xsimp | group), data = simp)
summary(three)
anova(three, three_null)
