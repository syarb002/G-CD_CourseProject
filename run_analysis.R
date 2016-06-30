## Getting and Cleaning Data -- Course Project
## Working directory is the "UCI HAR Dataset" folder as downloaded from source

require(dplyr)

## Start by pulling in the data
print("Reading in the data...")

train <- read.table("train/X_train.txt")
test <- read.table("test/X_test.txt")
trainLab <- read.table("train/y_train.txt")
testLab <- read.table("test/y_test.txt")
features <- read.table("features.txt")
activityLab <- read.table("activity_labels.txt")
trainSubj <- read.table("train/subject_train.txt")
testSubj <- read.table("test/subject_test.txt")

## Step 1 - Merge the test and train datasets
print("Merging test and train datasets...")

# When binding, maintain the order of train first, then test

combinedData <- rbind(train, test)
combinedDataLabs <- rbind(trainLab, testLab)
combinedDataSubj <- rbind(trainSubj, testSubj)

colnames(combinedData) <- features[,2]

## Step 2 - Extract only mean and standard deviation measurements
print("Extracting mean and standard deviation measures...")

combinedData <- combinedData[,sort(c(grep("-mean\\(\\)", colnames(combinedData)), 
                                     grep("-std\\(\\)", colnames(combinedData))))]

## Step 3 - Use descriptive names for the activity type
print("Determining activity types...")

combinedData <- cbind(activityLab[combinedDataLabs[,1],2], combinedData)
colnames(combinedData)[1] <- "activityType"

## Step 4 - Create descriptive variable names
print("Setting variable names...")

# To keep the variable names from being too long, I'm using mostly the same format
# as with the original dataset, but expanding a few things and removing others.  Though
# upper and lowercase characters are somewhat tedious to work with, I'm used to camel cased
# variable names (e.g. thisIsWhatOneLooksLike)

# Expand t to time and f to freq (domain signal)
colnames(combinedData) <- gsub("^t", "time", colnames(combinedData))
colnames(combinedData) <- gsub("^f", "freq", colnames(combinedData))

# Remove the parentheses from the mean and std functions, and capitalize to
# match the camel casing scheme
colnames(combinedData) <- gsub("-mean\\(\\)", "Mean", colnames(combinedData))
colnames(combinedData) <- gsub("-std\\(\\)", "Std", colnames(combinedData))

# Leave the x/y/z axis indicators where they are, but lowercase them
colnames(combinedData) <- gsub("-X", "-x", colnames(combinedData))
colnames(combinedData) <- gsub("-Y", "-y", colnames(combinedData))
colnames(combinedData) <- gsub("-Z", "-z", colnames(combinedData))

## Step 5 - Generate a dataset of means per feature, per activity, per subject
print("Creating activity/subject means dataset...")

combinedData <- cbind(combinedDataSubj, combinedData)
colnames(combinedData)[1] <- "subjectId"

# Create a data table, split it by subject and activity, then summarize each non-grouping
# column with the mean, store in groupAverages
groupAverages <- tbl_dt(combinedData)
groupAverages <- group_by(groupAverages, subjectId, activityType)
groupAverages <- as.data.frame(summarize_each(groupAverages, c("mean")))

## Cleaning up everything except the groupAverages dataset
rm(activityLab, combinedData, combinedDataSubj, combinedDataLabs, features, test, testLab, testSubj, 
   train, trainLab, trainSubj)


