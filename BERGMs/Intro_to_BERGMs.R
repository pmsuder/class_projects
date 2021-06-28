# Bayesian Exponential Random Graph Models (BERGMs)
# Workshop: Alberto Caimo, Jun 21, 2021


# Examples
# one mode network
# bipartit network 


## Topics
# Model degenerancy issues in respect to ergm 


#ERGMs, 
# Regression functions, with statistics that are working as covariates
# using binary or any other kind of data

# ERGM uses MCMC 
# More than 20 nodes is problematic
# BERGMs uses something different
# Will solve some ERGs, but double the problems

# Introduction:

# We are finding the value of Theta, we need to estimate Theta
# We are using Theta as a variable
# The adjancency matrix is a realization of a Random Variable (RV)
# a realization of the random variable, the dyads are realized for each node
# in Bayesian, Theta is an unobserved random variable
#              the only way to describe it, is in a probability distribution
#              finding the probablility distribution on Theta
#              and we will get the parameter posterior distribution using the Bayer theorem
# Collect network data y;
# Define a model - set or multiple set of network statistics - at least one model to estimate
#                  non nested models - having completely different network statisttics 

# Bayes Theorem
# Posterior distribution, equal the ERG time the prior, divided by the marginal likelihood
# p(\Theta/y) = f(y|\Theta) p(Theta)/p(y)
# ERGM = f(y|\theta)
# prior = p(\theta) # using uninformative priors or any other kind
# marginal likelihood orevidence = p(y)


# Sparcity it cause the network 
# the prior makes the paramater space estimation "bounded" to the prior
# Not using conjugate prior 

# Bayesian approach is more computattional intensive models
# but will allow us to get a more complete picture of the model-
# for each interval (credible interval) we will have a prob. dist.
# - this is getting the theta and what interval we will have

## If you have two or more competing ERGMs, 
# we can compute the model evidence of p(y), of the data generated from one model
# and another model, then we can do a comparison
# Computing bayes factor = is the ratio of the model evidence 
# 
# p(\Mu_i|y)/P(\Mu_j|y) = P(y|\Mu_i)/P(y|\Mu_j) x p(\Mu_i)/p(\Mu_j)
# probability distribution equals to the bayes factor times the model priors odds

# Perform model assestment procedures (Bayesian goodness of fit diagnostics) by
# calculating the p-values associated to the posterior predictive distributions of 
# network statistics g(•) simulated from the posterior molde \Mu
# Pr(g(Y_sim))>= g(y_obs)|\Mu)

# Measuring the degree distribution











