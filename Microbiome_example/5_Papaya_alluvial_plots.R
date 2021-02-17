# R Alcala 
#     Papaya metagenomics   
#       Network analysis      
#         5 Generating alluvial plots


#dat <- read.table(text = "A   B   C   D   E   F    G
#1 480 780 431 295 670 360  190
#                  2 720 350 377 255 340 615  345
#                  3 460 480 179 560  60 735 1260
#                  4 220 240 876 789 820 100   75", header = TRUE)
#dat$row <- seq_len(nrow(dat))
#dat2 <- melt(dat, id.vars = "row")

#Family
datc <- RPapaya %>%
  select(Family, Genus, OTU, length, cov)
#x = a + (X - A) * (b - a) / (B - A)
a = 1
b = 0.1
A <- max(datc$cov)
B <- min(datc$cov)
X <- datc$cov
cov.norm <- a + (X - A) * (b - a) / (B - A)
datc$cov.norm <- -log(cov.norm)
head(datc)
datc <- datc[which(datc$length >= 1000), ]
#rainbow(length(unique(datc$Family)))
RbPal <- rainbow(c(length(unique(datc$Family))+2))
datc %>%
  mutate(
    ss = paste(Family, Genus),
    k = RbPal[ match(ss, sort(unique(ss))) ]
  ) -> datc


alluvial(datc[,c(1,2,3)], freq=datc$cov.norm,
         #hide = datc$length == 0,
         col = datc$k,
         border = datc$k, 
         alpha=0.7,
         blocks=FALSE,
         ordering = list( NULL, NULL, order(as.factor(datc$Family))), 
         cex =0.8
)


#######

tit <- data.frame(Titanic)
pal <- c("red4", "lightskyblue4", "red", "lightskyblue")

tit %>%
  mutate(
    ss = paste(Survived, Sex),
    k = pal[ match(ss, sort(unique(ss))) ]
  ) -> tit


alluvial(tit[,c(2,3, 4)], freq=tit$Freq,
         hide = tit$Freq < 10,
         col = tit$k,
         border = tit$k,
         blocks=FALSE,
         ordering = list(
           NULL,
           NULL,
           order(tit$Age, tit$Sex )
           
         )
)
