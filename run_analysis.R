library(dplyr)

setwd("C:/Users/anujd/Documents/Analytics Learning/Week4 Project")

## Download and unzip the dataset:
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile = "main_dataset.zip")

# Unzip the dataset
unzip(zipfile = "main_dataset.zip")

# read train data
trainx <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("./UCI HAR Dataset/train/Y_train.txt")
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")


# read test data
testx <- read.table("./UCI HAR Dataset/test/X_test.txt")
testy <- read.table("./UCI HAR Dataset/test/Y_test.txt")
testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")


# read data description
var_names <- read.table("./UCI HAR Dataset/features.txt")

# read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")


# Ask 1 - Merges the training and the test sets to create one data set.
xtotal <- rbind(trainx, testx)
ytotal <- rbind(trainy, testy)
subject_total <- rbind(trainsubject, testsubject)


# Ask 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
selected_var <- var_names[grep("mean\\(\\)|std\\(\\)",var_names[,2]),]
x_total <- xtotal[,selected_var[,1]]


# 3. Uses descriptive activity names to name the activities in the data set
colnames(ytotal) <- "activity"
ytotal$activitylabel <- factor(ytotal$activity, labels = as.character(activity_labels[,2]))
activitylabel <- ytotal[,-1]


# 4. Appropriately labels the data set with descriptive variable names.
colnames(x_total) <- var_names[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(subject_total) <- "subject"
total <- cbind(x_total, activitylabel, subject_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_all(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
