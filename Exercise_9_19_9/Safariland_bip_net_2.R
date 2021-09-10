# Impact through Networks: PLP 6701
#
# Introduction to R:
# Part 1: 2018-09-19 
# R Alcala, 
#
# R version 3.5.1 (2018-07-02) # check R.version
#---------------------------- SET PATH --------------------------------
# setwd("/Users/ricardoialcala/Documents/Documents-ehecatl/UFL/+UniversityofFlorida/++UF/+UF_classes/2019_Fall_TA/Exercise_9_19_9/")

#---------------------------- LOAD LIBRARIES ----------------------------------
library(igraph)
library(bipartite)

#---------------------------- LOAD DATA ---------------------------------------
# Safariland: Plant pollinator data set
data(Safariland)
# Questions about the data set? type ?Safariland

head(Safariland)
# View(Safariland)
#--------------------------- DATA STRUCTURE -----------------------------------
# Describe the structure of the data set
# How many rows?

# How many columns?

# What are the dimensions of the incidence matrix?

#---------------------------- iGraph ------------------------------------------
# Basic graph 

graph.incidence(Safariland) #Bipartite graphs have a ‘type’ vertex attribute in igraph

g <- graph_from_incidence_matrix(Safariland)

# Network attributes

V(g)$name # Check the vertex names 

V(g)$type # Check vertex types 


plot(g, vertex.label.color='black', vertex.label.dist= ((V(g)$type * 4)-2)*-1  , layout = layout_as_bipartite)
plot(g,  vertex.label.color='black')

#------------------------ adding attributes ------------------------------------
#------------------------
# Add shapes to nodes

shapes = c(rep("square", length(V(g)$type[V(g)$type == "FALSE"])), 
           rep("circle", length(V(g)$type[V(g)$type == "TRUE"])))


plot(g, vertex.shape=shapes, vertex.label.color='black')

#------------------------
# Add colors to nodes

V(g)$color <- c(rep("#046A38", length(V(g)$type[V(g)$type == "FALSE"])), 
                rep("#FA4616", length(V(g)$type[V(g)$type == "TRUE"])))


plot(g, vertex.shape=shapes, vertex.label.color='black')

#----------------------- BIPARTITE NETWORK ANALYSIS --------------------------------
#library(bipartite)
# Plot bipartite network using bipartite package
plotweb(sortweb(Safariland, sort.order="inc"), method="normal")

# Plot in matrix format
visweb(sortweb(Safariland, sort.order="dec"), type= "none", # change to nested or diagonal 
       labsize= 2, square= "interaction", text= "none", textsize= 4)


#---------------------- Calculating metrics
# Node metrics
(node.metrics <- specieslevel(Safariland))

# Exploring metrics
class(node.metrics)
# How many levels are in the list?

# node.metrics$`higher level` # Want to know about the metrics? Call ?specieslevel

# Exploring $`higher level`
(h.nd <- node.metrics$`higher level`[1]) # node degree OR node.metrics$`higher level`$degree
(h.bc <- node.metrics$`higher level`[2]) # species strength 
(h.psi <-  node.metrics$`higher level`[9]) # Pollination Service Index (PSI)

# Exploring $`lower level`
(l.nd <- node.metrics$`lower level`[1]) # node degree
(l.bc <- node.metrics$`lower level`[2]) # species strength 


# Network metrics
network.metrics <-  networklevel(Safariland)

# network.metrics # Want to know about the metrics? Call ?networklevel

network.metrics["connectance"] # Connectance

network.metrics["weighted nestedness"] # Nestedness *weighted

# Computing modularity

computeModules(Safariland) # Default method: Becket
(modularity <-  LPA_wb_plus(Safariland)) #== computeModules(Safariland, forceLPA=TRUE) 

mod <- convert2moduleWeb(Safariland, modularity)
plotModuleWeb(mod, weighted = F)

#----------------------- plotting with attributes
meta <- read.csv("metadata_Safariland.csv", as.is = T, stringsAsFactors = F )
str(meta)
head(meta, 10)

meta$colors <- ifelse(meta$Order == "Hymenoptera", "#FA4616", 
                 ifelse( meta$Order == 'Diptera', "yellow", "brown"))

# Node attributes
V(g)$name <- c(V(g)$name[1:9], meta$Species) # Replacing the names for pollinators

V(g)$color <- c(rep("#046A38", length(V(g)$type[V(g)$type == "FALSE"])),
                meta$colors)

V(g)$xx <- c(unlist(l.nd), unlist(h.psi)+10) # adding node degree and Pollination Service Index (PSI) plus a constant

plot(g, vertex.shape=shapes, vertex.label=NA, vertex.size= as.numeric(V(g)$xx))

library(qgraph)
e <- get.edgelist(g, names=FALSE)
l <- qgraph.layout.fruchtermanreingold(e,vcount=vcount(g), repulse.rad=ecount(g)^3/30000) # 
l <- layout.fruchterman.reingold(g, )
plot(g, vertex.shape=shapes, vertex.label=NA, vertex.size= as.numeric(V(g)$xx), layout= l)


#
# Fixing ego
g <- sample_pa(200, m=2)
minC <- rep(-Inf, vcount(g))
maxC <- rep(Inf, vcount(g))
minC[1] <- maxC[1] <- 0
co <- layout_with_fr(g, minx=minC, maxx=maxC,
                     miny=minC, maxy=maxC)
co <-  layout_with_fr(g, start.temp= sqrt(vcount(g)^5))
# co[1,]
plot(g, layout=co, vertex.size=30, edge.arrow.size=0.2,
     vertex.label=c("ego", rep("", vcount(g)-1)), rescale=FALSE,
     xlim=range(co[,1]), ylim=range(co[,2]), vertex.label.dist=0,
     vertex.label.color="red")

