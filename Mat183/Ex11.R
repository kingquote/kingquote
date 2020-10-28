data <- read.table("http://stat.ethz.ch/Teaching/Datasets/banknoten.dat",header=TRUE)
real <- data$Laenge[1:100]
fake <- data$Laenge[101:200]
t.test(real, mu=215)
t.test(fake, mu=215)

plot(density(fake),type="l",col="red",main="Distribution",xlab="Lenght")
lines(density(real), col="green")
abline(v=mean(real), col="green")
abline(v=mean(fake), col="red")
legend("topright",c("Real","Fake"), col=c("green","red"),pch=16)

t.test(real,fake, var.equal=TRUE)
