require(latentnet)
require(Bergm)

data("faux.mesa.high")
y <- faux.mesa.high
y

#
r <- hcl.colors(2, "RdYlBu")
set.seed(7)
par(mfrow = c(1, 2)) 
plot(y, 
     vertex.cex = 1,
     edge.col = "grey",
     vertex.col = r[factor(y %v% "Sex")])

legend("topright", 
       pt.bg  = unique(r[factor(y %v% "Sex")]), 
       pt.cex = 1.2,
       pch    = 21, 
       legend = levels(factor(y %v% "Sex")), 
       title  = "Sex")

r <- hcl.colors(5, "Zissou 1")
set.seed(7)
plot(y, 
     vertex.cex = 1,
     edge.col = "grey",
     vertex.col = r[factor(y %v% "Race")])

legend("topright", 
       pt.bg  = unique(r[factor(y %v% "Race")]), 
       pt.cex = 1.2,
       pch    = 21, 
       legend = levels(factor(y %v% "Race")), 
       title  = "Race")
##

# Model specification
formula <- y ~ edges +
  nodematch("Sex") +
  nodematch("Race") +
  gwdegree(0.7, fixed = TRUE)

# Prior specification
# Edge count = -4 # because 
# Sex homophily = 2 # because there is a tendency to cluster by sex
# Race homophily = 2 # because there is a tendency to cluster by race
# Geometrically weighted degree distribution = 0 # because I don't have one
prior.mean = c(-4, 2, 2, 0)
prior.sigma = diag(2, 4)

# Parameter estimation
## Aproximate approach by using the function evidence
## Estimating the pseudo-posterior distribution from an adjusted pseudo-likelihood 
m2.posterior <- evidence(formula,
                         evidence.method = "CJ", # or PP
                         prior.mean = prior.mean,
                         prior.sigma = prior.sigma,
                         aux.iters = 50000, # pseudo-ERGM args
                         aux.thin = 10000,  # simlar lenght as aux.iters
                         n.aux.draws = 50,  #
                         ladder = 100,      # pseudo-ERGM estimation 
                         V.proposal = 1.5,  # adjusted pseudo-posterior args,   
                                            # if acceptancerates are lower to 20/25% increse by 0.1
                         burn.in = 1000,      #
                         main.iters = 50000,  #
                         num.samples = 10000, # for the evidence estimation
                         estimate = "MLE", # CD or MLE it's better
                         seed = 1)

summary(m2.posterior)
# getting negative node density, positive homophily for sex and race, and negative GWDE
plot(m2.posterior)

# Model assesment: redrawing many networks from the posterior (compared to gof, that makes many networks from the likelihood)
set.seed(1)
m2.bgof <- bgof(m2.posterior,  
                sample.size = 100, # number of parameters drawn from the posterior
                aux.iters = 30000, 
                n.deg = 20,  # number of degree values to display
                n.dist = 10, # number of geodesic distance values to display
                n.esp = 7)   # number of ESP values to display

# The GOF was bad, so we wll make a new model - probably a better model

# This model is gwesp is changed to 0.2
formula <- y ~ edges +
  nodematch("Sex") +
  nodematch("Race") +
  gwesp(0.2, fixed = TRUE)

# Prior specification
# Edge count = -4 # because 
# Sex homophily = 2 # because there is a tendency to cluster by sex
# Race homophily = 2 # because there is a tendency to cluster by race
# Geometrically weighted degree distribution = 1 # because now we know is positive
prior.mean = c(-4, 2, 2, 1) # 
prior.sigma = diag(2, 4)

# Bayes Factor evidence
m3.posterior <- evidence(formula,
                         evidence.method = "CJ", 
                         prior.mean = prior.mean,
                         prior.sigma = prior.sigma,
                         aux.iters = 10000, 
                         aux.thin = 10000,  
                         n.aux.draws = 50,  
                         ladder = 100,
                         V.proposal = 1.5,    
                         burn.in = 1000,      
                         main.iters = 50000,  
                         num.samples = 10000, 
                         estimate = "MLE",
                         seed = 1)

summary(m3.posterior)

plot(m3.posterior)


# bgof
set.seed(1)
m3.bgof <- bgof(m3.posterior,  
                sample.size = 100, 
                aux.iters = 30000,
                n.deg = 20, 
                n.dist = 10, 
                n.esp = 7)

## Bayes Factor
paste("M2 v M3 log evidence:", m2.posterior$log.evidence - m3.posterior$log.evidence)
# model 2 vs 1 in terms of log(BFij)
# The log bayes factor indicate that M2 is better than M3
# notes: We should not use GOF as a indicator of model selection, because you can parametrize your model,
#        but it will perform better, but this not an indicative of the best model

# Table of Bayes Factor
> 4.6 Mi
< 4.61 Mj
= 1.1 to 1.1 no difference between models 
3.40 to .61 Very strong evidence for Mi
2.30 to 3.40 Strong evidence for Mi
1.10 to 2.30 Substantial evidence for Mi
−1.10 to 1.10 Not worth more than a bar
−2.30 to −1.1 Substantial evidence for Mj
−3.40 to −2.30 Strong evidence for Mj
−4.61 to -3.40 : Very strong evidence for Mj