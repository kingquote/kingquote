x <- c(-2,-1,0,1,2,5) #x-values are not sequential, therefore I do not use seq()
a <- 1 - (0.2+0.2+0.1+0.3+0.05) #sum of all p must be 1
p <- c(0.2,0.2,0.1,a,0.3,0.05) #non-sequential p-values as vector
plot(x, p, type = "h", ylab = "p", main = "Probability function of x") #plot p over x
psum <- cumsum(p) #each value is sum of all former values as well as the current one of p
plot(x, psum, type = "s", ylab = "cumulative p", main = "Cumulative probabilities")
sum(p[x>-1 & x<=3]) #adds up p-values for -1<X<=3
sum(p[abs(x)<=2]) #adds up p-values for |x|<=2
y <- rnorm(100, mean = 87, sd = 2) #sets up vector with appropriate random values
qqnorm(y) #plots values as dots
qqline(y, distribution = qnorm) #plots theoretical line for normal dist
z <- rchisq(100, df = 2)
qqnorm(z) #plots values as dots
qqline(z) #plots theoretical line for normal dist
#As expected, the values of y, which is randomly generated according to a normal distribution lie very close to the line of a theoretically expected normal distribution QQ-Plot.
#The Chi^2 distribution however is, again as expected, exponential, therefore the line foe the expected values for a normal distribution don't fit it at all.