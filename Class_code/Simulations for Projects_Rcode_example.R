### Disease spread


## Read in a function which will allow for spread over time
diseaseSpreader <- function(mat, startnode, p, timesteps, sims){
  nodnum <- nrow(mat)
  nn <- nodnum*nodnum
  mat <-  as.matrix(mat)
  diag(mat) <-1
  vec <- rep(0, nodnum)
  vec[c(startnode)] <- 1
  NodesNew <- rep(1:nodnum,timesteps*sims)
  Vec <- matrix(rep(vec,12),12,byrow = T)
  Status <- NULL
  Step <- NULL
  Sim <- NULL
  
  for(j in 1:sims){
    Sim <- c(Sim,rep(j,nodnum*timesteps))
    
    for(i in 1:timesteps){
      MatrixRun <- matrix(runif(nn)< p, ncol =length(vec), nrow = length(vec))
      MatrixRun <- MatrixRun*1
      MatrixRun <- MatrixRun*mat
      diag(MatrixRun) <- 1
      Vec[i+1,] <- Vec[i,] %*% MatrixRun
      Vec[i+1,] <- as.numeric(Vec[i+1,] > 0)
      Status <- c(Status ,Vec[i+1,])    
      Step <- c(Step, rep(i, nodnum))
    }
  }
  temp <- cbind(NodesNew,Sim, Step, Status)
  temp <- as_tibble(temp)
  out <- temp %>%
    group_by(Sim, Step) %>%
    summarise(Number_of_Nodes = sum(Status))
  return(out)
}


###read in your matrix, here is a 9x9 matric as a test
matrix1 <- matrix(c(1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0), nrow = 9, ncol = 9)

## plot to get an idea what it looks like 
library(igraph)
plot(graph1)
graph1 <- graph_from_adjacency_matrix(matrix1, mode = ("undirected"))


### run the above function on our matrix
# - mat = your matrix
# - p = the probability that an infection will occur between a linked healthy and infected node (1 means that thre is 100% chance that spread will occur)
# - startnode = the node number that we would like the infection to start at
# - timesteps = number of timesteps that we would like spread to occur
# - sims = number of times we would like to repeat the simulation. If there is a <1 probability of transmission, we will get slightly different outcomes for each simulation. 


# run function 
A <- diseaseSpreader(mat = matrix1, p = .1, startnode = 3, timesteps =  10, sims = 10)
View(A) ## note that the output does not include the starting conditions (timestep 0, where only the node that we designated is infected)

# here is one option for plotting the data 
plot <-  ggplot(data = A, mapping = (aes(x = Step, y = Number_of_Nodes))) + 
  geom_point() +
  geom_smooth() +
  theme_classic(base_size = 22) +
  xlab("Timestep") +
  ylab("Number of Nodes Infected") +
  scale_x_continuous(breaks = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
                     label = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
plot

