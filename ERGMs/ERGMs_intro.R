install.packages("ergm")
packageVersion("ergm")
library(ergm)

# The really importan thing for the general form

# P(Y=y) = exp(\theta^'g(y))/k(\theta)
# Which g(y) you can use for your model, the most basic g(y).
# Researcher decide what g(y) - usually edges
# It can include information about the nodes itself, usually
# people, race, gender, etc.. are the covariates, that can be
# used in the g(y) function.
# The ERGM can be derived to a logit regression
# logit(Y_ij = 1|y_ij^c)= \theta'\delta(y_ij)
# where
# \delta(y_ij)=g(y_ij^+)-g(y_ij^-)
# Delta is the change statistic, putting a 1 and a 0, and compare
# both g statistics.

#--------- example
data(package= 'ergm')
# using the dataset g4, calling 
data(g4)

# Florentine plots
set.seed(123)
data(florentine)
class(flomarriage)
flomarriage

par(mfrow=c(1,2))
plot(flomarriage, 
     main = "Florentine marriage", 
     label = network.vertex.names(flomarriage))

wealth <- flomarriage %v% 'wealth' #%v% references vertex attr
wealth
plot(flomarriage, 
     vertex.cex=wealth/25, 
     main="Florentine marriage by wealth", cex.main=0.8) # Plot the network with vertex size proportional to wealth

# A simple Bernoulli (“Erdos/Renyi”) model
summary(flomarriage ~ edges) # Look at the $g(y)$ statistic for this model
flomodel.01 <- ergm(flomarriage ~ edges) # Estimate the model 
summary(flomodel.01) # Look at the fitted model object

# checking extras 
# terms?ergm

# searching triangles
summary(flomarriage ~ triangles)

#check the website http://statnet.org/Workshops/ergm_tutorial.html#1_Statistical_network_modeling_with_ERGMs

#---------
set.seed(321)
summary(flomarriage~edges+triangle) # Look at the g(y) stats for this model
flomodel.02 <- ergm(flomarriage~edges+triangle) 
summary(flomodel.02)

# you CANT ESTIMATE the likelihood of the model, so we approach by using MCMLE

#log odds transformation into the probability scale
plogis(coef(flomodel.02)[[1]] + (0:2) * coef(flomodel.02)[[2]])
   # it was arbitrary to call it at (0:2), it can go up to more, let's say 5

class(flomodel.02) # this has the class ergm
names(flomodel.02) # the ERGM object contains lots of components.
coef(flomodel.02) # you can extract/inspect individual components

#--------
data(faux.mesa.high) # dataset highschool 
mesa <- faux.mesa.high 
#-- plot mesa
set.seed(1)
mesa
#
par(mfrow=c(1,1)) # Back to 1-panel plots
plot(mesa, vertex.col='Grade')
legend('bottomleft',fill=7:12,
       legend=paste('Grade',7:12),cex=0.75)

# homophily effect
# there is an increase likelihood by it

fauxmodel.01 <- ergm(mesa ~edges + 
                       nodefactor('Grade') + nodematch('Grade',diff=T) +
                       nodefactor('Race') + nodematch('Race',diff=T))
    # diff= TRUE is telling that we know that GRADE or RACE its part of the expected
    # para plantas usa F, no tiene nada que ver la planta respecto al virus
# node factor is for continuous
# node cov is for categorical / quantitative data
summary(fauxmodel.01)

#Note for -Inf, you can collapse smallest covariates
fauxmodel.02 <- ergm(mesa ~edges + 
          nodefactor('Grade') + nodematch('Grade',diff=T) +
          nodefactor('Race') + nodematch(COLLAPSE_SMALLEST("Race", 3, "Other"), diff=T))
summary(fauxmodel.02)


#Note: If using triangles we lost the property of interdependency among nodes
#------------------------------------------------------------
#------ missing data
set.seed(4)
missnet <- network.initialize(10,directed=F) # initialize an empty net with 10 nodes
missnet[1,2] <- missnet[2,7] <- missnet[3,6] <- 1 # add a few ties
missnet[4,6] <- missnet[4,9] <- missnet[5,6] <- NA # mark a few dyads missing
summary(missnet)

# plot missnet with missing dyads colored red. 
tempnet <- missnet
tempnet[4,6] <- tempnet[4,9] <- tempnet[5,6] <- 1
missnetmat <- as.matrix(missnet)
missnetmat[is.na(missnetmat)] <- 2
plot(tempnet,label = network.vertex.names(tempnet),
     edge.col = missnetmat)
# fit an ergm to the network with missing data identified
summary(missnet~edges)
# fitting ergm
summary(ergm(missnet~edges))

# fit an ergm missing dyads
missnet_bad <- missnet # create network with missing dyads set to 0
missnet_bad[4,6] <- missnet_bad[4,9] <- missnet_bad[5,6] <- 0

# fit an ergm to the network with missing dyads set to 0
summary(missnet_bad)

summary(ergm(missnet_bad~edges))

