library(igraph)
library(fuzzySim)

Names	<- c("Ricardo",	
           "Robert",
           "Kelsey",
           "Wanita",
           "Karen",
           "Arik",
           "Lihe",
           "Sarah",
           "Shova",
           "Chad",
           "Shannan",
           "Samantha",
           "Sage",
           "Yanru")

Department	<- c("Plant Pathology",
                "Entomology and Nematology",
                "Plant Pathology",
                "Plant Pathology",	
                "Plant Pathology",
                "Biology",
                "Animal Sciences",	
                "Biology",
                "Entomology and Nematology",
                "Forest Resources and Conservation",
                "Epidemiology",
                "Biology",
                "Plant Medicine",	
                "Plant Pathology")

dat <- as.data.frame(cbind(Names, Department))
data <- splist2presabs(dat, "Department", "Names")
rownames(data) <- data$Department
data = t(data[-1])
# write.csv(data, "Assoc_networks_class_2019.csv")
g <- graph.incidence(data, directed = F)
V(g)$type
color = c(rep("#FA4616", length(V(g)$type[V(g)$type == "FALSE"])), rep("#0021A5", length(V(g)$type[V(g)$type == "TRUE"])))
shapes = c(rep("circle", length(V(g)$type[V(g)$type == "FALSE"])), rep("square", length(V(g)$type[V(g)$type == "TRUE"])))
plot(g,  vertex.size=20, vertex.shape=shapes, vertex.color=color, vertex.label.color='#5E8E3F',  vertex.label.cex=1.5)
plot(g,  vertex.size=20, vertex.shape=shapes, vertex.color=color, vertex.label.color='#5E8E3F', layout = layout_as_bipartite)

# by pathogen

Names	<- c("Ricardo",	
           "Robert",
           "Kelsey", "Kelsey",
           "Wanita", "Wanita",
           "Karen", "Karen", "Karen",
           "Arik",
           "Lihe",
           "Sarah",
           "Shova",
           "Chad",
           "Shannan",
           "Samantha",
           "Sage", "Sage", "Sage", "Sage",
           "Yanru")

Pathogen <- c('virus', 
              'virus',
              'virus', 'fungi',
              'fungi', 'bacteria',
              'virus', 'bacteria', 'fungi',
              'fungi',
              NA, 
              'fungi',
              'nematodes',
              NA,
              'virus',
              'fungi',
              'virus', 'bacteria', 'fungi','nematodes',
              NA)

dat2 <- as.data.frame(cbind(Names, Pathogen))
dat2 = na.omit(dat2)
data2 <- splist2presabs(dat2, "Pathogen", "Names")
rownames(data2) <- data2$Pathogen
data2 = t(data2[-1])
# write.csv(data, "Assoc_networks_class_2019.csv")
g2 <- graph.incidence(data2, directed = F)
V(g2)$type
color = c(rep("#FA4616", length(V(g2)$type[V(g2)$type == "FALSE"])), rep("#0021A5", length(V(g2)$type[V(g2)$type == "TRUE"])))
shapes = c(rep("circle", length(V(g2)$type[V(g2)$type == "FALSE"])), rep("square", length(V(g2)$type[V(g2)$type == "TRUE"])))
plot(g2,  vertex.size=20, vertex.shape=shapes, vertex.color=color, vertex.label.color='#5E8E3F',  vertex.label.cex=1.5)
plot(g2, edge.width=8, vertex.size=25, vertex.shape=shapes, vertex.color=color, vertex.label.color='#5E8E3F', vertex.label.cex=1.4, layout = layout_as_bipartite)

library(bipartite)
data2t=t(data2)

sequence <- list(seq.higher=c( "Sage", "Karen", "Kelsey", "Wanita", "Arik", "Ricardo",  "Robert", "Shannan",
                               "Samantha", "Sarah", "Shova" ),
                 seq.lower=c("nematodes","bacteria", "virus", "fungi"))

plotweb(sortweb(data2t, sort.order="inc"), method="normal")   
visweb(sortweb(data2t,sort.order="seq", sequence=sequence), type="nested", labsize=2,
       square="interaction", text="none", textsize = 2,circles=FALSE, frame=FALSE)


degreedistr(data2t)
degree.distribution(g2)


# empirical <- networklevel(dat.p)
empirical <- networklevel(data2t, ISAmethod="Bluethgen",  SAmethod = "Bluethgen")
emp.nest = nested(data2t, method="wine")
emp.nest
computeModules(data2t)
#-----------------------
# From two-mode to one-mode networks

# Virus
g2b <- bipartite.projection(g2)
# Vertex names and attributes
# Individuals
Ind_nodes <- as.list(V(g2b$proj1))
# coloring
rcPal <- colorRampPalette(c("orange", "gold", "maroon", "dodgerblue", "darkolivegreen3", "orangered1")) #MASTER.pl
rbPal <- colorRampPalette(c("orange", "red2")) 
rgPal <- colorRampPalette(c("gray", "azure4"))

V(g2b$proj1)$color <- rcPal(14)[as.numeric(cut(as.numeric(factor(as.character(Ind_nodes))), breaks = 14))]
# Edges names and attributes
E(g2b$proj1)$color <- rgPal(10)[as.numeric(cut(E(g2b$proj1)$weight, breaks = 10))]
Pap.adj <- get.adjacency(g2b$proj1,sparse=FALSE,attr="weight")
plot(g2b$proj1,edge.width=E(g2b$proj1)$weight^2, vertex.label=V(g2b$proj1)$name)
Pap.adj1 <- get.adjacency(g2b$proj1, sparse=FALSE, attr="weight")

# Organism
Org_nodes <- as.list(V(g2b$proj2))
# coloring
rcPal <- colorRampPalette(c("orange", "gold", "maroon", "dodgerblue", "darkolivegreen3", "orangered1")) #MASTER.pl
rbPal <- colorRampPalette(c("orange", "red2")) 
rgPal <- colorRampPalette(c("gray", "azure4"))

V(g2b$proj2)$color <- rcPal(14)[as.numeric(cut(as.numeric(factor(as.character(Org_nodes))), breaks = 14))]
# Edges names and attributes
E(g2b$proj2)$color <- rgPal(10)[as.numeric(cut(E(g2b$proj2)$weight, breaks = 10))]
Pap.adj <- get.adjacency(g2b$proj2,sparse=FALSE,attr="weight")
plot(g2b$proj2,edge.width=E(g2b$proj2)$weight^2, vertex.label=V(g2b$proj2)$name)
Pap.adj2 <- get.adjacency(g2b$proj2, sparse=FALSE, attr="weight")



