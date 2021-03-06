set.seed(1)
rabbits <- rnorm(100000, mean=5.25, sd=1.625)
hist(rabbits, prob=TRUE, main="Rabbit weight distribution", xlab="Weight",ylab="Proportion")
lines(density(rabbits), bw = "nrd0") # I don't get the bw part. I understand it's supposed to define how much smoothing should be done on the line, however even when putting in the default value as I did here, I get an error saying that's not a graphical parameter

weigh <- numeric(length = 100)
for (i in 1:100){
  weigh[i] <- mean(sample(x=rabbits, size = 5))
}
hist(weigh, prob=TRUE, main="Rabbit weight distribution with samples of size 5", xlab="Weight",ylab="Proportion")
lines(density(weigh), bw = "nrd0") 

for (i in 1:100){
  weigh[i] <- mean(sample(x=rabbits, size = 20))
}
hist(weigh, prob=TRUE, main="Rabbit weight distribution with samples of size 20", xlab="Weight",ylab="Proportion")
lines(density(weigh), bw = "nrd0") 

for (i in 1:100){
  weigh[i] <- mean(sample(x=rabbits, size = 100))
}
hist(weigh, prob=TRUE, main="Rabbit weight distribution with samples of size 100", xlab="Weight",ylab="Proportion")
lines(density(weigh), bw = "nrd0") 

d1 <- rnorm(50000, mean=4, sd=sqrt(2.5))
d2 <- rnorm(50000, mean=17, sd=sqrt(14))
dragons <- c(d1,d2)
hist(dragons, prob=TRUE, main="Dragon wing length", xlab="length",ylab="Proportion")
lines(density(dragons), bw = "nrd0")

length <- numeric(length = 100)
for (i in 1:100){
  length[i] <- mean(sample(x=dragons, size = 5))
}
hist(length, prob=TRUE, main="Wing length distribution with samples of size 5", xlab="length",ylab="Proportion")
lines(density(length), bw = "nrd0") 

for (i in 1:100){
  length[i] <- mean(sample(x=dragons, size = 20))
}
hist(length, prob=TRUE, main="Wing length distribution with samples of size 20", xlab="length",ylab="Proportion")
lines(density(length), bw = "nrd0") 

for (i in 1:100){
  length[i] <- mean(sample(x=dragons, size = 100))
}
hist(length, prob=TRUE, main="Wing length distribution with samples of size 100", xlab="Length",ylab="Proportion")
lines(density(length), bw = "nrd0") 
