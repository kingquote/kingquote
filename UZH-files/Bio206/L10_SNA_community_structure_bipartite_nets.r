library(UserNetR)
library(igraph)

#community detection
#modularity
#mostly with igraph
library(intergraph)
i_moreno <- asIgraph(Moreno)
V(i_moreno)$gender
plot(i_moreno, vertex.color = V(i_moreno)$gender)
#modularity by gender
modularity(i_moreno, V(i_moreno)$gender)

#Facebook
summary(Facebook)
V(Facebook)$group
table(V(Facebook)$group)
plot(Facebook, vertex.color = as.numeric(factor(V(Facebook)$group)),
     vertex.label = V(Facebook)$group)
modularity(Facebook, as.numeric(factor(V(Facebook)$group)))

#community detection
#you can save the calculation as an object
cw <- cluster_walktrap(i_moreno)
membership(cw)
table(membership(cw))
plot(cw, i_moreno)
plot(cw, i_moreno, vertex.label = V(i_moreno)$gender)
cwface <- cluster_walktrap(Facebook)

#comparing communities to attributes
table(membership(cw), V(i_moreno)$gender)
table(membership(cwface), V(Facebook)$sex)

#Affiliation networks

#creating incidence matrix
#each vector is a column and character
c1 <- c(1, 1, 1, 0, 0, 0)
c2 <- c(0, 1, 1, 1, 0, 0)
c3 <- c(0, 0, 1, 1, 1, 0)
c4 <- c(0, 0, 0, 0, 1, 1)
affil <- data.frame(c1, c2, c3, c4)
#naming rows
row.names(affil) <- c("S1", "S2", "S3", "S4", "S5", "S6")
#analysis mostly using igraph
#create incidence matrix as igraph object
iaffil <- graph.incidence(affil)
get.incidence((iaffil))
iaffil
V(iaffil)$name
V(iaffil)$type
plot(iaffil, vertex.color = V(iaffil)$type)

#coordinates for plotting
plt_x <- c(rep(2, 6), rep(4, 4))
plt_y <- c(7:2, 6:3)
lay <- as.matrix(cbind(plt_x, plt_y))
plot(iaffil, layout = lay)
#adding more graphics
shapes <- c("circle", "square")
colors <- c("blue", "red")
#without layout
plot(iaffil, vertex.color = colors[V(iaffil)$type + 1],
     vertex.shape = shapes[V(iaffil)$type + 1],
     vertex.size = 10, vertex.label.degree = -pi / 2,
     vertex.label.dist = 1.2, vertex.label.cex = 0.9)
#with layout
plot(iaffil, vertex.color = colors[V(iaffil)$type + 1],
     vertex.shape = shapes[V(iaffil)$type + 1],
     vertex.size = 10, vertex.label.degree = 0,
     vertex.label.dist = 4, vertex.label.cex = 0.9, layout = lay)

#from edge list into affiliation network
affedge <- data.frame(rbind(c("S1", "c1"),
                            c("S2", "c1"),
                            c("S2", "c2"),
                            c("S3", "c1"),
                            c("S3", "c2"),
                            c("S3", "c3"),
                            c("S4", "c2"),
                            c("S4", "c3"),
                            c("S5", "c3"),
                            c("S5", "c4"),
                            c("S6", "c4")))

iaffedge <- graph.data.frame(affedge, directed = FALSE)
#igraph does not know yet this is a bipartite network
iaffedge
V(iaffedge)$type

#to make it a bypartite network, we use name attribute
V(iaffedge)$name
#we use %in% to define type as the name in column 1 of affedge
#name in column 1 of affedge dataframe are subjects
affedge
#type of bipartite variable will be the name on column 1
V(iaffedge)$type <- V(iaffedge)$name %in% affedge[, 1]
V(iaffedge)$type
#now affedge is UN-N, undirected and bipartite
summary(iaffedge)

#create file with projections
bip_affedge <- bipartite.projection(iaffedge)
bip_affedge
#nw create projection 2 or subject network
bip_affedge$proj2
get.adjacency(bip_affedge$proj1, sparse = F, attr = "weight")
plot(bip_affedge$proj2, edge.width = E(bip_affedge$proj2)$weight * 2)
#to see weights
E(bip_affedge$proj2)$weight

#compare densities of projections etc
graph.density(bip_affedge$proj1)
graph.density(bip_affedge$proj2)
