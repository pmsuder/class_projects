# R Alcala 
#       Network analysis      
#       Generating alluvial plots

# load libraries
library(alluvial)
library(tidyverse)
library(reshape2)

# creating a data.frame as an example
dat <- read.table(text = "
  Phylum     Class    Order        Genus      Continent abundance
  Chordata   Mammalia Artiodactyla Cetacea    worldwide 10
  Chordata   Mammalia Carnivora    Panther    Asia      45
  Chordata   Tunicata NA           Ascidiacea worldwide 6
  Chordata   Reptilia Squamata     Afrogecko  Africa    6
  Arthropoda Insecta  Diptera     Drosophila  worlwide  20", 
 header = TRUE)

# subsetting table
datc <- dat %>%
  select(Phylum, Class, Genus, Continent, abundance)
head(datc)

# adding colors
RbPal <- rainbow(c(length(unique(datc$Phylum))+2))

datc <- datc %>%
            mutate( ss = paste(Phylum, Class),
                    cols = RbPal[ match(ss, sort(unique(ss))) ] 
                    )
# alluvla plot 

alluvial(datc[,c(1,2,3, 4)], freq=datc$abundance,
         #hide = datc$length == 0,
         col = datc$cols,
         border = datc$cols, 
         alpha = 0.7,
         blocks = FALSE,
         ordering = list(NULL, NULL,NULL, order(as.factor(datc$Phylum))), 
                # change NULL to order them
         cex =0.8
        )

