rm(list=ls())
library(tidyverse)
library(mvtnorm)
library(ellipse)

#15a)
#             (B1X1)     (B1)  (X1)
#E(a+BX) = a+E(B2X2) = a+(B2)*E(X2) = a+B*E(X)
#             (....)     (..)  (..)
#             (BnXn)     (Bn)  (Xn)
#b)
#Steps taken, in Order:
#(A+B)^T = A^T+B^T
#Ausmultiplizieren
#E(a+b) = E(a) + E(b), as well as E(E(a)) = E(a)
#-a+a = 0
#c)
#Steps taken, in order:
#E(a+X) = a + E(X) -> a's cancel out
#(A+B)^T = A^T+B^T, as well as (A*B)^T = B^T*A^T
#Ausmultiplizieren, as well as E(a+b) = E(a) + E(b), as well as E(E(a)) = E(a)
#-a+a=0
#(A+B)^T = A^T+B^T, as well as (A*B)^T = B^T*A^T
#E(CYD) = CE(Y)D
#Ausklammern
#E(XX^T)-E(X)E(X)^T = Var(X)

#16a)
#The estimator for the mean obviously still does the same thing: calculate the empirical mean of all values
#The estimator for the variance normally uses the square to avoid cancelling out of positive and negative values, here the same thing is accomplished by multiplication with the transpose.
#b)
#E(X1:n,1) = 1
#E((X1:n,2)^2) = 4
#Cov((X1:n,1),(X2:n,2)) = 1
#c)
Sigma <- matrix(c(1,1,1,2),2)
mu <- c(1,2)
n <- 500

sample <- rmvnorm( n, mean=mu, sigma=Sigma)
plot(sample, pch='.', cex=2)
#d)
lines(ellipse( Sigma, cent=mu, level=.95), col='gray', 
     xaxs='i', yaxs='i', xlim=c(-4,8), ylim=c(-4,6), type='l')
lines( ellipse( Sigma, cent=mu, level=.5), col='gray')
eig <- eigen(Sigma,T)
points(eig$vectors,pch=18,col='red')
#e)
Sigmahat <- cov( sample)
muhat <- apply( sample, 2, mean)
corr <- cor(sample)
#f)
Sigma <- matrix(c(2,-2,-2,7),2)
sample <- rmvnorm( n, mean=mu, sigma=Sigma)
plot(sample, pch='.', cex=2)
lines(ellipse( Sigma, cent=mu, level=.95), col='gray',
      xaxs='i', yaxs='i', xlim=c(-4,8), ylim=c(-4,6), type='l')
lines( ellipse( Sigma, cent=mu, level=.5), col='gray')
#From playing with the sigma values a bit, I can see that the second and third value (which have to be the same for symmetry)
#define the inclination and shape of the ellipse, while the other two define its size in the number plane



