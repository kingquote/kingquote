#Task4
data(iris)
#a)
mean(iris$Petal.Width) #Mittelwert Bl�tenbreite
median(iris$Petal.Width) #Median Bl�tenbreite
#b)
mean(iris$Petal.Width, trim=0.1) #Mittelwert Bl�tenbreite, tiefste und h�chste 10% ignoriert
# Es f�llt auf, dass der gestutzte Mittelwert leicht tiefer ist als der 'normale', es scheint also einige wenige sehr hohe Ausreisser gegeben zu haben
#c)
sd(iris$Petal.Width) #Standardabweichung Bl�tenbreite
#vergeleichen mit:
sqrt(var(iris$Petal.Width)) #Wurzel der Varianz der Bl�tenbreite
# Ja, sie sind gleich
#d)
range(iris$Sepal.Width) #Wertebereich
min(iris$Sepal.Width) #Minimum
max(iris$Sepal.Width) #Maximum
#Ja, passt
#e)
boxplot(iris[,1:4])
#Die Verteilung von Sepal.Lenght und Sepal.Width ist eher unspektakul�r, interessant ist nur die kleine Standardabweichung von Sepal.Width, das Histogramm dort ist wahrscheinlich sehr 'spitz'. Bei Petal.Lenght und Petal.Width f�llt auf, dass beide nach unten hin die Viel gr�ssere Verteilung zeigen als nach oben.
#f)
op <- par(mfrow=c(4,1))
hist(iris$Sepal.Length, xlim = range(0,8))
hist(iris$Sepal.Width, xlim = range(0,8))
hist(iris$Petal.Length, xlim = range(0,8))
hist(iris$Petal.Width, xlim = range(0,8))
par(op)
#Man kann auch hier sehen, dass Sepal.Lenght und Sepal.Width eher unspektakul�r sind, abgesehen vom aussergew�hlich 'spitzen' Histogramm von Sepal.Width. Die Histogramme von Petal.Lenght und Petal.Width zeigen noch genauer, warum es bei der Boxplotdarstellung die 'Verzerrung' nach unten gab: offenbar sind die tieferen Werte nicht nur weiter Verteilt, es scheint sogar eine Anh�ufung besonders tiefer Werte zu geben, die sozusagen 'unabh�ngig' von der Normalverteilung der anderen Werte existiert. Ich neheme an, dass diese zwei unterschiedlichen 'Klassen' mit den verschiedenen Spezies der Iris-Blume korrelieren. Wahrscheinlich hat eine der drei Arten Ihre Bl�tenbl�tter stark reduziert.
#g)
#Mithilfe von ?iris fand ich heraus, dass die drei Spezies setosa, versicolor und virginica heissen.