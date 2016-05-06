#--------------------------------- SETUP WORK -------------------------------------
#clear the workspace and console
rm(list=ls())
cat("\014") #code to send ctrl+L to the console and therefore clear the screen

#setup working directory 
setwd('~/../Dropbox/School/Spring 2016/Machine Learning/Homeworks/4 Credit')

#direct to any helper functions written
source("helperFunctions.R")

#libraries
library(glmnet)


#-------------------------  Run the Program for Every Database  ---------------------

#Read in all the Database Paths
fileConnection <- file('databaseFileNames.txt', "r", blocking = FALSE) 
databaseFilenames = readLines(fileConnection)
close(fileConnection)


#Create a Dataframe to hold all the Results
results_DF <- data.frame(
                  File = databaseFilenames, stringsAsFactors = FALSE,
                  NumClasses = c(0),
                  Lambda = c(0), 
                  Coefficients = c(0),
                  CV_Error = c(0),
                  Training_Error = c(0)
                  ) 

#Run  the program on each database
for( i in 1:nrow(results_DF) ) 
{
  filepath <- paste('data/', results_DF$File[i], sep = "") #determine the filepath for the database
  results_DF <- program(filepath, i, results_DF)  
}







