#Lecture 8 Intro II

library("readxl")
try(setwd(dirname(rstudioapi::getActiveDocumentContext()$path)), silent = TRUE)

#Example: network from edgelist
edge2 <- matrix(c("A", "B", "A", "C", "A", "G", "C",
                  "D", "C", "F", "E", "F", "E", "G"),
                  byrow = T, nrow = 7)
edge2
net2 <- network(edge2, matrix.type = "edgelist", directed = F)
summary(net2)

#note: to recode nodes (not necessary in this case), enter new names
#in the same order as in the original edgelist;
#for example, to recode letters as numbers:
#network.vertex.names(net2) <- c("1","2","3","4","5","6","7")
gplot(net2, gmode = "graph", displaylabels = T)

#converting between adjacency matrix and edgelist
as.sociomatrix(net2)
as.matrix(net2, matrix.type = "adjacency")
as.matrix(net2, matrix.type = "edgelist")
edge3 <- data.frame(as.matrix(net2, matrix.type = "edgelist"))
edge3

#node attributes
#gender
set.vertex.attribute(net2, "gender", c("F", "F", "M", "F", "M", "M", "M"))
summary(net2)
get.vertex.attribute(net2, "gender")
net2 %v% "gender"

#node degree
#note: you want to measure degree as in undirected network
#for undirected degree, add gmode="graph"
#otherwise, function will add up AB and BA and double degree!

degree(net2, gmode = "graph")
net2 %v% "degrees" <- degree(net2, gmode = "graph")
list.vertex.attributes(net2)
summary(net2)
net2 %v% "degrees"

#edge attributes
#weights
adj4 <- matrix(c(0, 10, 0, 5, 0, 0, 6, 0, 0,
      1, 1, 1, 0, 8, 1, 0), byrow = T, nrow = 4)
colnames(adj4) <- c("A", "B", "C", "D")
rownames(adj4) <- c("A", "B", "C", "D")
#now you need to use directed network so that weights are not divided by 2!!
net4 <- network(adj4, matrix.type = "adjacency", directed = T,
                ignore.eval = F, names.eval = "weights")
summary(net4)

#to see adjacency matrix
as.sociomatrix(net4)
#to see weight matrix
as.sociomatrix(net4, "weights")

#plotting with weights
gplot(net4, vertex.cex = 2, vertex.col = "red",
      displaylabels = T, gmode = "graph",
      edge.lwd = net4 %e% "weights")
list.edge.attributes(net4)
get.edge.attribute(net4, "weights")
net4 %e% "weights"

#creating weighted network from edge list
#importing from Excel
edgelist1 <- read_excel("edgelist1.xlsx")

#aggregating rows
edge6 <- aggregate(list(weights = rep(1, nrow(edgelist1))), edgelist1, length)
edge6

#creating weighted network; notice matrix type
net_weights <- network(edge6, matrix.type = "edgelist", directed = F,
                       ignore.eval = FALSE, names.eval = "weights")
summary(net_weights)

#see node attributes
list.vertex.attributes(net_weights)
#see edge attributes
list.edge.attributes(net_weights)

#see edge weights
net_weights %e% "weights"
as.sociomatrix(net_weights, "weights")
as.matrix(net_weights, matrix.type = "edgelist")

#converting between edgelist and adjacency
adj4
adj4 <- symmetrize(adj4, return.as.edgelist = T)
adj4 <- symmetrize(adj4, return.as.edgelist = F)

#filtering by gender
#net2 has gender info
net2
gplot(net2, gmode = "graph", displaylabels = T)
#inducedSubgraph to filter, 'which' to define selected values
net2males <- get.inducedSubgraph(net2, which(net2 %v% "gender" == "M"))
summary(net2males)
#new adjacency matrix only for males
net2males[, ]
gplot(net2males, gmode = "graph", displaylabels = T)

#filter by degree
net2 %v% "degrees"
net2deg <- get.inducedSubgraph(net2, which(net2 %v% "degrees" > 1))
gplot(net2deg, gmode = "graph", displaylabels = T)

#removing isolates
summary(ICTS_G10, print.adj = F)
components(ICTS_G10)
plot(ICTS_G10)

#list isolates
isolates(ICTS_G10)
#count isolates
length(isolates(ICTS_G10))

#create a copy first; delete.vertices cannot create a new object
ICTScoll <- ICTS_G10
class(ICTScoll)
delete.vertices(ICTScoll, isolates(ICTScoll))
plot(ICTScoll)

#Example: filtering by weight
summary(DHHS, print.adj = F)
DHHS %e% "collab"
table(DHHS %e% "collab")

#create copy of file
DHHSfilt <- DHHS
DHHSfilt %e% "collab"

#first create new sociomatrix, with collab as weight values
d_val <- as.sociomatrix(DHHSfilt, "collab")
#now using thresh to filter which edges to show
gplot(d_val, gmode = "graph", displayisolates = F, thresh = 3)

#create network in igraph
#you may need code from previous lecture
adj
graph1 <- graph.adjacency(adj, mode = "undirected")
graph1
edge2
graph2 <- graph.edgelist(edge2, directed = F)
graph2

#to create node names in igraph
#note: no need to run it in this example, as names already exist
V(graph1)$name <- c("A", "B", "C", "D")
#to create weight attribute
E(graph1)$weights <- c(1, 1, 10, 4, 5, 2, 1)
mean(E(graph1)$weights)
summary(graph1)

#convert into network
library(intergraph)
graph1 <- asNetwork(graph1)
class(graph1)
graph1 <- asIgraph(graph1)

#back to sna
#Visualisation
data(Moreno)
gplot(Moreno, mode = "circle", vertex.cex = 1.5, gmode = "graph")
gplot(Moreno, mode = "fruchtermanreingold", vertex.cex = 1.5, gmode = "graph")
gplot(Moreno, mode = "random", vertex.cex = 1.5, gmode = "graph")

#in igraph
detach(package:sna)
library(igraph)
library(intergraph)
#convert Bali to i_bali
i_bali <- asIgraph(Bali)

plot(i_bali, layout = layout_in_circle, main = "Circle")
plot(i_bali, layout = layout_randomly, main = "Random")
plot(i_bali, layout = layout_with_fr, main = "fruchtermanreingold")

#back to sna, notice now we use file Bali instead of i_bali
detach(package:igraph)
library(sna)

#plotting vertices with role as colours
plot(Bali, vertex.col = "role", edge.col = "grey50",
     vertex.cex = 1.5, displaylabels = T, label.pos = 5)

#node size as degree
#create vector with degrees and use it in parameter vertex.cex
deg_bali <- degree(Bali, gmode = "graph")
gplot(Bali, usearrows = F, vertex.cex = 0.2 * deg_bali, displaylabels = T,
      label = Bali %v% "role")

#plot weighted network links with edge width
plot(Bali, usearrows = F, vertex.cex = 0.2 * deg_bali, label.pos = 5,
     vertex.col = "slateblue", displaylabels = T,
     edge.lwd = (Bali %e% "IC")^1.5)
