## Getting and Cleaning Data - Course Project - README.md

Sean Yarborough, Completed 06/29/2016

The run_analysis.R script should be placed within the UCI HAR Dataset folder, which should be set as the working directory in R in order for this to work correctly.  The script goes through the five steps (or transformations) outlined in the project requirements.

First, a series of read.table commands are used to source the various pieces of data included in the UCI HAR Dataset folder.  These are stored as objects for use in later parts of the script.

```
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
```

**Step 1: Merging test and training datasets.**
The train and test datasets are merged with rbind and stored into a new object, combinedData.  Also, the activity labels and subject IDs are merged in the same way, into combinedDataLabs (for labels) and combinedDataSubj (for subject IDs).

Data from the "features.txt" file included with the original data set is used to set the column names of the combined dataset.

```
combinedData <- rbind(train, test)
combinedDataLabs <- rbind(trainLab, testLab)
combinedDataSubj <- rbind(trainSubj, testSubj)

colnames(combinedData) <- features[,2]
```

**Step 2: Extracting mean and standard deviation measurements.**
Of the 561 variables included, only those which were mean or standard deviation measures were kept.  From inspection, the variable names appeared to contain "-mean()" or "-std()" if they were to be kept.  These patterns were used in the grep command to subset the original dataset.

```
combinedData <- combinedData[,sort(c(grep("-mean\\(\\)", colnames(combinedData)), 
                                     grep("-std\\(\\)", colnames(combinedData))))]
```

**Step 3: Using descriptive names for the activity type.**
As delivered, the dataset labels only hold a numeric indicator denoting the activity type.  Using the "activity_labels.txt" file included with the dataset, this was converted to the textual activity name and appended to the dataset.

The column name is defined as activityType.

```
combinedData <- cbind(activityLab[combinedDataLabs[,1],2], combinedData)
colnames(combinedData)[1] <- "activityType"
```

**Step 4: Creating descriptive variable names.**
Each of the 561 variables represents a very specific measurement which is described in the variable name (or label).  A few transformations were made to make the labels slightly more intepretable and easier to recall.

The "t" or "f" preceding each variable name was expanded to "time" or "freq" to more accurately denote whether the measurement is a time domain signal or frequency domain signal.

```
colnames(combinedData) <- gsub("^t", "time", colnames(combinedData))
colnames(combinedData) <- gsub("^f", "freq", colnames(combinedData))
```

The parentheses were removed from the "mean()" and "std()" suffixes used to describe the measurement.  Also, the first letter was capitalized in order to maintain camel casing.

```
colnames(combinedData) <- gsub("-mean\\(\\)", "Mean", colnames(combinedData))
colnames(combinedData) <- gsub("-std\\(\\)", "Std", colnames(combinedData))
```

Finally, for those measurements with a specific axial direction, the -X/-Y/-Z suffixes were maintained, but made lowercase.

```
colnames(combinedData) <- gsub("-X", "-x", colnames(combinedData))
colnames(combinedData) <- gsub("-Y", "-y", colnames(combinedData))
colnames(combinedData) <- gsub("-Z", "-z", colnames(combinedData))
```

**Step 5: Generating a dataset of means per feature, per activity, per subject.**
With the combinedData in a more tidy condition, it can now be used to create the final output dataset.  Because Step 5 mentions that the averages to be calculated must also be on a per subject basis, the subject ID labels need to be merged in with the dataset, first.

```
combinedData <- cbind(combinedDataSubj, combinedData)
colnames(combinedData)[1] <- "subjectId"
```

With the labels in place and stored as the "subjectId" column, the dataset can now be split on both subject ID and activity type using dplyr commands.

```
groupAverages <- tbl_dt(combinedData)
groupAverages <- group_by(groupAverages, subjectId, activityType)
groupAverages <- as.data.frame(summarize_each(groupAverages, c("mean")))
```

A final step removes all objects created except for the final dataset which is stored as groupAverages.