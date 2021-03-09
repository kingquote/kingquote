library(igraph)
#Network modelling

#random networks
#for model with m edges, use type="gnm"
#for model with edge prob p, use type = "gnp"
rand1 <- erdos.renyi.game(100, 0.05, type = "gnp")
plot(rand1, vertex.color = "lightblue",
     main = "random 1", layout = layout.fruchterman.reingold)

#properties
degree(rand1)
degree.distribution(rand1)
plot(degree.distribution(rand1), type = "b")
transitivity(rand1)

#diameter
#let's create three sets of 50 random networks of sizes n=100, 1000, 10000
#create vector with 50 values of 100, 1000 and 10000
n_vect <- rep(c(100, 1000, 10000), each = 50)

#create 50 random networks of each size n and p=10/n-1
#and calculate diameter with a function
#NOTE: Patience! calculation of this step takes a long time
g_diam <- sapply(n_vect, function(x)
  diameter(erdos.renyi.game(n = x, p = 10 / (x - 1))))

#create a data frame with each network and its diameter
d_by_n <- data.frame(netsize = as.factor(n_vect), diameter = g_diam)
#mean diameter by betwork size
aggregate(d_by_n$diameter ~ d_by_n$netsize, FUN = mean)

#diameter by network size (numeric variable, but used as factor)
boxplot(g_diam ~ factor(n_vect))
#in lattice
bwplot(g_diam ~ factor(n_vect), panel = panel.violin,
       xlab = "Network Size", ylab = "Diameter")

#mean path length
path_l <- sapply(n_vect, function(x)
  mean_distance(erdos.renyi.game(n = x, p = 10 / (x - 1))))
d_by_n$path_length <- path_l
aggregate(d_by_n$path_length ~ d_by_n$netsize, FUN = mean)
boxplot(path_l ~ factor(n_vect))
#in lattice
bwplot(path_l ~ factor(n_vect), panel = panel.violin,
       xlab = "Network Size", ylab = "Mean Path Length", col = "orange")

#mean transitivity
trans_l <- sapply(n_vect, function(x)
  transitivity(erdos.renyi.game(n = x, p = 10 / (x - 1))))
d_by_n$transitivity <- trans_l
aggregate(d_by_n$transitivity ~ d_by_n$netsize, FUN = mean)
boxplot(trans_l ~ factor(n_vect))
#in lattice
bwplot(trans_l ~ factor(n_vect), panel = panel.violin,
       xlab = "Network Size", ylab = "Transitivity", col = "green")

#Small-world networks
#use help for definitions of dim, size, nei, and p
#always use dim = 1
#nei is numer of neighbours on each side, so nei=2 means four neighbours
g1 <- watts.strogatz.game(dim = 1, size = 20, nei = 2, p = 0)
g2 <- watts.strogatz.game(dim = 1, size = 20, nei = 2, p = .05)
g3 <- watts.strogatz.game(dim = 1, size = 20, nei = 2, p = .20)
g4 <- watts.strogatz.game(dim = 1, size = 20, nei = 2, p = 1)
#change labels to plot all sims
plot(g1, vertex.label = NA, layout = layout.circle,
     main = expression(paste(italic(p), " = 0")))

#Path length and transitivity measures
g100 <- watts.strogatz.game(dim = 1, size = 100, nei = 2, p = 0.05)
diameter(g100)
mean_distance(g100)
#global for network measure, "local gives transitivity for each node
transitivity(g100, type = "global")

#simulation of SWN path length
p_vect <- rep(1:30, each = 10)
g_diam <- sapply(p_vect, function(x)
  diameter(watts.strogatz.game(dim = 1, size = 100,
                               nei = 2, p = x / 200)))
smoothing_spline <- smooth.spline(p_vect, g_diam,
                                spar = 0.35)
plot(jitter(g_diam, p_vect, 1), col = "grey60",
     xlab = "Number of Rewired Edges",
     ylab = "Diameter")
lines(smoothing_spline, lwd = 1.5)

#Comparisons between real and model networks
library(intergraph)
library(UserNetR)

ilhds <- asIgraph(lhds)
graph.density(ilhds)
mean(degree(ilhds))

#random network, using p = density of ilhds
g_rnd <- erdos.renyi.game(1283, 0.0033, type = "gnp")

#SWN, using nei = degree of ilhds/2
g_swn <- watts.strogatz.game(dim = 1, size = 1283, nei = 2, p = 0.05)

plot(g_rnd, mode = "graph", main = "random", vertex.size = 2, vertex.label = NA,
     layout = layout_with_kk)
plot(g_swn, mode = "graph", main = "SWN", vertex.size = 2, vertex.label = NA,
     layout = layout_with_kk)
plot(ilhds, mode = "graph", main = "lhds", vertex.size = 2, vertex.label = NA,
     layout = layout_with_kk)

#comparing degree distributions
plot(degree.distribution(ilhds), type = "b", main = "lhds")
plot(degree.distribution(g_rnd), type = "b", main = "random")
plot(degree.distribution(g_swn), type = "b", main = "SWN")

#for transitivity, add type="local" to estimate individual values
#then use a boxplot and histograms
boxplot(transitivity(ilhds, type = "local"), main = "lhds")