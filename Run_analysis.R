library(plyr)

# This is the code for week 4 pga of getting-and-cleaning-data-week-4

# Downloading the required dataset
if(!file.exists("./getcleandata")){dir.create("./getcleandata")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./getcleandata/projectdataset.zip")

# Unzipping the dataset
unzip(zipfile = "./getcleandata/projectdataset.zip", exdir = "./getcleandata")

# Reading training datasets
train_x <- read.table("./getcleandata/UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./getcleandata/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./getcleandata/UCI HAR Dataset/train/subject_train.txt")

#  Reading the test datasets
test_x <- read.table("./getcleandata/UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./getcleandata/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./getcleandata/UCI HAR Dataset/test/subject_test.txt")

# Reading the feature vector
features <- read.table("./getcleandata/UCI HAR Dataset/features.txt")

# Reading the activity labels
activityLabels = read.table("./getcleandata/UCI HAR Dataset/activity_labels.txt")

#  Assigning names to variables
colnames(train_x) <- features[,2]
colnames(train_y) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(test_x) <- features[,2]
colnames(test_y) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activityLabels) <- c("activityID", "activityType")

#  Merging all datasets into one set
all_the_trains <- cbind(y_train, subject_train,train_x)
all_test <- cbind(y_test, subject_test, x_test)
the_final_dataset <- rbind(all_the_trains, all_test)


#  Reading column names
colNames <- colnames(the_final_dataset)

#  Create vector for defining ID, mean, and sd
mean_and_std <- (grepl("activityID", colNames) |
                   grepl("subjectID", colNames) |
                   grepl("mean..", colNames) |
                   grepl("std...", colNames)
)

#  Making the necessary subset
setforMeanandStd <- the_final_dataset[ , mean_and_std == TRUE]

setWithActivityNames <- merge(setforMeanandStd, activityLabels,
                              by = "activityID",
                              all.x = TRUE)


#  Making the second tidy data set
the_tidy_set <- aggregate(. ~subjectID + activityID, setWithActivityNames, mean)
the_tidy_set <- the_tidy_set[order(the_tidy_set$subjectID, the_tidy_set$activityID), ]

#  Writing second tidy data set into a txt file using write.table() using row.name=FALSE
write.table(the_tidy_set, "tidySet.txt", row.names = FALSE)
