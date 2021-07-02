##### Lab: Meta Network Analysis

library(statnet)
library(mvmeta)

#change working directory
setwd("git_db/class_projects/MetaNetworks/")

### 1. Friendship network
data <- read.csv("Manager_friends.csv", header = T)
Fnet <- network(as.matrix(data), directed = T)

### Import and set attributes for nodes
att <- read.csv("Manager_att.csv", header = T, row.names = 1 )
set.vertex.attribute(Fnet, "age", att$age )
set.vertex.attribute( Fnet, "tenure", att$tenure )
set.vertex.attribute( Fnet, "level", att$level )
set.vertex.attribute( Fnet, "dept", att$dept )

### ERGM for the friendship network
model1 <- ergm(Fnet ~ edges + nodeicov("age") + nodeocov("age") + nodecov("tenure") +
                nodefactor("dept") + absdiff("age") + absdiff("tenure") + nodematch("dept")+
               mutual, control = control.ergm(MCMLE.maxit = 30, MCMC.burnin=10000, MCMC.interval=200, seed = 651 ))
summary(model1)
est1 <- as.matrix(summary(model1)$coefs)[,c(1,2,4)]
cov1 <- as.matrix(model1$covar) # this needed for multivariate regression

### 2. Advice-seeking network
data <- read.csv("Manager_advice.csv", header = T)
Anet <- network(as.matrix(data), directed = T)

### Import and set attributes for nodes
set.vertex.attribute(Anet, "age", att$age )
set.vertex.attribute( Anet, "tenure", att$tenure )
set.vertex.attribute( Anet, "level", att$level )
set.vertex.attribute( Anet, "dept", att$dept )

### ERGM for the advice network
model2 <- ergm(Anet ~ edges + nodeicov("age") + nodeocov("age") + nodecov("tenure") +
                 nodefactor("dept") + absdiff("age") + absdiff("tenure") + nodematch("dept")+
                 mutual, control = control.ergm(MCMLE.maxit = 30, MCMC.burnin=10000, MCMC.interval=200, seed = 651 ))
summary(model2)
est2 <- as.matrix(summary(model2)$coefs)[,c(1,2,4)]
cov2 <- as.matrix(model2$covar)

### Prepare output for meta analysis
est <- cbind(est1, est2)
theta <- est[,c(1,4)]
var <- est[,c(2,5)]^2

# IF YOU NEED TO DO THAT FOR 1000 NETWORKS, CREATE A LOOP...  

### Univarate meta-regression
# ?gwesp  and ?gewsd
## Fixed effects
umeta <- list()
K <- nrow(theta)
tab <- NULL
for (i in 1:K) {
  umeta[[i]] <- mvmeta(theta[i,]~1, S=var[i,], method="fixed")
  out <- summary(umeta[[i]])$coef[,c(1,2,4)]
  tab <- rbind(tab, out)
}
rownames(tab) <- rownames(est)
tab
write.csv(tab, "tab1.csv", na="", row.names = TRUE)

summary(umeta[[10]])


## Random effects
umeta <- list()
K <- nrow(theta)
tab2 <- NULL
for (i in 1:K) {
  umeta[[i]] <- mvmeta(theta[i,]~1, S=var[i,], method="reml")
  out <- c(t(summary(umeta[[i]])$coef[1,c(1,2,4)]), summary(umeta[[i]])$qstat$pvalue)
  tab2 <- rbind(tab2, out)
}
rownames(tab2) <- rownames(est)
tab2
write.csv(tab2, "tab2.csv", na="", row.names = TRUE)

summary(umeta[[10]])


### For Future Use. When you have more networks than variables. 
### Multivariate meta-regressions.
cov <- list(cov1, cov2)
### Fixed effects
mvm1 <- mvmeta(theta~1, S=cov, method="fixed")

### Random effects
mvm2 <- mvmeta(theta~1, S=cov, method="reml")


