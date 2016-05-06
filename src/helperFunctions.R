
# function getdata - get's the data from the formatted database files

extractFeatures <- function(dataTable) {
  #remove the first 2 rows and the 1st column
  features <- dataTable[c(-1:-2), c(-1)]
  #transpose so that each example is a row
  features <- t(features)
  features <- as.matrix(features)
  class(features)<-"numeric"
  return (features)
}

extractLabels <- function(dataTable) {
  
  labels <- dataTable[2,c(-1)];
  labels <- as.matrix(labels);
  labels <- factor(labels)
  return (labels)
  
}

numFeaturesUsed <- function(model){
  numUsed <- model$nzero[model$lambda == model$lambda.min]
  numUsed <- numUsed[[1]]
  return (numUsed)
}

program <- function(filepath, count, results_DF){
  
  #--------------------------  Acquire and Pre-Process Data  -------------------------
  
  #read all the data into a single table
  dataTable <- read.table(filepath, sep="\t", header = FALSE)
  
  labels <- extractLabels(dataTable) 
  #print(levels(labels)) #classes
  #as.matrix(as.integer(labels)) #matrix form of labels as integers
  #note the number of classes
  results_DF$NumClasses[count] <- nlevels(labels)
  
  features <- extractFeatures(dataTable)
  numExamples <- dim(features)[1]
  numFeatures <- dim(features)[2]
  
  #--------------------------------- Train a Model ----------------------------------
  x = data.matrix(features)
  y = data.matrix(as.integer(labels))
  model <- cv.glmnet(x, y, family = "multinomial", type.measure="class", alpha = 1)
  plot(model)
  numModelPredictors <- numFeaturesUsed(model)
  
  #store the results in the dataframe
  results_DF$Coefficients[count] <- numModelPredictors
  results_DF$CV_Error[count] <- min(model$cvm)
  results_DF$Lambda[count] <- model$lambda.min
  
  #print the results too
  cat("Number of Genes used in Final Model: ", numModelPredictors)
  cat("Cross Validated Error of Final Model: ", min(model$cvm))
  cat("Lambda of Final Model: ", model$lambda.min) # same as model$lambda[index]
  
  
  #--------------------------- Predict using the Model ------------------------------
  #TRAINING ACCURACY for now
  xtest <- x
  ytest <- data.matrix(as.integer(labels))
  predictions <- predict(model, xtest, type = 'class' , s= 'lambda.min')
  #predictions <- predict(model, xtest, type = 'class' , s= 'lambda.1se')
  numCorrect <- sum(ytest==predictions)
  accuracy <- numCorrect/dim(predictions)[1]
  error <- 1-accuracy
  
  #store or print the results
  results_DF$Training_Error[count] <- error
  cat("Training Error: ", error)
  
  return (results_DF)
}


