

library(igraph)
library(dplyr)
library(scales)


#Fake data
set.seed(3)
samp <- data.frame(from= paste("From", sample(5, 28, replace = T), sep = ""),
                   to = paste("To", sample(5, 28, replace = T), sep = ""),
                   values = sample(100, 28, replace = T))
samp

samp2 <- as_tibble(samp) %>% 
         group_by(from, to) %>% 
         summarize(sum = sum(values), n= n())
samp2

#---- Creating a graph object using igraph
g <- graph_from_data_frame(as.matrix(samp2), directed = F)
plot(g) # plot without attributes

#---- Assigning node size and link width atributes
# link width from the 3rd column of the original matrix (samp2) 
E(g)$width <- log(as.numeric(E(g)$sum))
# calculating node degree  (times a constant to make the node bigger) 
V(g)$size <- degree(g)*8
#Plot node size= node degree; link width= values
plot(g)
#--
# calculating betweeness centrality 
V(g)$size <- betweenness(g)
#Plot node size= betweeness centrality; link width= values
plot(g)
#--
# calculating node strength  (times a constant to make the node bigger)
V(g)$size <- strength(g)*8
#Plot node size= betweeness centrality; link width= values
plot(g)


#---- Assigning colors to nodes by node size
# creating a palette function 
rcPal <- colorRampPalette(c("white","red")) 
# we are 'cutting' the values in
V(g)$color <- rcPal(4)[cut(V(g)$size, breaks = 4)] 
show_col(unique(V(g)$color))
plot(g)

#---- Assigning colors to nodes by node size threshold

rcPal <- colorRampPalette(c("white","plum1", "red3"))
# we are 'cutting' the values in
cond <- V(g)$size
cond[cond<30] <- 0 # setting the threshold 
cond
n <- 20#length(unique(cond))
V(g)$color <- rcPal(n)[cut(cond, breaks = n)] 
#show_col(unique(V(g)$color))
plot(g)

#---- Assigning colors to nodes by 'group'
cond <- V(g)$name # getting vertex names
cond =substr(cond, 0,1)
cols = NULL
for (i in seq_along(cond)){
  cols[i] = ifelse(cond[i]== "F", print("gray"), print("red"))
}
V(g)$color <- cols
plot(g)

#---- Assigning colors to nodes personalized 
# faking metadata
metadat <- as_tibble(
            cbind(name= V(g)$name, # getting vertex names
                  location= c(rep("loc1", 2), rep("loc2", 1), rep("loc3", 4), rep("loc4", 3)), # faking locations      
                  color= c(rep("blue", 2), rep("red", 1), rep("orange", 4), rep("yellow", 3))) # colors based on locations
            ) # rememeber, all columns need to be the same leght as the number of nodes

V(g)$color <- metadat$color
plot(g)




