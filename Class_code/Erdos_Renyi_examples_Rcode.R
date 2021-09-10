library(igraph)
g <- erdos.renyi.game(n=10, p.or.m = 0.1)

plot(g)



degree.sequence.game()



wsa <- watts.strogatz.game(dim = 1, size = 20, nei = 2, p =  0)
plot(wsa)

wsa1 <- watts.strogatz.game(dim = 1, size = 20, nei = 2, p = 0.1)
plot(wsa1)

ba <- barabasi.game(10, directed = F, power = 1, m = 2)
plot(ba)



list = list()

for(i in 1:500){
  temp <- erdos.renyi.game(n=30, p.or.m = 29, type = 'gnm')
  list[[i]] <-  degree(temp, v = V(temp), mode= 'all')
}
list
summary(unlist(list))
plot(density(unlist(list)))



#------------------------
# class 10/10/19

library('igraph')
j <- matrix(c(0,1,0,1,1,0,1,0, 1,0,0,0,1,0,0,0, 0,0,0,0,0,0,0,0, 1,0,0,0,1,0,0,0, 1,1,0,1,0,1,0,0, 0,0,0,0,1,0,0,0, 1,0,0,0,0,0,0,1, 0,0,0,0,0,0,1,0), nrow=8, byrow=T)
ji <- graph.adjacency(j)
plot(ji, edge.arrow.size=0, vertex.size=20, vertex.label.cex=1.6, vertex.color='black', vertex.label.color='pink') 

cliques(ji) # gives all cliques
# note that the output even includes single nodes, as well as dyads

largest.cliques(ji) # gives the largest cliques within the network

coreness(ji, mode="all")

V(ji)$color <-  coreness(ji)
plot(ji, edge.arrow.size=0, vertex.size=20, vertex.label.cex=1.6)

# Modularity 
# A “subgroup” of nodes is a set with more internal links and fewer to nodes outside the set (higher density within the set)
# Modularity: the proportion of links that fall within a group minus the proportion expected if links were distributed randomly
# Suppose in this simple network, nodes 1,2,4, and 5 are in a particular class
V(ji)$class1 <- c(1,1,2,1,1,2,2,2)
modularity(ji, V(ji)$class1) # modularity can range from -0.5 to 1.0
# What if nodes 7 and 8 are in their own group?
V(ji)$class2 <- c(1,1,2,1,1,2,3,3)
modularity(ji, V(ji)$class2) # is the modularity higher now?


jigroups <- cluster_walktrap(ji) # one community detection algorithm
membership(jigroups) # which detected community is each node in?
modularity(jigroups) # what is the modularity for this set of communities?
# Use module info for plotting
plot(jigroups,ji,edge.arrow.size=0)


# https://cran.r-project.org/web/packages/ergm/vignettes/ergm.pdf 
# install the statnet suite, if you haven’t yet, and load it
library(statnet)
# the “coda” package is recommended for some parts of tutorial – you can install it, if you haven’t yet, and load it
library(coda)

set.seed(123)
data(package='ergm') # loads data sets from a designated package
data(florentine) # loads flomarriage and flobusiness data
flomarriage # Let's look at the flomarriage data
plot(flomarriage) # Let's view the flomarriage network

# the simplest model is a random graph model
flomodel.01 <- ergm(flomarriage~edges) # fit model
summary(flomodel.01) # gives summary of model fit

# the number of completed triangles is one measure of clustering
flomodel.02 <- ergm(flomarriage ~ edges + triangle)
summary(flomodel.02)
# note that results will vary each time because of stochastic simulation

flomodel.03 <- ergm(flomarriage ~ edges + nodecov('wealth'))
summary(flomodel.03)
# nodecov is testing whether edge probabilities are a function of wealth.
# this time, the p-value associated with the new part of the model, nodecov(‘wealth’), is low
# And the AIC is lower than the AIC for the simpler model, indicating that nodecov(‘wealth’) is a useful addition to the model

# The package documentation is not completely clear, but it appears that the sum of “wealth” for node i and “wealth” for node j is used in estimating the probability that there is a link between node i and node j
help(nodecov)

wealth <- flomarriage %v% 'wealth' # the %v% extracts vertex info
wealth # attribute from the network
# 10 36 55 44 20 32 8 42 103 48 49 3 27 10 146 48
plot(flomarriage, vertex.cex=wealth/25) 
# network plot with vertex size proportional to wealth


