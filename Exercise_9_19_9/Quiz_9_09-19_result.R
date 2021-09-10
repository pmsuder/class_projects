# QUIZ
m <- c(1, 1, 1, 0, 1,
       0, 1, 1, 1, 1, 
       0, 0, 1, 1, 1,
       0, 0, 0, 0, 1)
mat <- t(matrix(m, nrow =5))
mat
plotweb(sortweb(mat, sort.order="inc"), method="normal")
visweb(sortweb(mat, sort.order="dec"), type= "nested", # change to nested or diagonal 
       labsize= 2, square= "interaction", text= "none", textsize= 4)
