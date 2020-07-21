# GCD-Project
Course project - Getting and Cleaning Data

The purpose of this project is to demonstrate skills developed during the course such as collecting and cleaning a data set. The goal is to prepare tidy data that can be used for later analysis.
This README file describes the analysis files used in the project.

## Data used 
The project uses data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

For the project, the following zip file is used 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Files in the repository

1) run_analysis.R is an main R script to perform the tasks required by the project. It downloads the zip file, unzips data into local drive, merges the training and the test sets, extracts the measurements on the mean and standard deviation, and appropriately labels the data set with descriptive variable names. Finally, it creates an independent tidy data set with the average of each variable for each activity and each subject.

2) CodeBook.md. describes the data and the work done to clean up the data.

3) tidyData.txt is the final output text from run_analysis.R, which is the average grouped by each subject and each activity. 
