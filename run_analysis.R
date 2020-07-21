# Course project: Getting and Cleaning Data
#
# Tasks
# You should create one R script called run_analysis.R that does the following.
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names.
# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
# Author: Pradeep Mandapaka
# Date: 21/7/2020


library(data.table)
library(dplyr)

# Download data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "data.zip")
unzip(zipfile = "data.zip")

# Reading activity, feature labels
activity <- fread("./UCI HAR Dataset/activity_labels.txt", col.names = c("classIndex", "activityName"))
features <- fread("./UCI HAR Dataset/features.txt", col.names = c("index", "featureName"))

# Reading training dataset 
# Each column represents a featureName from the features dataset and each row represents a subject
train <- fread("./UCI HAR Dataset/train/X_train.txt", col.names = features$featureName)
trainCode <- fread("./UCI HAR Dataset/train/Y_train.txt", col.names = c("ActivityCode"))
trainSubject <- fread("./UCI HAR Dataset/train/subject_train.txt", col.names = c("SubjectID"))

# Reading test dataset
test <- fread("./UCI HAR Dataset/test/X_test.txt", col.names = features$featureName)
testCode <- fread("./UCI HAR Dataset/test/Y_test.txt", col.names = c("ActivityCode"))
testSubject <- fread("./UCI HAR Dataset/test/subject_test.txt", col.names = c("SubjectID"))

# Task-1: Merging training and the test sets 
# rbind on training and test followed by cbind on Subject, Code, featureName
mergedData <- cbind(rbind(trainSubject, testSubject), rbind(trainCode, testCode), rbind(train, test))

# Task-2: Extract only the measurements on the mean and standard deviation
colRequired <- grep("(mean\\(\\)|std\\(\\)|SubjectID|ActivityCode)", colnames(mergedData), value=TRUE)
mergedData <- subset(mergedData,select=colRequired) 

# Task-3: Use descriptive activity names to name the activities in the data set
mergedData$ActivityCode <- factor(mergedData$ActivityCode, levels=activity$classIndex, labels=activity$activityName)
names(mergedData) <- gsub("ActivityCode", "Activity", names(mergedData))

# Task-4: Appropriately label the data set with descriptive variable names
names(mergedData)<-gsub("-mean()", "Mean", names(mergedData), ignore.case = TRUE)
names(mergedData)<-gsub("-std()", "STD", names(mergedData), ignore.case = TRUE)
names(mergedData)<-gsub("-freq()", "Frequency", names(mergedData), ignore.case = TRUE)
names(mergedData)<-gsub("^t", "time", names(mergedData))
names(mergedData)<-gsub("^f", "frequency", names(mergedData))
names(mergedData)<-gsub("Acc", "Accelerometer", names(mergedData))
names(mergedData)<-gsub("Gyro", "Gyroscope", names(mergedData))
names(mergedData)<-gsub("Mag", "Magnitude", names(mergedData))
names(mergedData)<-gsub("BodyBody", "Body", names(mergedData))
names(mergedData)<-gsub("\\(\\)", "", names(mergedData))

# Task-5: Creates an independent tidy data set with the average of each variable for each activity and each subject. Using aggregate() with . and ~ operators. LHS of the ~ defines the variables to apply the function to and the RHS of the ~ defines the variables to group by. '.' implies all other variables not already mentioned in the formula.
OutputData <- aggregate(. ~ SubjectID + Activity, data=mergedData, mean)
write.table(OutputData, file = "tidyData.txt",row.name=FALSE,quote = FALSE, sep = '\t')
