library(statnet.common)
library(sna)
library(UserNetR)

#Analysis

#centrality measures
centra <- data.frame(name = Bali %v% "vertex.names",
  degree = degree(Bali, gmode = "graph"))
mean(degree(Bali, gmode = "graph"))
hist(degree(Bali, gmode = "graph"), breaks = seq(0, 20, 1))

centra$closeness <- closeness(Bali, gmode  = "graph")
mean(closeness(Bali, gmode = "graph"))
hist(closeness(Bali, gmode = "graph"), breaks = seq(0, 1, 0.1))

centra$betweenness <- betweenness(Bali, gmode = "graph")
mean(betweenness(Bali, gmode = "graph"))
hist(betweenness(Bali, gmode = "graph"))

centra <- centra[order(centra$degree, centra$closeness, centra$betweenness), ]

#reputation
#file FIFA_Nether
summary(FIFA_Nether)
as.sociomatrix(FIFA_Nether, "passes")

##use this for FIFA_Nether exercise
gplot(FIFA_Nether, displaylabels = T, label = FIFA_Nether %v% "lname",
      edge.lwd = 0.25 * (FIFA_Nether %e% "passes"),
      edge.col = FIFA_Nether %e% "passes")

fifa_centra <- data.frame(name = FIFA_Nether %v% "lname",
  degree = degree(FIFA_Nether),
  closeness(FIFA_Nether),
  betweenness(FIFA_Nether))
fifa_centra <- fifa_centra[order(fifa_centra$degree,
      fifa_centra$closeness, fifa_centra$betweenness), ]

#cutpoints
cutpoints(Moreno, mode = "graph", return.indicator = F)
#coloring the cutpoints
#don't forget mode="graph" for undirected graphs
cuts <- cutpoints(Moreno, mode = "graph", return.indicator = T)
cuts
gplot(Moreno, gmode = "graph", vertex.col = cuts + 1, displaylabels = T)

cuts <- cutpoints(Bali, mode = "graph", return.indicator = T)
gplot(Bali, gmode = "graph", vertex.col = cuts + 1, displaylabels = T)

#Subgroups
#drawing network using formula
#subgroups use igraph very often
detach(package:sna)
library(igraph)

#let's create a simple network
subs <- graph.formula(A:B:C:D--A:B:C:D, D-E, E-F-G-E)
plot(subs)

#now to identify cliques
#size of largest clique
clique.number(subs)
#list cliques of a certain size
cliques(subs, min = 3)
#excluding cliques within a clique
maximal.cliques(subs, min = 3)
largest.cliques(subs)

#k-cores
coreness(subs)
table(coreness(subs))

V(subs)$colour <- coreness(subs)
#the line above is useless.. the "colour" attribute is never used
plot(subs, vertex.label.cex = 0.8, vertex.color = coreness(subs),
     vertex.label = coreness(subs))


library(intergraph)
i_dhhs <- asIgraph(DHHS)

table(coreness(i_dhhs))

plot(i_dhhs, vertex.label.cex = 0.8, vertex.color = coreness(i_dhhs),
     vertex.label = coreness(i_dhhs))
#13 is the largest k-core, there are 24 of it

#his version:
#k-core: more complex example; always in igraph

summary(i_dhhs)
#here we are selecting only collab > 2 (edge property) to include only
#collaborators but coreness is still calculated based on degrees
i_dhhs2 <- subgraph.edges(i_dhhs,E(i_dhhs)[collab > 2])
summary(i_dhhs2)
plot(i_dhhs2, gmode = "graph")

#calculating coreness
coreness <- graph.coreness(i_dhhs2)
coreness
V(i_dhhs2)$color <- coreness
plot(i_dhhs2, vertex.col = coreness, vertex.label = coreness)