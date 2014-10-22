# getdata-008 Course Project
# Author: David Loker (dloker@gmail.com)
#
#
# Here are the data for the project: 
#  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#
# Description of requirements:
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average
#    of each variable for each activity and each subject.

library(data.table)

# Simple function to load training an testing feature data (X_*.txt)
# and combine them into one.
loadFeatureDataSet <- function() {
    # Read all feature training and testing data sets
    X_train <- read.table(file="./UCI HAR Dataset/train/X_train.txt")
    X_test <- read.table(file="./UCI HAR Dataset/test/X_test.txt")
    
    #combine into one
    featureSet <- rbind(X_train, X_test)
    featureSet
}

# Simple function to load training an testing activity label data (y_*.txt)
# and combine them into one.
loadActivityLabelsDataSet <- function() {
    # Read all activity label training and testing data sets
    y_train <- read.table(file="./UCI HAR Dataset/train/y_train.txt")
    y_test <- read.table(file="./UCI HAR Dataset/test/y_test.txt")
    
    # Combine into one
    activityLabel <- rbind(y_train, y_test)
    colnames(activityLabel) <- "activityLabel"
    
    # Descriptively label activities
    activityNames <- read.table(file="./UCI HAR Dataset/activity_labels.txt", 
                                col.names=c("activityLabel", "activityName"))
    
    activityDataSet <- merge(activityLabel, activityNames, by = "activityLabel")
    activityDataSet$activityNames <- activityDataSet$activityNames[,drop=TRUE]
    activityDataSet
}

# Simple function to load training an testing subject label data (subject_*.txt)
# and combine them into one.
loadSubjectDataSet <- function() {
    # Read all training and testing data sets
    subject_train <- read.table(file="./UCI HAR Dataset/train/subject_train.txt")
    subject_test <- read.table(file="./UCI HAR Dataset/test/subject_test.txt")
    
    # Combine into one
    subjectDataSet <- rbind(subject_train, subject_test)
    colnames(subjectDataSet) <- "subject"
    subjectDataSet
}

# Given the feature name table of features we want to keep,
# return a trimmed and simplified data set as a combination of
# the features, activity labels (y), and subjects.
getSimpleFitnessDataSet <- function(featureNameTable) {
    # Load all the data sets
    featureSet <- loadFeatureDataSet()
    activityLabelDataSet <- loadActivityLabelsDataSet()
    subjectDataSet <- loadSubjectDataSet()
    
    # Add in feature names as variable names for dataset 
    fitnessDataSet <- featureSet[,featureNameTable$featureNumber]
    colnames(fitnessDataSet) <- featureNameTable$featureName[,drop=TRUE]
    # Finally, combine features, activity labels, and subject as one data frame
    fitnessDataSet <- cbind(fitnessDataSet, 
                            "activity" = activityLabelDataSet$activityName, 
                            subjectDataSet)
    fitnessDataSet
}

# Use features.txt to get appropriate descriptive names for features.
featureNameTable <- read.table(file="./UCI HAR Dataset/features.txt",
                               col.names = c("featureNumber", "featureName"))
# Filter table down to only those features of mean() and std()
featureNameTable <- featureNameTable[grepl("(mean\\(\\))|(std\\(\\))",
                                           featureNameTable$featureName),]
featureNameTable$featureName = featureNameTable$featureName[,drop = TRUE]

# Get a simplified fitness data set based on the features chosen, combining X,
# y (activity label), and subject
fitnessDataset <- getSimpleFitnessDataSet(featureNameTable)

# Now, create a second, independent tidy data set with the average of each variable
# for each activity and each subject
fitnessDataset <- data.table(fitnessDataset)
setkey(fitnessDataset, subject, activity)

# For each group (activity, subject), apply mean to the columns 
tidyAveragedFitnessDataSet <- fitnessDataset[,lapply(.SD,mean, na.rm=TRUE),
                                             by=list(subject,activity)]

write.table(x = tidyAveragedFitnessDataSet,
            file = "tidy-averageFitnessFeaturesBySubjectActivity.txt",
            row.name=FALSE)
