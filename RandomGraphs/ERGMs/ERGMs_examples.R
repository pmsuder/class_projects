# MCMC Diagnostics
# Assessing convergence for dyad dependent models

# What it looks like when a model converges properly
set.seed(314159)
summary(flobusiness~edges+degree(1))

# uisng MCMC to fit the model
fit <- ergm(flobusiness~edges+degree(1))
summary(fit)

mcmc.diagnostics(fit)

# the center should be 0
# its based on the observed 

set.seed(271828)
fit <- ergm(flobusiness~edges+degree(1),
            control=control.ergm(MCMC.interval=1))
mcmc.diagnostics(fit)

#--------------------------------
# Network simulation: 
# the simulate command and network.list objects

# when you give an ergm with \thetas you get a ergm probility distribution
set.seed(101)
flomodel.03.sim <- simulate(flomodel.01,nsim=10)

class(flomodel.03.sim) # what does this produce?
summary(flomodel.03.sim) # quick summary
attributes(flomodel.03.sim) # what's in this object?

# are the simulated stats centered on the observed stats?
rbind("obs"=summary(flomarriage~edges+nodecov("wealth")),
      "sim mean"=colMeans(attr(flomodel.03.sim, "stats"))) 

# we can also plot individual simulations
flomodel.03.sim[[1]]

plot(flomodel.03.sim[[1]], 
     label= flomodel.03.sim[[1]] %v% "vertex.names",
     vertex.cex = (flomodel.03.sim[[1]] %v% "wealth")/25)

# Examining the quality of model fit – GOF
set.seed(54321) # The gof function uses random values
flomodel.03.gof <- gof(flomodel.01)
flomodel.03.gof

par(mfrow=c(2,2))
plot(flomodel.03.gof)

# constraints = ~edges # to fix the number of edges


#-------
set.seed(12345)
mesamodel.02 <- ergm(mesa~edges)
mesamodel.02.gof <- gof(mesamodel.02~degree + esp + distance, 
                        control = control.gof.formula(nsim=10))
plot(mesamodel.02.gof)


#--- What it looks like when a model fails
set.seed(10)
data('faux.magnolia.high')
magnolia <- faux.magnolia.high
magnolia
plot(magnolia, vertex.cex=.5)
# Consider a simple model
summary(magnolia~edges+triangle)
set.seed(100)
fit <- ergm(magnolia~edges+triangle,
            control=snctrl(MCMLE.effectiveSize=NULL))
set.seed(1000)
fit <- ergm(magnolia~edges+triangle, 
            control=snctrl(MCMLE.maxit=2,MCMLE.effectiveSize=NULL))
mcmc.diagnostics(fit)

#-
set.seed(10101)
fit <- ergm(magnolia~edges+gwesp(0.25, fixed=T), 
            control=snctrl(MCMC.interval = 10000),
            verbose=T)
mcmc.diagnostics(fit)

