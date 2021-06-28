library(BiocManager)
BiocManager::install("microbiome")

library(microbiome)  
# library(knitr)
data(dietswap)
pseq <- dietswap
tab <-microbiome::alpha(pseq, index = "all")
kable(head(tab))
tab <-microbiome::alpha(pseq, index = "all")
kable(head(tab))

# Calculating Richness
tab <- richness(pseq)
(head(tab))

# Absolute abundances for the single most abundant taxa in each sample
tab <- dominance(pseq, index = "all")
(head(tab)
dominant(pseq)      

# Rarity and low abundance
# The rarity indices quantify the concentration of rare or low abundance taxa. 
tab <- rarity(pseq, index = "all")
head(tab)

# Calculating coverage index yielding the number of groups needed to have a given
# propotion of the ecosystem occupied
tab <- coverage(pseq, threshold = 0.5)
(head(tab))

# Core abundance
tab <- core_abundance(pseq, detection = .1/100, prevalence = 50/100)

# Calculating Evenness
tab <- evenness(pseq, "all")
(head(tab))


# Construct the data
d <- meta(pseq)
d$diversity <- microbiome::alpha(pseq, "shannon")$diversity_shannon
# Split the values by group
spl <- split(d$diversity, d$sex)
# Kolmogorov-Smironv test
pv <- ks.test(spl$female, spl$male)$p.value
# Adjust the p-value
padj <- p.adjust(pv)
      

####
require(graphics)
require(dgof)

# set.seed(1)

x <- rnorm(50)
y <- runif(30)
# Do x and y come from the same distribution?
ks.test(x, y)
# Does x come from a shifted gamma distribution with shape 3 and rate 2?
ks.test(x+2, "pgamma", 3, 2) # two-sided, exact
ks.test(x+2, "pgamma", 3, 2, exact = FALSE)
ks.test(x+2, "pgamma", 3, 2, alternative = "gr")

# test if x is stochastically larger than x2
x2 <- rnorm(50, -1)
plot(ecdf(x), xlim=range(c(x, x2)))
plot(ecdf(x2), add=TRUE, lty="dashed")
t.test(x, x2, alternative="g")
wilcox.test(x, x2, alternative="g")
ks.test(x, x2, alternative="l")

# TBA, JWE new examples added for discrete distributions:

x3 <- sample(1:10, 25, replace=TRUE)

# Using ecdf() to specify a discrete distribution:
ks.test(x3, ecdf(1:10))

# Using step() to specify the same discrete distribution:
myfun <- stepfun(1:10, cumsum(c(0, rep(0.1, 10))))
ks.test(x3, myfun)

# The previous R ks.test() does not correctly calculate the
# test statistic for discrete distributions (gives warning):
# stats::ks.test(c(0, 1), ecdf(c(0, 1)))
# ks.test(c(0, 1), ecdf(c(0, 1)))

# Even when the correct test statistic is given, the
# previous R ks.test() gives conservative p-values:
stats::ks.test(rep(1, 3), ecdf(1:3))
ks.test(rep(1, 3), ecdf(1:3))
ks.test(rep(1, 3), ecdf(1:3), simulate=TRUE, B=10000)


      