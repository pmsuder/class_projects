# Epidemiology and datascience :
#
# Microbiome Network example:
# 2020-12-11
#
# R Poudel, R Alcala, Y Xing, and K Garrett
#
# R version 3.6.2 (2019-12-12) # check R.version
############################################################
#
# Set working directory
setwd("~/Desktop/")

# Loading required packages 
library(igraph)
library(Hmisc) 
library(Matrix)


# Load the data with the OTU table: otudata.csv
#otu.table <- read.csv(file.choose(), header=T, row.names = 1)
otu.table <- read.csv("otudata.csv", header=T, row.names = 1)
otu.table[1:10, 1:10]
# Read taxonomy file associated with OTU table into new object: otu_taxonomy.csv
#tax <- read.csv(file.choose(), header=T, row.names = 1)
tax <- read.csv("otu_taxonomy.csv", header=T, row.names = 1)
tax[1:10,1:3]
# Check how many OTUs we have
dim(otu.table)

# Keep the OTUs with more than 10 counts
otu.table.filter <- otu.table[ , colSums(otu.table) > 10]
otu.table.filter[1:10,1:10]
# Check for the decrease in the number of OTUs
dim(otu.table.filter)


# Calculate pairwise correlation between OTUs
otu.cor <- rcorr(as.matrix(otu.table.filter), type="spearman")
summary(otu.cor)
otu.cor$r[1:4,1:4]
otu.cor$n[1:4,1:4]
otu.cor$P[1:4,1:4]

# Get p-value matrix
otu.pval <- forceSymmetric(otu.cor$P) # Self-correlation as NA

# Select only the taxa for the filtered OTUs by using rownames of otu.pval
sel.tax <-tax[rownames(otu.pval),,drop=FALSE]

# Sanity check 
all.equal(rownames(sel.tax), rownames(otu.pval))


# Filter the association based on p-values and level of correlations
p.yes <- otu.pval < 0.001

# Select the r values for p.yes
r.val <- otu.cor$r # select all the correlation values 
p.yes.r <- r.val * p.yes # only select correlation values based on p-value criterion 

# Select OTUs by level of correlation
p.yes.r <- abs(p.yes.r) > 0.75 # output is logical vector
p.yes.rr <- p.yes.r * r.val # use logical vector for subscripting.
p.yes.rr[1:10,1:10]

# Create an adjacency matrix
adjm <- as.matrix(p.yes.rr)
adjm[1:4,1:4]
# Add taxonomic information associated with adjacency matrix
colnames(adjm) <- as.vector(sel.tax$Family) #renaming cols with taxonomix information
adjm[1:4,1:4] 
rownames(adjm) <- as.vector(sel.tax$Family) #renaming cols with taxonomix information
adjm[1:4,1:4]

# Create an adjacency matrix in igraph format                               
net.grph <- graph.adjacency(adjm,mode="undirected", weighted=TRUE,diag=FALSE)


# Calculate edge weight == level of correlation
edgew <- E(net.grph)$weight

# Identify isolated nodes
bad.vs <- V(net.grph)[degree(net.grph) == 0] 

# Remove isolated nodes
net.grph <- delete.vertices(net.grph, bad.vs)


# Plot the graph object
plot(net.grph,
     vertex.size=4,
     vertex.frame.color="black",
     edge.curved=F,
     edge.width=1.5,
     layout=layout.fruchterman.reingold,
     edge.color=ifelse(edgew<0,"red","blue"),
     vertex.label=NA,
     vertex.label.color="black",
     vertex.label.family="Times New Roman",
     vertex.label.font=2)

# Plot the graph object with label.
plot(net.grph,
     vertex.size=4,
     vertex.frame.color="black",
     edge.curved=F,
     edge.width=1.5,
     layout=layout.fruchterman.reingold,
     edge.color=ifelse(edgew<0,"red","blue"),
     vertex.label.color="black",
     vertex.label.family="Times New Roman",
     vertex.label.font=3,
     vertex.label.cex= 0.5)

##########################################################################
##########################################################################