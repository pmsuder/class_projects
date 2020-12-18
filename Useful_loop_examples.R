# Impact through Networks: PLP 6701
#
# Introduction to R:
# Part 1: 2018-08-22 
# R Alcala, K Andersen-Onofre, K Garrett, Y Xing
#
# R version 3.5.1 (2018-07-02) # check R.version
#
#
#-------------------------- Introduction to -suseful- loops ----------------------------------

# Let load the data iris

data(iris) # This is your DATA
head(iris) # Check the first rows
names(iris) # Check the column names

# check how many plant species do you have
unique(iris$Species) # unique command shows you 'unique' species in your data
# We have 3 species: setosa, versicolor and virginica
# lets subset the data by specie
setosa <- iris[which(iris$Species == 'setosa'), ] # subsset species for 'setosa'

# FILL THE GAP
versicolor <- iris[which(iris$Species == 'WHATS_MISSING'), ] # subset species for 'versicolor'

# What's missing? 
virginica <- [which( == ) ] # subset species for 'virginica'


# After subsetting the iris data for the three species 
# calculate the mean for Sepal.Length 

mean(iris$Sepal.Length)

# what about if you want a calculate the mean for "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"
# We can type again 
mean(iris$Sepal.Width)
#etc...or we can make a loop that calculates the mean for each colum

# Loop:
store.means <- c() # First, we need were to store the means, so wee need to create an empty vector 

# Then, the data iris has 4 numeric columns, that's why we specify in the loop for 4 columns 
for (i in 1:4){                     # for 'i' in the form of 1, 2, 3, and 4 (for the four columns of the iris data)
  store.means[i] <- mean(iris[ ,i]) # The data iris[rows,columns] will replace the 'i' for 1, 2, 3, 4; in other words, you are subsetting the data
}                                   # and the vector store.means[i], will store in pos. 1 the  "Sepal.Length" , in pos. 2 "Sepal.Width", and so on and so for. 
store.means                         # Here you print the means results


# Would you be able to repeat this loop for the species 'setosa'?
for ( in   ){
"FILL_WHAT_ITS_MISSING_FOR_setosa"  
}

# WWhat about species 'versisolor'?



#-------------------------------------------------------------------------------------------------------------------------------
# We took the mean values of all the three species but we loose information for each species, we did it for each species 
# but what if you want to get the means for each species, we do a bigger loop.
# First, we need to create some empty vector and the names of the Species

results = temp.means = temp.spp = list() # empty list to store objects [list are objects that can contain objects]
spp <- unique(iris$Species) # getting the species names
names <- colnames(iris)[-5] # saving the names of the numeric columns, removing position 5 which is the species column

for (i in 1:3){ 
  for (j in 1:4){
  temp.spp[[i]] <- iris[which(iris$Species == spp[i]), ]
  temp.means[[j]] <- mean(temp.spp[[i]][ ,j])
  temp[[j]] <- c(temp.means[[j]]) 
  }
  results[[i]] <- unlist(temp)
}
results 

# formating the mean result for each species
mean.results.spp <- as.data.frame(matrix(unlist(results), ncol = 4)) # formating the results in 'list' format to a 'data.frame' format
rownames(mean.results.spp) <- spp # adding row names
colnames(mean.results.spp) <- names # adding col names

# Results 
mean.results.spp

#-------------------------------------------------------------------------------------------------------------------------------
# Run this if you want to know how does the douple loop runs
for (i in 1:3){
  for (j in 1:4){
    print(i)
    print(j)
  }
}
# it runs, 1,1; 1,2; 1,3; 1,4; 2,1; 2,2; 2,3; 2,4; 3,1; 3,2; 3,3; 3,4
