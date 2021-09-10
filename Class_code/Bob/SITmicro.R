#set working directory:
setwd("Documents/Documents-ehecatl/UFL/+UniversityofFlorida/++UF/+UF_classes/2019_Fall_TA/Shannon_code/Bob/")

#import file and secure to new short name: 
z<-read.csv("microbiota SIT.csv", header = TRUE, na.strings = "na")
z

# load packages
# install.packages("tidyr")
# install.packages("dplyr")
# install.packages("igraph")
# install.packages("bipartite")

library("tidyr")
library("dplyr")
library("igraph")
library("bipartite")

#change data to wide format
widedata <- spread(z, Bacteria, prevelance)
widedata

rownames(widedata) <- widedata$treatment
#remove treatment column
widedata2 <- (widedata[,-1]) #remove treatment column
widedata2
#graph to incidence - transform to bipartite matrix
SITmicro <- graph_from_incidence_matrix(widedata2, weighted = T)
SITmicro
#Change shapes of treatment (square) and bacteria (curcle)
shapes = c(rep("square", length(V(SITmicro)$type[V(SITmicro)$type == "FALSE"])), 
           rep("circle", length(V(SITmicro)$type[V(SITmicro)$type == "TRUE"])))
#Change color of treatment node (green) and bacteria node (red)
V(SITmicro)$color <- c(rep("#046A38", length(V(SITmicro)$type[V(SITmicro)$type == "FALSE"])), 
                rep("#FA4616", length(V(SITmicro)$type[V(SITmicro)$type == "TRUE"])))
#plot graph of bipartite network
plot(SITmicro, vertex.shape=shapes, vertex.label.color='black', layout = layout_as_bipartite)





#alternative attempts
plot(SITmicro, vertex.shape=shapes, vertex.label.color='black', vertex.layout = layout_as_bipartite, vertex.label.degree = pi)
#Don't know how to add weighted links
# adding weights

# With ceillign you get  a single numeric argument x and returns a 
#numeric vector containing the smallest integers not less than the 
#corresponding elements of x.
# Function log 10 with ceilling
log10_ceiling <- function(x) {
  10^(ceiling(log10(x)))
}
# check the procedure
E(SITmicro)$weight
log10_ceiling(E(SITmicro)$weight)
log2(E(SITmicro)$weight)
# Adding weights as width 
E(SITmicro)$width <- log10_ceiling(E(SITmicro)$weight)/1000

# 3D layout
plot(SITmicro,  edge.vertex.label.color='black', vertex.size=5, layout=layout_with_kk(SITmicro))
plot(SITmicro,  edge.vertex.label.color='black', vertex.size=5, vertex.label= NA, layout=layout_with_kk(SITmicro))



#don't know how to rotate vertex (node) names

# moving labels, but could not make it rotate
plot(SITmicro, vertex.shape=shapes, vertex.label.color='black', vertex.label.dist= ((V(SITmicro)$type * 6)-3)*-1
     ,layout = layout_as_bipartite)
