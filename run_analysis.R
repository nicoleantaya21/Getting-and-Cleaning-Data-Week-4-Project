# This is the code to transform the data to a new, tidy data set.
# Getting and Cleaning Data final project

# 0. Reading in files and assigning variables.

	# 0.1. Load plyr, download and unzip the dataset.
		library(plyr)
		if(!file.exists("./getcleandata")){dir.create("./getcleandata")}
		fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
		download.file(fileURL, destfile = "./getcleandata/projectdataset.zip")
		unzip(zipfile = "./getcleandata/projectdataset.zip", exdir = "./getcleandata")

	# 0.2. Reading test tables.
		x_test <- read.table("./getcleandata/UCI HAR Dataset/test/X_test.txt")
		y_test <- read.table("./getcleandata/UCI HAR Dataset/test/y_test.txt")
		subject_test <- read.table("./getcleandata/UCI HAR Dataset/test/subject_test.txt")

	# 0.3. Reading train tables.
		x_train <- read.table("./getcleandata/UCI HAR Dataset/train/X_train.txt")
		y_train <- read.table("./getcleandata/UCI HAR Dataset/train/y_train.txt")
		subject_train <- read.table("./getcleandata/UCI HAR Dataset/train/subject_train.txt")

	# 0.4. Reading feature vector.
		features <- read.table("./getcleandata/UCI HAR Dataset/features.txt")

	# 0.5. Reading activity labels.
		activityLabels = read.table("./getcleandata/UCI HAR Dataset/activity_labels.txt")

	# 0.6. Assigning variable names.
		colnames(x_train) <- features[,2]
		colnames(y_train) <- "activityID"
		colnames(subject_train) <- "subjectID"

		colnames(x_test) <- features[,2]
		colnames(y_test) <- "activityID"
		colnames(subject_test) <- "subjectID"

		colnames(activityLabels) <- c("activityID", "activityType")

# 1. Merging the training and test data sets to create one data set. 
	alltrain <- cbind(y_train, subject_train, x_train)
	alltest <- cbind(y_test, subject_test, x_test)
	finaldata <- rbind(alltrain, alltest)

# 2. Extracting the measurements on the mean and standard deviation for each measurement.

	# 2.1. Reading the variable names.
		colNames <- colnames(finaldata)
		colNames

	# 2.2. Creating a vector for defining mean, standard deviation and ID. 
		mean_and_std <- (grepl("activityID", colNames) |
					grepl("subjectID", colNames) |
					grepl("mean..", colNames) |
					grepl("std...", colNames))

	# 2.3. Creating a subset from the merged data set.
		mean_and_std_subset <- finaldata[, mean_and_std == TRUE]

# 3. Descriptive activity names to name the activities in the data set. 
	ActivityNames_subset <- merge(mean_and_std_subset, activityLabels, by = "activityID", all.x = TRUE)

# 4. Labelling the data set with descriptive variable names.
	# done in steps 1, 2.2, and 2.3

# 5. Creating a second, tidy data set with the average of each variable for each activity and subject.

	# 5.1. Creating the second data set. 
		tidyData <- aggregate(. ~subjectID + activityID, ActivityNames_subset, mean)
		tidyData <- tidyData[order(tidyData$subjectID, tidyData$activityID),]

	# 5.2. Making that data set a txt file.
		write.table(tidyData, "tidyData.txt", row.names = FALSE)
