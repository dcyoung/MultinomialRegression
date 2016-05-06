# MultinomialRegression
Multinomial Regression for Wide Datasets sourced from Cancer Genetics
- src folder contains all source code
- src/data folder contains all data
- results folder contains results in an excel file and a png file


# Overview of source
**helperFunctions.R** handles the following
- Read the data from a database file
    - Format the data for the regression
- Build a multinomial regression model with the lasso
    - Record the regularization constant (lambda) for the model yielding the lowest classification error
    - Record the number of coefficients (# of genes) used by this best model
    - Record the misclassification error from the cross validation 
- Use the generated model to predict labels for the same training data
    - Record the training error

**testReadData.R** serves as the main executable here and performs the following:
- Sets up the workspace
- Reads all the database filenames from a file containing all the names
- Creates a Dataframe to hold all the values that will be recorded for each regression
- Runs the program defined in “helperFunctions.R” on each of datasets
    - Stores the results in the created Dataframe