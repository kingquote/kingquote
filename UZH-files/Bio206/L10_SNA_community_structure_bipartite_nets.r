
#community detection
#modularity 
#mostly with igraph
library(intergraph)
iMoreno <- asIgraph(Moreno)
V(iMoreno)$gender
plot(iMoreno, vertex.color=V(iMoreno)$gender)
#modularity by gender
modularity(iMoreno, V(iMoreno)$gender)

#Facebook
summary(Facebook)
V(Facebook)$group
table(V(Facebook)$group)
plot(Facebook, vertex.color=as.numeric(factor(V(Facebook)$group)), 
     vertex.label=V(Facebook)$group)
modularity(Facebook,as.numeric(factor(V(Facebook)$group)))

#community detection
#you can save the calculation as an object
cw <- cluster_walktrap(iMoreno)
membership(cw)
table(membership(cw))
plot(cw, iMoreno)
plot(cw, iMoreno, vertex.label=V(iMoreno)$gender)

#comparing communities to attributes
table(membership(cw), V(iMoreno)$gender)               
table(membership(cwface), V(Facebook)$sex)               

#Affiliation networks

#creating incidence matrix
#each vector is a column and character
C1 <- c(1,1,1,0,0,0)
C2 <- c(0,1,1,1,0,0)
C3 <- c(0,0,1,1,1,0)
C4 <- c(0,0,0,0,1,1)
affil <- data.frame(C1,C2,C3,C4)
#naming rows
row.names(affil) <- c("S1","S2","S3","S4","S5","S6")
#analysis mostly using igraph
#create incidence matrix as igraph object
iaffil <- graph.incidence(affil)
get.incidence((iaffil))
iaffil
V(iaffil)$name
V(iaffil)$type
plot(iaffil, vertex.color=V(iaffil)$type)

#coordinates for plotting
plt.x <- c(rep(2,6),rep(4,4))
plt.y <- c(7:2,6:3)
lay <- as.matrix(cbind(plt.x,plt.y))
plot(iaffil,layout=lay)
#adding more graphics
shapes <- c("circle","square")
colors <- c("blue","red")
#without layout
plot(iaffil,vertex.color=colors[V(iaffil)$type+1],
     vertex.shape=shapes[V(iaffil)$type+1],
     vertex.size=10,vertex.label.degree=-pi/2,
     vertex.label.dist=1.2,vertex.label.cex=0.9)
#with layout
plot(iaffil,vertex.color=colors[V(iaffil)$type+1],
     vertex.shape=shapes[V(iaffil)$type+1],
     vertex.size=10,vertex.label.degree=0,
     vertex.label.dist=4,vertex.label.cex=0.9, layout=lay) 

#from edge list into affiliation network 
affedge <- data.frame(rbind(c("S1","C1"),
                            c("S2","C1"),
                            c("S2","C2"),
                            c("S3","C1"),
                            c("S3","C2"),
                            c("S3","C3"),
                            c("S4","C2"),
                            c("S4","C3"),
                            c("S5","C3"),
                            c("S5","C4"),
                            c("S6","C4")))

iaffedge <- graph.data.frame(affedge, directed=FALSE)
#igraph does not know yet this is a bipartite network
iaffedge
V(iaffedge)$type

#to make it a bypartite network, we use name attribute
V(iaffedge)$name
#we use %in% to define type as the name in column 1 of affedge 
#name in column 1 of affedge dataframe are subjects
affedge
#type of bipartite variable will be the name on column 1 
V(iaffedge)$type <- V(iaffedge)$name %in% affedge[,1]
V(iaffedge)$type
#now affedge is UN-N, undirected and bipartite 
summary(iaffedge)

#create file with projections
bip.affedge <- bipartite.projection(iaffedge)
bip.affedge
#nw create projection 2 or subject network
bip.affedge$proj2
get.adjacency(bip.affedge$proj1, sparse=F, attr="weight")
plot(bip.affedge$proj2, edge.width=E(bip.affedge$proj2)$weight*2)
#to see weights
E(bip.affedge$proj2)$weight

#compare densities of projections etc
graph.density(bip.affedge$proj1)
graph.density(bip.affedge$proj2)
