
## create a dummy adjacency matrix
matrix1 <- matrix(c(1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0), nrow = 9, ncol = 9)

## plot to get an idea what it looks like 
library(igraph)
graph1 <- graph_from_adjacency_matrix(matrix1, mode = ("undirected"))
plot(graph1)

## put it on a map
library(rworldmap)
library(rworldxtra)
worldmap <- getMap(resolution = "high") #grab the world map
NorthAmerica <- worldmap[which(worldmap$REGION == "North America"),] # grab north america 

## note- there are several different ways to get maps into R. I prefer to use shapefiles from gadm.org. This is just a simple example. 

### Put network onto map
plot(NorthAmerica, xlim = c(-105, -85), ylim = c(26, 46)) ## 

coords1 <- cbind(runif(9, -110, -85), runif(9, 30, 46)) ## here we just randomly generate coordiantes for our nodes, but please use the ones you have in your data 

plot(NorthAmerica, xlim = c(-105, -85), ylim = c(26, 46))
lo <- as.matrix(coords1[,1:2]) ## set the layout to our coordinates
plot(graph1, vertex.size= 20, edge.arrow.size=.1, vertex.label.cex=.8, vertex.label.color='black', edge.curved = TRUE, layout = lo, xlim = c(100,105), ylim = c(9, 20), rescale = FALSE, add = TRUE) ## very important to set layout to "lo" (or whatever you named it above), rescale = FALSE, add = TRUE 
