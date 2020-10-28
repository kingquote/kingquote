f <- function(x) {2*(exp(1)^(-2*x))} #define function, exp(1) is e, lambda is 2
integrate(f, 0, Inf) #I only need to integrate starting at 0 because the function is defined to keep the value 0 anywhere below that as per the task
#since this returns 1, f(x) is indeed a density

x <- seq(87-4, 87+4, 0.1) #sets up sequence for x-axis
plot(x, dnorm(x,mean = 87), type = "l", ylab = "P[X=x]", main = "N(87,1)") #plots graph of normal dist with mean of 87 and sigma/sigma^2 of 1
abline(v=x[which.max(dnorm(x,mean = 87))]) # draws vertical line at x value where the y value is at it's maximum

abline(v = qnorm(p = c(.95,.975,.99), mean = 87), col = "red") #mark all x-values at the given percentiles with a red vertical line

op <- par(mfrow=c(3,1))
hist(rnorm(10, mean = 87))
hist(rnorm(1000, mean = 87))
hist(rnorm(100000, mean = 87))
par(op)
#even though they all are based on a normal distribution of N(87,1), the higher n is, the more clearly the expected bell curve is visible

x <- rnorm(100000, mean = 87)
op <- par(mfrow=c(3,1))
hist(x+10, main = "Histogram a")
hist(x-20, main = "Histogram b")
hist(x*5, main = "Histogram b")
par(op)
#while adding or substracting a constant value from each generated value results in a bell curve that has just been shifted around (if you use x+10 instead of x you get N(87+10,1) instead of N(87,1)), multiplying them results in a shifted AND streched bell curve (with x*5 instead of x you get N(5*87, 5*1) instead of N(87,1)). I think it's also worth mentioning that this is true like that when using the sd, like R does. Were you to use V(X), it would be N(87*5, 1*5^2) instead.