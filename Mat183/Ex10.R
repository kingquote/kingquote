o <- c(690,750,790,840,1040,930,850,890,1270,1060)
norm.interval = function(data, variance=var(data), conf.level=0.95) { #sets up a new function, the values given here are defaults
z = qnorm((1 - conf.level)/2, lower.tail = FALSE) #gives critical value
meanx = mean(data)
sdx = sqrt(variance/length(data))
c(meanx - z * sdx, meanx + z * sdx)
}
norm.interval(o)
var(o) #estimates variance from data

norm.interval(o,250^2) #same thing with sd 250
#the standard deviation has grown, while the mean stayed the same, so we expect the confidence interval to grow around the same center, which it did

CV <- 100/(sqrt(var(o)/length(data))) #because 200=2*z*sdx (in my function from a), so 100=z*sdx
pnorm(CV, lower.tail = FALSE) #gives confidence level for given critical value

scatter.smooth(o, main="Outbreaks over time",xlab="Months since beginning of data collection", ylab="# of outbreaks")
#the amount of outbreaks per month is generally rising, though the scattering in the later months is larger than the earlier ones.

boxplot(o,ylim=c(600,1300), horizontal = TRUE, main="Boxplot of the number of outbreaks of bird flu",xlab="Outbreaks")
points(o,jitter(c(1,1,1,1,1,1,1,1,1,1)), pch=16, col="red")
points(660, 1, pch=17, col="blue")
#The predicted value is unlikely, since it is not only an outlier from the data throughout the last 10 months, but looking at the result from d), it fits even less, because the trend shows a rising amount of outbreaks, whereas the prediction is even lower.