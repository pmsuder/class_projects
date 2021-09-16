require(latentnet)
require(Bergm)

data(davis)
y <- davis

as.matrix.network.adjacency(y)

# Plot the bipartite network graph
set.seed(7)
plot(y, 
     displaylabels = TRUE, 
     edge.col = "gray",
     vertex.col = c(rep("pink", 18), rep("skyblue", 14)),
     vertex.sides = c(rep(40, 18), rep(4, 14)), 
     vertex.cex = c(rep(3.7, 18), rep(2, 14)), 
     label.cex = 0.4, 
     label.pos = 5)

# checking degenerancy, its with BERGM package
# strong priors can reduce degenerancy, but usually weak priors does not reduce degenerancy

# Model specification
formula <- y ~ edges + gwb2degree(0.7, fixed = TRUE) # undirected network
# note: this formula can be used directly in ERGM

# Prior specification for BERGMS
prior.mean = c(-2, 0) 
prior.sigma = matrix(c(1, -0.5,
                       -0.5, 2), nrow = 2) # covariance matrix
# note: BERGMs uses normal priors, it can be modify in the code
# vague prior: mean 0 and large variance, making it flat prior distribution (0, 2) 

# Prior visualisation
require(MASS)
require(mvtnorm)

r <- hcl.colors(9, "Blues 3")

set.seed(1)
z <- rmvnorm(50000, mean = prior.mean, sigma = prior.sigma)
k <- kde2d(z[, 1],
           z[, 2],
           n = 50)

image(k, col = r,
      xlab = bquote(theta[.(1)]),
      ylab = bquote(theta[.(2)]))

# Parameter estimation 
set.seed(1)
m1.posterior <- bergm(formula,
                      prior.mean = prior.mean,
                      prior.sigma = prior.sigma,
                      aux.iters = 5000, # network simulation iterations
                      main.iters = 2500, # chain, number increses with large models and complex data 
                      gamma = 1.4) # ADS parameter # the larger the data the smaller the gamma, 
                                   # it also depende on the model, realizing that the model acceptance rate
                                   # is around less than 20-25%

summary(m1.posterior) # Summary of posterior summary

plot(m1.posterior) # Plot the MCMC output

# Let's visualise the posterior density
require(MASS)
k <- kde2d(c(m1.posterior$Theta[, 1]), 
           c(m1.posterior$Theta[, 2]), 
           n = 100)

image(k, col = r,
      xlab = bquote(theta[.(1)]),
      ylab = bquote(theta[.(2)]))


# Draw a sample of 100 paramater values
# from the estimated posterior distribution
set.seed(1)
m1.sampled.pars <- m1.posterior$Theta[sample.int(100), ]

# Predictive network statistics
pred.formula <- y ~ sociality(nodes = 1:18)

s.y.obs <- summary(pred.formula) # observed
pred.formula.names <- ergm_model(pred.formula, y)$coef.names
n.stats <- length(pred.formula.names)

y.sims <- list() # list for the simulated networks
s.y.sims <- matrix(NA, nrow = 100, ncol = n.stats) # simulated statistics
colnames(s.y.sims) <- pred.formula.names

for (i in 1:100) {
   set.seed(1)
   y.sims[[i]] <- simulate(formula,
                           coef = m1.sampled.pars[i, ], 
                           nsim = 1, 
                           control = control.simulate(MCMC.burnin = 5000))
   
   y <- y.sims[[i]]
   s.y.sims[i, ] <- summary(pred.formula)
}

boxplot(s.y.sims[, 1:n.stats], las =2) # simulated distributions
lines(s.y.obs, lwd = 3, col = "red") # observed values

# Calculating Bayes Factors 
## This is calculated for Dorothy, E9, but it can be calculated to each participant
y[, ]["DOROTHY", "E9"] <- 1 # observed
s.y.1 <- summary(formula)
y[, ]["DOROTHY", "E9"] <- 0
s.y.0 <- summary(formula)
delta <- s.y.1 - s.y.0
odds <- exp(m1.sampled.pars %*% delta)
boxplot(odds)
