#Task4
data(iris)
#a)
mean(iris$Petal.Width) #Mittelwert Blütenbreite
median(iris$Petal.Width) #Median Blütenbreite
#b)
mean(iris$Petal.Width, trim=0.1) #Mittelwert Blütenbreite, tiefste und höchste 10% ignoriert
# Es fällt auf, dass der gestutzte Mittelwert leicht tiefer ist als der 'normale', es scheint also einige wenige sehr hohe Ausreisser gegeben zu haben
#c)
sd(iris$Petal.Width) #Standardabweichung Blütenbreite
#vergeleichen mit:
sqrt(var(iris$Petal.Width)) #Wurzel der Varianz der Blütenbreite
# Ja, sie sind gleich
#d)
range(iris$Sepal.Width) #Wertebereich
min(iris$Sepal.Width) #Minimum
max(iris$Sepal.Width) #Maximum
#Ja, passt
#e)
boxplot(iris[,1:4])
#Die Verteilung von Sepal.Lenght und Sepal.Width ist eher unspektakulär, interessant ist nur die kleine Standardabweichung von Sepal.Width, das Histogramm dort ist wahrscheinlich sehr 'spitz'. Bei Petal.Lenght und Petal.Width fällt auf, dass beide nach unten hin die Viel grössere Verteilung zeigen als nach oben.
#f)
op <- par(mfrow=c(4,1))
hist(iris$Sepal.Length, xlim = range(0,8))
hist(iris$Sepal.Width, xlim = range(0,8))
hist(iris$Petal.Length, xlim = range(0,8))
hist(iris$Petal.Width, xlim = range(0,8))
par(op)
#Man kann auch hier sehen, dass Sepal.Lenght und Sepal.Width eher unspektakulär sind, abgesehen vom aussergewöhlich 'spitzen' Histogramm von Sepal.Width. Die Histogramme von Petal.Lenght und Petal.Width zeigen noch genauer, warum es bei der Boxplotdarstellung die 'Verzerrung' nach unten gab: offenbar sind die tieferen Werte nicht nur weiter Verteilt, es scheint sogar eine Anhäufung besonders tiefer Werte zu geben, die sozusagen 'unabhängig' von der Normalverteilung der anderen Werte existiert. Ich neheme an, dass diese zwei unterschiedlichen 'Klassen' mit den verschiedenen Spezies der Iris-Blume korrelieren. Wahrscheinlich hat eine der drei Arten Ihre Blütenblätter stark reduziert.
#g)
#Mithilfe von ?iris fand ich heraus, dass die drei Spezies setosa, versicolor und virginica heissen.
