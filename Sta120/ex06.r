rm(list=ls())
library(tidyverse)
library(coin)
#14a)
wt <- read_csv("~/Studium/19FS/Sta120/Data/water_transfer.csv")
wilcox.test(filter(wt,age=='At term')$pd,filter(wt,age=='12-26 Weeks')$pd)
#There is a 25% chance to get these results under the null-hypothesis, so I do not reject it.
#b)
wt$age <- factor(wt$age)
oneway_test(pd ~ age, data = wt)
#The p-value is smaller, but still not small enough to reject the null-hypothesis
#c)
perm_test <- function(ya, yb, n){
  tobs <- median(ya) - median(yb)
  y <- c(ya,yb)
  tsims <- vector("list", n)
  for(i in 1:n) {
    xa <- 1:length(ya)
    xb <- 1:length(yb)
    x <- sample(y,length(y),replace = FALSE)
    for(j in 1:length(x)){
      if(j <= length(xa)){
        xa[j] <- x[j]
      } else {
        xb[j-(length(xa))] <- x[j]
      }
    }
    tsims[i] <- median(xa) - median(xb)
  }
  count <- 0
  for(x in tsims){
    if(x > abs(tobs)) {count <- count+1}
    if(x < -(abs(tobs))) {count <- count+1}
  }  
  p <- count/n
  return(p)
}
#Testing my function:
perm_test(filter(wt,age=='At term')$pd, filter(wt,age=='12-26 Weeks')$pd, 1000)
#The p-value fluctuates(that could be reduced by increasing the current n of 1000) around 0.07. This is about half of what oneway_test gave me. That makes sense, since this is a two way test.