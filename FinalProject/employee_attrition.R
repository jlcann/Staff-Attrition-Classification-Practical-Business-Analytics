# Reset the global environment list of all variables and objects.
rm(list=ls())

# Below are constants defined for use throughout the project.

DATASET_FILENAME      <- "employee-attrition.csv"   # Name of input dataset file
OUTPUT_FIELD          <- "AttritionYes"             # Field name of the output class to predict
ORIGINAL_OUTPUT_FIELD <- "Attrition"                # Field name of the output class in the original dataset


TYPE_DISCREET     <- "DISCREET"           # field is discreet (numeric)
TYPE_ORDINAL      <- "ORDINAL"            # field is continuous numeric
TYPE_SYMBOLIC     <- "SYMBOLIC"           # field is a string
TYPE_NUMERIC      <- "NUMERIC"            # field is initially a numeric
TYPE_IGNORE       <- "IGNORE"             # field is not encoded
DISCREET_BINS     <- 5                    # Number of Discreet Bins Required for 
OUTLIER_CONFIDENCE<- 0.99                 # Confidence for outlive removal 
CUTOFF            <- 0.90                 # Correlation cutoff

HOLDOUT           <- 70                   # Holdout percentage for training set                  
FREQCUT           <- 99/1                 # To remove zero variance fields
FOREST_SIZE       <- 1000                 # Number of trees in the forest
LOAD_MODEL        <- TRUE                # If false, script will train a new model. Otherwise, will load existing saved model.

NN_BATCH_SIZE     <- 15                   # Batch size for MLP Model Fitting
NN_OPTIMISER      <- "adam"               # Name of the optimization algorithm used for MLP Model Fitting
NN_DROPOUT        <- 0.1                  # 10% Dropout for the MLP Model
NN_HIDDEN_RELU    <- 16                   # Number of neurons for the MLP Dense Layer with Relu Activation 
NN_HIDDEN_SIGMOID <- 1                    # Number of neurons for the MLP Dense Layer with Sigmoid Activation 
NN_EPOCHS         <- 60                   # Maximum number of training epochs for MLP Model Fitting
K_FOLDS           <- 8                    # Number of holds for stratified cross validation


# Define and then load the libraries used in this project
# Library from CRAN     Version
# pacman	               0.5.1
# outliers	             0.14
# corrplot	             0.84
# MASS	                 7.3-51.6
# formattable 	         0.2.0.1
# stats                  4.0.3
# PerformanceAnalytics   2.0.4
# Carat                  6.0-86
# dplyr                  2.0.0
# C50                    0.1.3.1
# randomForest           4.6-14
# keras                  2.3.0.0
# tensorflow             2.2.0
# stringr                1.4.0
# tidyrules              0.1.5
# OneR                   2.2.0
# ggplot2                3.3.2
# ggpubr                 0.4.0
# GGally                 2.0.0
# hrbrthemes             0.8.0
# hexbin                 1.28.1

# List of libraries used in the project, ready for install / loading below.
MYLIBRARIES<-c("outliers",
               "corrplot",
               "MASS",
               "formattable",
               "stats",
               "PerformanceAnalytics",
               "caret",
               "dplyr",
               "C50",
               "randomForest",
               "keras",
               "tensorflow",
               "stringr",
               "tidyrules",
               "OneR",
               "ggplot2",
               "ggpubr",
               "GGally",
               "hrbrthemes",
               "hexbin")

# garbage collection to automatically release memory
gc()

# clears the console area
cat("\014")

# Loads the libraries
library(pacman)
pacman::p_load(char=MYLIBRARIES,install=TRUE,character.only=TRUE)

#Load additional R script files required for this project
source("employee-attrition_model_functions.R")
source("employee_attrition_exploration.R")
source("employee-attrition_preprocessing.R")

#Set the seed for the project, so randomization is consistent between runs.
set.seed(123)



