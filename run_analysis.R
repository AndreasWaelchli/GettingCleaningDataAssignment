### Getting and Cleaning Data Assignment ###

## 0. Load the necessary packages
library(data.table) 
library(dplyr)

## 1. Download and unzip
# 1.1 Download the file from the server
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <- "data.zip"
download.file(url, file)

# 1.2 Unzip the file
unzip(file)

## 2. Data loading and transformation
# 2.1 Combine test/subject_test.txt and train/subject_train.txt and store it
#       in a data.table "subject"
subject <- funion(
    fread(file = "UCI HAR Dataset/test/subject_test.txt", 
          col.names = c("subjectId")),
    fread(file = "UCI HAR Dataset/train/subject_train.txt", 
          col.names = c("subjectId")),
    all = TRUE
)

# 2.2 Read the labels of y (=activities) and store it in "y_label"
y_label <- fread(file = "UCI HAR Dataset/activity_labels.txt", 
                 col.names = c("activityId", "activityStr"))

# 2.3 Combine test/y_test.txt and train/y_train.txt
y <- funion(
    fread(file = "UCI HAR Dataset/test/y_test.txt", col.names = "activityId"),
    fread(file = "UCI HAR Dataset/train/y_train.txt", col.names = "activityId"),
    all = TRUE
)

# 2.4 Read the feature names, use the second column and convert it into a
#       character list
X_label <- c(fread(file = "UCI HAR Dataset/features.txt")[,2])

# 2.5 Combine test/X_test.txt and train/X_train.txt, using X_label as column names
X_txt <- funion(
    fread(file = "UCI HAR Dataset/test/X_test.txt", col.names = X_label[[1]]),
    fread(file = "UCI HAR Dataset/train/X_train.txt", col.names = X_label[[1]]),
    all = TRUE
)

# 2.6 Select only the required measurements, and remove the brackets in variable names
X <- X_txt %>%
    select(contains("mean()"), contains("std()"))
names(X) <- gsub("\\(\\)", "", names(X))

## 3. Combine subject, y and X; join the y_label, make it a factor and exclude 
#       temporary variables activityStr and activityId
tidy <- cbind(subject, y, X)[y_label, nomatch=0, on="activityId"] %>%
    mutate(activity = as.factor(activityStr)) %>%
    select(-c(activityStr, activityId))

write.table(tidy, file="tidy.txt", row.name=FALSE)
tidy

## 4. Create new data set with the average of each variable for each activity
#       and subject
tidySmall <- tidy %>%
    group_by(subjectId, activity) %>%
    summarise_all(mean)
