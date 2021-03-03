#Lecture 7 Intro

#to install UserNetR, you need first to install and load devtools
install.packages("devtools")
library(devtools)
install_github("DougLuke/UserNetR")

#also install
install.packages("statnet.common")
install.packages("sna")
install.packages("igraph")
install.packages("network")

#visualizing network
library(statnet.common)
library(sna) #this will load network package too
library(UserNetR)

#Moreno network
class(Moreno)

network.size(Moreno)
#summary
summary(Moreno)
summary(Moreno, print.adj = F)

#maximise plot window for better visualization of labels etc
#function 'plot': with package 'network'
plot(Moreno, displaylabels = T)
#gplot: need sna and network packages; PREFERABLE
gplot(Moreno)
gplot(Moreno, gmode = "graph", displaylabels = T)

#size
network.size(Moreno)
#density
gden(Moreno)
#components
components(Moreno)
#create subnetwork with largest component
comp1 <- component.largest(Moreno, result = "graph")
gplot(comp1, gmode = "graph", displaylabels = T)

#create vector with all path lengths
gd <- geodist(comp1)
#diameter and mean path length
max(gd$gdist)
mean(gd$gdist)

#transitivity (measure of clustering)
gtrans(Moreno)

#node attributes
Moreno %v% "gender"
Moreno %v% "vertex.names"

#plotting
plot(Moreno, vertex.col = Moreno %v% "gender", vertex.cex = 2)
plot(Moreno, vertex.col = c("pink", "lightblue")[Moreno %v% "gender"],
     vertex.cex = 2, displaylabels = T)

#Example: creating a network
#creating adjacency matrix using network
#create a standard matrix
adj <- matrix(c(0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0), byrow = T,
              nrow = 4)
colnames(adj) <- c("A", "B", "C", "D")
rownames(adj) <- c("A", "B", "C", "D")
adj
#Now create a network object, default is directed!!!
net1 <- network(adj, matrix.type = "adjacency", directed = F)
class(net1)
#gplot as undirected
gplot(net1, gmode = "graph", displaylabels = T)
summary(net1)


sym <- matrix(c(0, 1, 0, 1, 0, 1, 0, 1, 0), byrow = T, nrow = 3)
asym <- matrix(c(0, 1, 0, 0, 0, 1, 0, 0, 0), byrow = T, nrow = 3)
symdir <- network(sym, matrix.type = "adjacency", directed = T)
symundir <- network(sym, matrix.type = "adjacency", directed = F)
asymdir <- network(asym, matrix.type = "adjacency", directed = T)
asymundir <- network(asym, matrix.type = "adjacency", directed = F)

summary(symdir)
summary(symundir)
#difference: 4 edges vs 2 edges

summary(asymdir)
summary(asymundir)
#difference: density 0.333 vs 0.666

gplot(asymdir, gmode = "digraph", displaylabels = T)
gplot(asymundir, gmode = "graph", displaylabels = T)
#difference: arrows vs no arrows