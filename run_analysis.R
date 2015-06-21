library(dplyr)
library(tidyr)

## ------------------------------- downloading data 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(url, temp, method = "curl")

## ------------------------------- getting data 
list.files <- unzip(temp, list = TRUE) ## all available files
README <- readLines(unz(temp, list.files[4, 1])) ## Readme that contains all details about data
activity_labels <- read.table(unz(temp, list.files[1, 1])) ## activity labels
features <- read.table(unz(temp, list.files[2, 1])) ## all features
features_info <- readLines(unz(temp, list.files[3, 1])) ## info about features

## test data sets
X_test <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt")) 
y_test <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
subject_test <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))

## training data sets
X_train <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))
subject_train <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))

## unlink connection
unlink(temp)

## -------------------------------- step 1: merging
dt1 <- rbind(X_test, X_train)

## -------------------------------- step 2: extracting mean and standard deviation of measurements
means <- grep("mean\\()", features[, 2]) ## mean variables, excludes meanFreq()
stds <- grep("std\\()", features[, 2]) ## standard deviation variables
dt1 <- dt1[, c(means, stds)] 

## -------------------------------- step 3: activities, subjects
dt1 <- cbind(rbind(y_test, y_train), dt1) ## adding activity codes
colnames(dt1)[1] <- "activity_code"
dt1 <- cbind(rbind(subject_test, subject_train), dt1)
colnames(dt1)[1] <- "subject"

colnames(activity_labels) <- c("activity_code", "activity")
dt1 <- merge(dt1, activity_labels, by = "activity_code") ## merging lastly as the merge
                                                                   ## function reorders a data.frame
dt1$activity_code <- NULL ## don't need a columnt with activity codes
dt1 <- dt1[, c(1, dim(dt1)[2], c(2:(dim(dt1)[2] - 1)))] ## reordering columns 
    
## ------------------------------- step 4: variable names
which.vars <- as.numeric(sapply(strsplit(colnames(dt1)[-c(1, 2)], split = "V"), function(x) x[2]))
names.vars <- features[which.vars, "V2"]
colnames(dt1)[-c(1, 2)] <- as.character(names.vars)

## ------------------------------- step 5: 
## making tidy data set of averages of each variable for each activity and each subject

## grouping by subject and activity
act_sub <- group_by(dt1, subject, activity)
dt2 <- summarise_each(act_sub, funs(mean)) ## summary by averaging

## molten data
dt2 <- melt(dt2, id = c("subject", "activity"))

## cleaning variable names
dt2$variable <- gsub("\\()", "", dt2$variable)

## separating variable names
dt2 <- dt2 %>% separate(variable, c("measurement", "estimate", "axis"), sep = "-", extra = "merge")

## magnitudes
dt2 <- mutate(dt2, measurement = gsub("Mag", "", measurement))
dt2[is.na(dt2$axis), "axis"] <- "mag"

## frequancy and time domains
dt2 <- mutate(dt2, domain = substr(measurement, 1, 1)) ## first element
dt2[dt2$domain == "t", "domain"] <- "time"
dt2[dt2$domain == "f", "domain"] <- "freq"
dt2 <- mutate(dt2, measurement = substring(measurement, 2)) ## without first element

## instrument
dt2 <- mutate(dt2, device = ifelse(grepl("Acc", measurement), "accelerometer", "gyroscope"))
dt2 <- mutate(dt2, measurement = gsub("Acc" ,"", measurement)) ## cleaning
dt2 <- mutate(dt2, measurement = gsub("Gyro" ,"", measurement)) ## cleaning

## Jerk signals
dt2 <- mutate(dt2, jerk = ifelse(grepl("Jerk", measurement), "Yes", "No"))
dt2 <- mutate(dt2, measurement = gsub("Jerk" ,"", measurement)) ## cleaning
dt2 <- mutate(dt2, measurement = gsub("BodyBody" ,"Body", measurement)) ## cleaning
colnames(dt2)[3] <- "signal"

## dealing with estimate columns - decomposing into separate columns
dt2 <- dcast(dt2, subject + activity + signal + axis + domain + device + jerk ~ estimate)

## to lower case
dt2 <- mutate(dt2, activity = tolower(activity), signal = tolower(signal))

## reorganizing column
dt2 <- select(dt2, subject, activity, device, signal, jerk, axis, domain, mean, std)

## ordering
tidy_dt <- arrange(dt2, subject, activity, device, signal)
rm(dt2, dt1)

## exporting
write.table(tidy_dt, "tidy_data_set_as_per_README.txt", row.names = FALSE)



