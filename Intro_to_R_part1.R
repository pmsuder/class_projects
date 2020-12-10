# Impact through Networks: PLP 6701
#
# Introduction to R:
# Part 1: 2020-09-04 
# R Alcala, Y Xing, and K Garrett
#
# R version 3.6.2 (2019-12-12) # check R.version
#
#
#-------------------------- Introduction to R Basics ----------------------------------
# You can use R as a simple calculator:
# addition
1+1
# multiplication
3*2
# power
8^2
# division
7/2
# operations order
4+4-2*8
4+(4-2)*8

# Objects
# Setting values to use again as 'objects'. 
# We do this using the assignment operator '<-' (called the 'gets arrow').
a <- 2 + 2
print(a) 
a
#-
b <- a + 2
b

# You can use '<-' for variable assigment 
a.vector <- c(4, 3, 2, 1)
x.vector <- mean(other.vector <- c(1, 2, 3, 4))

# and '=' for parameters 
parameter1 = .1
par1 = par2 = par3 = NULL


#-------------------------- Relational operators ----------------------------------
# [ <, >, ==, >=, <=, !=]
# Comparing values will return “True” or “False” 
# logical
TRUE == TRUE 
T == F 
FALSE != FALSE 
# binary
FALSE == 0
TRUE <= 1

# loigical numericals
2==2 ## "==" means does equal 
2!=2 ## "!=" means does not equal
2>=3 ## ">=" means greater than or equal to

# lgical strings
apple <-  "apple"
pineapple <-  "pineapple"

apple == pineapple # based on alphabetical order
apple > pineapple
apple < "abcde"

# Create an object with values from 1 to 10
num10 <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
num.10 <- 1:10

# Which elements are less than 5? 
num5 <- num10 < 5

# Check the elements in num5, these are TRUE / FALSE
num5

# subsetting objects
num10[3:8]
num10[!num5]

#-------------------------- Relational Operators &  Sub-setting 2D object  ----------------------------------
# data() – data available already in R
data(iris) # famous dataset iris 
head(iris) # checking the first rows
tail(iris) # checking the last rows
class(iris) #checking the class
str(iris) # checking the structure 

# subsetting the data 
iris[1:5, ] # display only the first 5 rows [looks like head() !]
table(iris$Species)

# select only sepals less than 6 cm
low_sl <- iris[iris$Sepal.Length < 6, ] # NOTE: syntax use data[row, column]
low_sl

# logical vector - sepal lenght bigger than 5 cm
low_sl$Sepal.Length < 5 # what do you think the result will be?

#-------------------------- Logical Operators ----------------------------------
# [ &, | , ! ]; 
# [AND, OR, NOT]

# select only sepals less than 6 cm AND with petals less than 6 cm
low_slANDpl <- iris[ c( iris$Sepal.Length  < 6  & iris$Petal.Length <= 6), ]
head(low_slANDpl)
table(low_slANDpl$Species)
# select only sepals less than 6 cm AND with petals less than 6 cm
low_slORpl <- iris[ c( iris$Sepal.Length  < 6  | iris$Petal.Length <= 6), ]
head(low_slORpl)
table(low_slORpl$Species)

# Are they the same Species?
low_slANDpl$Species == low_slORpl$Species

# select species with sepal lenght below 6 cm
low_slANDsp <- iris[c(iris$Sepal.Length  <  6 & iris$Species == "versicolor"), ]

# select the species 
iris[iris$Sepal.Length != 5,]

#-------------------------- Vectors ----------------------------------
# Vectors are a way to set a series of data elements as an object.

v1 <- c(1, 2, 3, 4, 5) # numbers
v2 <- c("hello", "world") # characters 
v3 <- c("TRUE", "FALSE", "TRUE") # logical values (also could be "T", "F", "T")


# Lets make a vector with hypothetical ratings of “R expertise” on a scale of 1-10.
WithR <- c(8.5, 6.5, 4, 1, 3, 10, 5, 5, 5, 1, 1, 6, 6)
WithR

#Summary statistics
#We can use the following functions to look at some summary statistics.
summary(WithR)

# If you have a doubt about a function you can call 'help'
?summary
mean(WithR)
sd(WithR) 
median(WithR)
# work inside the vector withinR
vector <- summary(WithR)
vector["Mean"] # accessing the vector for 'Mean'
vector[3] #accessing the vector for position '3'

# basic plot: histogram or data distribution!
hist(WithR, xlab = "Self-Reported R Proficiency")
plot(WithR, xlab = "Self-Reported R Proficiency")

#-------------------------- loading data ----------------------------------
# setting directory
setwd("~")
# setwd('~/Desktop/')

#Header = TRUE lets R know that we have headings in the first row of our data set.
RustData <- read.csv("StripeRust.csv", header = TRUE)

class(RustData) # let's check the data type 

str(RustData) # let's check the data attributes

# What other types of data: vector, matrix, data.frame, list 

head(RustData) ## check the first 6 rows of the dataset

head(RustData, 10) # check the first 10 rows of the dataset

names(RustData) ## check the column headers

#-------------------------- ggplot ----------------------------------
# let's install the package ggplot and load the library
install.packages("ggplot2")
library(ggplot2)

#We can plot this data using ggplot2 (we will learn more about this later!). 
# Tell the graphic function to use the data 'RustData', and add a layer to the plot with
# 'geom_point()' function: severity on the y axis and year on the x axis. 
# Color the points by the year that data was collected.

ggplot(data = RustData) +
  geom_point(mapping = aes(x = DAI, y = Severity, color = Year))

# Switch from 'geom_point' to 'geom_line' we can plot lines and not points.
ggplot(data = RustData) +
  geom_line(mapping = aes(x = DAI, y = Severity, color = Year))+
  theme_classic()

ggplot(data = RustData) +
  geom_point(mapping = aes(x = DAI, y = Severity)) +
  facet_wrap(~Year)

#--------- Part 1.a
#-------------------------- conditional statemtns  ----------------------------------

# 'if' symntax 
# if (test_condition) {
#     do_my_condition
#   }

i <- 2
if (i < 5) {
	message(i, " is less than 5")
  }

# 'if else' symnyax
# if (test_condition) {
#     do_my_condition
#   } else {
#     do_other_condition}

i <- 20
if (i < 5) { # change '<' to '>' and see what happens
	message(i, " is less than 5")
} else {  
	message(i, " is greater than 5")}

# 'while' symnyax
# while (test_condition) {
#    do_my_condition
#    }

i <- 1
while (i < 10) {
  print(i)
  } # this is gonna run forever so 'kill the taks' ctrl + c or press 'stop' in your console

# fullfiling your condition
while (i < 10) {
  print(i)
  i = i + 1}

#--------- Part 1.b
#-------------------------- loops  ----------------------------------
# 'for' loop syntax
# for (test_condition) {
#    do_my_condition
# }

for (i in 1:10){
  print(i)  
  i = i + 1
  }

# 'while' loop syntax
# for (test_condition) {
#    do_my_condition
# }

i <- 1
while (i <= 10) {
  print(i)
  i = i + 1
  }

# for loops with if else stament

for (i in 1:100){ 
  if (i < 50) {
	message(i, " Loops are cool")
  } else {  
	message(i, " Loops are super cool")}
}










