#Samantha 11.26.2019

# Generating simulated data for 10
sex <- c(rep('M', 5), rep('F', 5)) # if you want n individuals, change 5 to n
infection_load <- sample(c(0, 5, 10), 10, replace = T) # if you want n individuals, change 5 to n
behavior <- c(rep('shy', 5), rep('bold', 5))  # if you want n individuals, change 5 to n
                                              # you can change the ratios too!

#shuffling the data with the function sample
dat <- as_tibble(cbind(sex= sample(sex),
                       infection_load = sample(infection_load),
                       behavior = sample(behavior)))

# changing infection_load as integer
dat$infection_load <- as.integer(dat$infection_load)
# checking the data
dat  

#if you want to save your data #uncomment
# write.csv(dat, "Simulated_data_for_shyandbold_frogs.csv")
