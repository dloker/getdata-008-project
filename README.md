Getting and Cleaning Data Course Project
========================================

*Author:* David Loker

This project contains the following files:

- README.md
- CodeBook.md: Details on the original data set, the feature/variable descriptions, and the transformations the data underwent to become "tidy".
- run_analysis.R: Script that transforms the original data and tidies it. The resulting variable *tidyAveragedFitnessDataSet* contains the tidied data set. It is also written out to a file.

## Project Description

Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

For this project, we create one R script called *run_analysis.R* that does the following: 
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## How run_analysis.R works

The script assumes that the origin data is in the working directory in R. The data should be under the directory "UCI HAR Dataset". The exact details of how the tidy functionality is performed is contained in CodeBook.md in this project.

The tidied dataset is contained in the variable tidyAveragedFitnessDataSet and is also written to tidy-averageFitnessFeaturesBySubjectActivity.txt


