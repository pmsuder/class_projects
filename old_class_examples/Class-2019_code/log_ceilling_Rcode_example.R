# Example 1
y = c(790, 345, 3.2, 0.034, 4, 200, .04, 500, 1000, 400, 1000, 1800, 190, .03, 0.01, 2)

mat <- matrix(c(y,rev(y)), 6)
rownames(mat) <- LETTERS[1:nrow(mat)]
colnames(mat) <- LETTERS[1:nrow(mat)] #as.character(c(1:nrow(mat)))
mat
mat[lower.tri(mat, diag = T)] <- 0
x= list()
for(i in 1:nrow(mat)){
  x[[i]] <- rep(LETTERS[i], 4)
}
j <- unlist(x)
k <- round(rnorm(length(j), 3))
y=list()
for(i in seq_along(j)){
  y[[i]] <- LETTERS[k[i]]
}
k <- unlist(y)
l <- c(mat[1,], mat[2,], mat[3,], mat[4,])
mat2 <- as.data.frame(cbind("from"= j, "to"= k, "dist"=(l)))
rownames(mat2) <- c(1:nrow(mat2))
mat2$from <- as.character(mat2$from)
mat2$to <- as.character(mat2$to)
mat2$dist <- as.numeric(as.character(mat2$dist))
mat2$ordmg <- log10_ceiling(mat2$dist)/100 # scale it
mat2$rep <- paste(mat2$from, mat2$to, sep="")

mat3 <- mat2[mat2$dist > 0,]
mat3

g <-  graph_from_data_frame(mat3, directed = FALSE)
V(g)$size  <- (mat3$ordmg)+2 # add a constant 
plot(g)
#----- primero ----
log10_ceiling <- function(x) {
  10^(ceiling(log10(x)))
}

log10_ceiling(c(345, 3.2, 0.034))

log10_ceiling(mat)