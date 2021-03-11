# -*- coding: utf-8 -*-
"""
Created on Wed Mar 10 20:46:57 2021

@author: luvic
"""

#Network analysis with NetworkX

import numpy as np
import matplotlib.pyplot as plt
import matplotlib
nicered = "#E6072A"
niceblu = "#424FA4"
nicegrn = "#6DC048"

import networkx as nx

# create an empty undirectional graph without nodes or edges
G = nx.Graph()            
print(G.nodes(), G.edges())

# add a single node
G.add_node(1)    
print(G.nodes())

# add a list of nodes
G.add_nodes_from([2,3])    
print(G.nodes())
G.number_of_nodes()
print('number of nodes:', G.number_of_nodes())

# basic summary
print(nx.info(G))

# reset network
G.clear()
print(G.nodes())
G.add_nodes_from([51,52,55,"a","funny node"])

# add edge
G.add_edge(1,2)
print(G.nodes(), G.edges())
print(nx.info(G))

# create network from edgelist
G.clear()
G.add_edges_from([(1,2), (1,3)])
print(G.edges())
G.add_edges_from([(2,1)]) # adding an edge that is already present
print(G.edges())
print(G.nodes())
print(nx.info(G))

# create directional network
G = nx.DiGraph()
G.add_edges_from([(1,2), (1,3), (2,3)])
print(G.edges())
G.add_edges_from([(2,1)])
print(G.edges())

# listing neighbours of node 1
print("Neighbors",list(G.neighbors(1)))
print("Successors",list(G.successors(1)))
print("Predecessors",list(G.predecessors(1)))

# loops
# data=True to includes node attributes as dictionaries
# so far, no attributes
for node, data in G.nodes(data=True):
    print(node, data)

for n1, n2, data in G.edges(data=True):
    print(n1, " <----> ", n2, data)

# drawing basic graphs
nx.draw_networkx(G, with_labels=True)
plt.show()

G = nx.DiGraph()
G.add_edges_from([(1,2), (1,3)])
print(G.edges())
G.add_edge(2,1)
nx.draw_networkx(G, with_labels=True)
plt.axis('off')
plt.show()

# creating network from adjacency matrix

# create matrix
#𝐴ij=1 if nodes i and 𝑗 are connected, Aij=0 otherwise.
adj = np.array([[0, 0, 1],
                [1, 0, 0],
                [1, 1, 0]])

# create graph
G = nx.from_numpy_matrix(adj)
nx.draw_networkx(G, with_labels=True)
plt.axis('off')
plt.show()

#Operations

# degree
print(G.degree(0))
# a DegreeView that can be converted to a dictionary)
print(dict(G.degree()))
# only degree values
print(dict(G.degree()).values())

# local transitivity
nx.clustering(G)
# global transitivity
nx.transitivity(G)

# edge attributes
G = nx.Graph()
# adding two attributes
G.add_edge(1,2,weight=10,transport="bus")
G.add_edge(2,3,weight=5,transport="train")
# edge attributes of edge (1, 2)
print(G[1][2])

# looping
for e in G.edges():
    print(e)
# with attributes (data)
for e in G.edges(data=True):
    print(e)

for [e1, e2, w] in G.edges(data=True):
    print("%d -- %d [weight=%g];" % (e1,e2,w['weight']))


G = nx.Graph()
G.add_edge('a', 'b', weight=0.6)
G.add_edge('a', 'c', weight=0.2)
G.add_edge('c', 'd', weight=0.1)
G.add_edge('c', 'e', weight=0.7)
G.add_edge('c', 'f', weight=0.9)
G.add_edge('a', 'd', weight=0.9)

edges = [(u, v) for (u, v) in G.edges()]
weight = [d['weight']*5.0 for (u, v, d) in G.edges(data=True)]

# layout: dynamical model for node positions
pos = nx.spring_layout(G)
# draw nodes
nx.draw_networkx_nodes(G, pos, node_size=700)
# draw edges
nx.draw_networkx_edges(G, pos, edgelist=edges, width=weight)
# draw labels
nx.draw_networkx_labels(G, pos, font_size=20)
plt.axis('off')
plt.show()

# diamater and average path length
nx.diameter(G)
nx.average_shortest_path_length(G)
# with weight
nx.average_shortest_path_length(G, weight="weight")

#Exercise: create network with 50 nodes and 50 edges with random weights
G = nx.Graph()
G.add_nodes_from([i for i in range(50)])
for i in range(50):
    node1, node2 = np.random.choice(list(G.nodes()),2)
    G.add_edge(node1,node2)

for i,j, data in G.edges(data=True):
    data['weight'] = np.random.random()
print(list(G.edges(data=True)))

elarge = [(u, v) for (u, v, d) in G.edges(data=True) if d['weight'] > 0.5]
esmall = [(u, v) for (u, v, d) in G.edges(data=True) if d['weight'] <= 0.5]

pos = nx.spring_layout(G)

# nodes
nx.draw_networkx_nodes(G, pos, node_size=10)
# edges
nx.draw_networkx_edges(G, pos, edgelist=elarge, width=3)
nx.draw_networkx_edges(G, pos, edgelist=esmall,
                       width=2, alpha=0.5, edge_color='r', style='dashed')

# Model networks

#random graph networks
# create random graph with 1000 nodes and prob of edge p=0.01
G = nx.erdos_renyi_graph(1000, 0.01)
# create list of degrees
x = [G.degree([i][0]) for i in range(len(G))]

# plot histogram with degree distribution
plt.figure(figsize=[10,5])
plt.hist(x, facecolor='b', alpha=.5, rwidth=.8)
plt.show()

# alternative
degree = np.array(G.degree())[:,1:]
plt.hist(degree, 10, density=True, facecolor='g', alpha=.2)

#connected components
ER_graph=nx.erdos_renyi_graph(100, 0.01)
nx.draw_networkx(ER_graph, with_labels=False,node_size=10, node_color=niceblu)
plt.axis('off')
plt.show()

for c in nx.connected_components(ER_graph):
    print(c)
#how many components
len(sorted(nx.connected_components(ER_graph)))

#centrality
nx.betweenness_centrality(ER_graph)

#importing
file_name = 'hgcamp.txt'
G=nx.read_weighted_edgelist(file_name, nodetype=int)
print(G.number_of_nodes())
print(nx.info(G))

nx.draw_networkx(G, with_labels=True)
plt.axis('off')
plt.show()



#small-world network
#here, nei=number of neighbours on both sides
SW_graph = nx.watts_strogatz_graph(20, 4, 1)
nx.draw_networkx(SW_graph, with_labels=False,node_size=40, node_color=nicegrn, edge_color='grey')
plt.axis('off')
plt.show()

#References

# analyses
#https://networkx.github.io/documentation/stable/reference/algorithms/index.html

# plotting
#https://networkx.github.io/documentation/latest/reference/drawing.html
