x <- seq(0, 2*pi, 0.1)
y <- sin(x)
plot(x, y, ylab = "sin(x)", lty = "dotted", type = "l", main = "Sinusfunktion", col = "green", lwd = 3)


plot(iris$Petal.Width, iris$Sepal.Width, xlab = "Petal Width", ylab = "Sepal Width", main = "Comparison of leaf width", col = iris$Species, pch=16 )
legend("topright", legend=c("Setosa", "Versicolor", "Virginica"), col=c(1,2,3), pch=16)

