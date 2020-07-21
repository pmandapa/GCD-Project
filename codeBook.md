## This file provides a detailed description of each step of the run_analysis.R script.

The data is downloaded to a local folder with a destination file name of data.zip and unzipped as follows.  
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
download.file(url, "data.zip")  
unzip(zipfile = "data.zip")

Following files are available in the subfolders train and test.  
-'train/X_train.txt': Main recorded training set for an activity. 7352 rows, 561 columns  
-'train/y_train.txt': Contains training data of activities’ codes. 7352 rows, 1 columns  
-'test/X_test.txt': Test set.  
-'test/y_test.txt': Test labels.  
-'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.  

### Units:
The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.  
The body acceleration signal obtained by subtracting the gravity from the total acceleration.  
The angular velocity vector measured by the gyroscope has units of radians/second.  

### The data from activity_labels.txt links the class labels with their activity name. The data is read into the variable called "activity" with columns named as classIndex and activityName. It has 6 rows and 2 columns  
activity <- fread("./UCI HAR Dataset/activity_labels.txt", col.names = c("classIndex", "activityName")) 

### The features.txt lists all features. The data is read into features variable. It has 561 rows and 2 columns. More detailed information on features is given in features_info.txt  
features <- fread("./UCI HAR Dataset/features.txt", col.names = c("index", "featureName"))

### Reading training datasets. Each column represents a featureName from the features dataset and each row represents a subject. Total rows = 7352  
train <- fread("./UCI HAR Dataset/train/X_train.txt", col.names = features$featureName)  # Main training data. Columns are named from features$featureName   
trainCode <- fread("./UCI HAR Dataset/train/Y_train.txt", col.names = c("ActivityCode"))  # Training labels. Columns are labelled as ActivityCode  
trainSubject <- fread("./UCI HAR Dataset/train/subject_train.txt", col.names = c("SubjectID")) # Training subject. Column name is SubjectID ranging from 1 to 30 

### Reading test dataset into variable test. Columns are named similar to training dataset, i.e featureName, ActivityCode, and SubjectID. Total rows = 2957
test <- fread("./UCI HAR Dataset/test/X_test.txt", col.names = features$featureName)  
testCode <- fread("./UCI HAR Dataset/test/Y_test.txt", col.names = c("ActivityCode"))  
testSubject <- fread("./UCI HAR Dataset/test/subject_test.txt", col.names = c("SubjectID"))  

### Task-1: Merging training and the test sets. rbind is used first on each of the train and test variables followed by cbind. Total rows = 7352+2957 = 10299, cols = 563  
mergedData <- cbind(rbind(trainSubject, testSubject), rbind(trainCode, testCode), rbind(train, test))

### Task-2: Extract only the measurements on the mean and standard deviation. Used grep command to look for mean() and std() in the column names of mergedData  
colRequired <- grep("(mean\\(\\)|std\\(\\)|SubjectID|ActivityCode)", colnames(mergedData), value=TRUE)  
mergedData <- subset(mergedData,select=colRequired) # This subsetted data has 10299 rows and 68 columns (including SubjectID and Activity)

## Task-3: Use descriptive activity names to name the activities in the data set. The ActivityCode column is filled with descriptive activity names using the factor command.  
mergedData$ActivityCode <- factor(mergedData$ActivityCode, levels=activity$classIndex, labels=activity$activityName)  
names(mergedData) <- gsub("ActivityCode", "Activity", names(mergedData)) # The column is also appropriately renamed as Activity

### Task-4: Appropriately label the data set with descriptive variable names
names(mergedData)<-gsub("-mean()", "Mean", names(mergedData), ignore.case = TRUE)       # All -mean() replaced with Mean  
names(mergedData)<-gsub("-std()", "STD", names(mergedData), ignore.case = TRUE)         # All -std() replaced with STD  
names(mergedData)<-gsub("-freq()", "Frequency", names(mergedData), ignore.case = TRUE)  # All -freq() replaced with Frequency  
names(mergedData)<-gsub("^t", "time", names(mergedData))  
names(mergedData)<-gsub("^f", "frequency", names(mergedData))  
names(mergedData)<-gsub("Acc", "Accelerometer", names(mergedData))  
names(mergedData)<-gsub("Gyro", "Gyroscope", names(mergedData))  
names(mergedData)<-gsub("Mag", "Magnitude", names(mergedData))  
names(mergedData)<-gsub("BodyBody", "Body", names(mergedData))  
names(mergedData)<-gsub("\\(\\)", "", names(mergedData))  

### Task-5: Creates an independent tidy data set with the average of each variable for each activity and each subject. Used aggregate() with . and ~ operators. LHS of the ~ defines the variables to apply the function to and the RHS of the ~ defines the variables to group by. '.' implies all other variables not already mentioned in the formula.  
OutputData <- aggregate(. ~ SubjectID + Activity, data=mergedData, mean)  
write.table(OutputData, file = "tidyData.txt",row.name=FALSE,quote = FALSE, sep = '\t') # Export OutputData into the final tidyData.txt file.
