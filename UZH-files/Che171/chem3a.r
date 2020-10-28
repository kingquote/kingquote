rm(list=ls())

library(tidyverse)
library(readr)

raw <- read_csv("C:/Users/kingquote/Desktop/R Scripts/Che171/raw_data_chem3a.txt")
Mc <- 6*12.011 + 12*1.008 #molar weight c
Tbc <- 81 #boiling temp c
pc <- 0.78 #density c
Ma <- 2*12.011 + 4*1.008 + 2*15.999
Tba <- 118
pa <- 1.05

end <- mutate(raw, mc = Vc*pc)
end <- mutate(end, ma = Va*pa)
end <- mutate(end, nc = mc/Mc)
end <- mutate(end, na = ma/Ma)
end <- mutate(end, Xc  = nc/(na+nc))
end <- mutate(end, Xa  = 1-Xc)

p1 <- ggplot(end,aes(x = Tube)) +
      geom_point(aes(y = Xc), col='red') +
      geom_line(aes(y = Xc), col='red') +
      geom_point(aes(y = Xa), col='green') +
      geom_line(aes(y = Xa), col='green') +
      ylab('Molar fraction') +
      theme_bw()

p2 <- ggplot(end,aes(x = Tube)) +
      geom_point(aes(y = Toil), col='blue') +
      geom_line(aes(y = Toil), col='blue') +
      geom_point(aes(y = Thead), col='black') +
      geom_line(aes(y = Thead), col='black') +
      scale_y_continuous(position = "right") +
      ylab('Temperature') +
      theme_bw()

plot(x=end$Tube, y=end$Xc, ylim=c(0,1), xlab = 'Tube', ylab = 'Molar fraction', type='l', col='black')
par(new=T)
plot(x=end$Tube, y=end$Xa, ylim=c(0,1), axes=F, xlab=NA, ylab=NA, main=NA, type='l', col='blue')
par(new=T)
plot(x=end$Tube, y=end$Toil, ylim=c(70,170), axes=F, xlab=NA, ylab=NA, main=NA, type='l', col='red')
par(new=T)
plot(x=end$Tube, y=end$Thead, ylim=c(70,170), axes=F, xlab=NA, ylab=NA, main=NA, type='l', col='orange')
axis(side = 4)
mtext(side = 4, line = -1, 'Temperature')
legend("topleft",
       legend=c('Xc', "Xa","T(oil)","T(head)"),
       lty=c(1,1), col=c("black", "blue","red","orange"))