# ************************************************
# main() :
# main entry point to execute analytics
#
# INPUT       :   None
#
# OUTPUT      :   None
#
# Keeps all objects local to this function
# ************************************************
main<-function(){
  
  # Load the chosen dataset into a data.frame object.
  originalDataset <- read.csv(DATASET_FILENAME, encoding = "UTF-8", stringsAsFactors = FALSE)
  
  # Produce all plots used for data exploration
  # Un-comment the line immediately below this one to produce all the plots.
  #dataExploration(originalDataset)
  
  # Pass the dataset into the pre-processing function, which returns a data frame which 
  # has been processed, normalized and randomised ready for the models. 
  preprocessedDataset <- preprocessing(originalDataset)
  
  
  # Return a list containing two data frames, one for training models, and one for testing models.
  holdoutDataset <- createHoldoutDataset(preprocessedDataset, HOLDOUT)
  
  # Take the pre-processed dataset defined above and stratify it, so that is ready for 
  # streatified cross validation.
  stratifiedData <- stratifyDataset(preprocessedDataset,OUTPUT_FIELD,K_FOLDS)
  
  
  
  
  # All model training / loading is below. For ease of review, we recommend un-commenting one model at a time,
  # and re-running the script for each one. Although all accuracy measures are labeled, it can become quite
  # laborious to flick through all the plot and viewer results.
  # Each of the models will return accuracy statistics in the Viewer, and a confusion matrix in the plots.
  
  # With training time taken into account, all models have been saved and will be loaded.
  # To change this, you must change the constant variable found at the top of the script called 'LOAD_MODEL' to FALSE.  
  
  
  
  # The model immediately below is an MLP using a simple holdout method for training and testing.
  #*****************************************************************************************************************
  
  #MLP_With_Holdout <- train_MLP_Model(holdoutDataset$training,holdoutDataset$test,OUTPUT_FIELD, i = 999, LOAD_MODEL)
  
  #*****************************************************************************************************************
  
  
  # This next model is again an MLP but this time is has been trained through stratified cross validation.
  # This method splits the dataset up into N bins, and return the mean averages of the N models trained on the bins.
  #*****************************************************************************************************************
  
  #MLP_Stratified_Cross_Val <- kFoldModel(train_MLP_Model,stratifiedData,OUTPUT_FIELD,LOAD_MODEL,plot=FALSE)
  
  #*****************************************************************************************************************
  
  
  # This code trains a random forest model using the holdout method.
  #*****************************************************************************************************************  
  
  #Forest_With_Holdout <- createAndEvaluateForest(holdoutDataset$training,holdoutDataset$test,OUTPUT_FIELD, LOAD_MODEL, FOREST_SIZE, i = 999, showInViewer=T)
  
  #*****************************************************************************************************************
  
  
  # This code trains random forest models using stratified cross validation.
  #*****************************************************************************************************************  
  
  #Forest_Stratified_Cross_Val <- kFoldModel(createAndEvaluateForest, stratifiedData, OUTPUT_FIELD, LOAD_MODEL, forestSize = FOREST_SIZE, plot=F)
  
  #*****************************************************************************************************************
  
  
  # The problem with using a random forest, is that you cannot pull rules from the models
  
  
  # This code trains a decision tree model using the holdout method.
  #*****************************************************************************************************************  
  
  #Tree_With_Holdout <- createAndEvaluateDT(holdoutDataset$training,holdoutDataset$test,OUTPUT_FIELD, LOAD_MODEL, FOREST_SIZE, i = 999, showInViewer = T)
  
  #*****************************************************************************************************************
  
  
  # Uncomment below to create decision trees and print the measures. Also prints the rules generated by the first fold
  #*****************************************************************************************************************
  
  #kfoldTree <- kFoldModel(createAndEvaluateDT, stratifiedData, OUTPUT_FIELD, LOAD_MODEL, plot=F)
  
  #*****************************************************************************************************************
  
  
  # The trees formed from the processed dataset produces rules that were derived from normalised data
  # It would be better to "de-normalise" the values in these rules. Alternatively, as decision trees are known
  # to work well without preprocessing, create a decision tree on a preprocessed dataset
  # This will require recreating a new stratified dataset with little processing applied to it
  
  # For whataver reason, the C5 decision tree cannot be created if the Over18 column is present
  # It has nothing to do with the values in the column, and also nothing to do with the name of the column
  
  # This code trains a random forest model using the holdout method.
  #*****************************************************************************************************************  
  
  #rawDataset = select(originalDataset, -"Over18")
  #rawHoldoutDataset <- createHoldoutDataset(rawDataset, HOLDOUT)
  #Raw_Tree_With_Holdout <- createAndEvaluateDT(rawHoldoutDataset$training,rawHoldoutDataset$test,ORIGINAL_OUTPUT_FIELD, LOAD_MODEL, FOREST_SIZE, i = 999, classLabelChar = 'Yes', showInViewer = T, fileName = "_rdt_")
  
  #*****************************************************************************************************************
 
   
  # Uncomment below to create raw decision trees and print the measures. Also prints the rules generated by the first fold
  #*****************************************************************************************************************
  #
  #rawDataset = select(originalDataset, -"Over18")
  #rawStratifiedDataset <- stratifyDataset(rawDataset, ORIGINAL_OUTPUT_FIELD, K_FOLDS)
  #kfoldRawTree <- kFoldModel(createAndEvaluateDT, rawStratifiedDataset, ORIGINAL_OUTPUT_FIELD, LOAD_MODEL, classLabelChar = "Yes", fileName = "_rdt_", plot=F)
  
  #*****************************************************************************************************************
}

# Run the main function.
main()