rm(list=ls())
library(tidyverse)

l <- data.frame(normal = rnorm(1000, 0, 1),
uniform <- runif(1000, 0, 1),
skewedl <- rbeta(1000,5,2),
skewedr <- rbeta(1000,2,5),
normallog <- rlnorm(1000, 0, 1),
poisson <- rpois(1000, 0.5),
binomial <- rbinom(1000, 10, 0.5))

ggplot(l) +
  geom_histogram(mapping=aes(x=normal), bins = 30)
qqnorm(l$normal)
qqline(l$normal)

ggplot(l) +
  geom_histogram(mapping=aes(x=uniform), bins = 30)
qqnorm(l$uniform)
qqline(l$uniform)

ggplot(l) +
  geom_histogram(mapping=aes(x=skewedl), bins = 30)
qqnorm(l$skewedl)
qqline(l$skewedl)

ggplot(l) +
  geom_histogram(mapping=aes(x=skewedr), bins = 30)
qqnorm(l$skewedr)
qqline(l$skewedr)

ggplot(l) +
  geom_histogram(mapping=aes(x=normallog), bins = 30)
qqnorm(l$normallog)
qqline(l$normallog)

ggplot(l) +
  geom_histogram(mapping=aes(x=poisson), bins = 30)
qqnorm(l$poisson)
qqline(l$poisson)

ggplot(l) +
  geom_histogram(mapping=aes(x=binomial), bins = 30)
qqnorm(l$binomial)
qqline(l$binomial)

