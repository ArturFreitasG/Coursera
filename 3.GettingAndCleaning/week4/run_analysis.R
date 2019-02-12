# check if course's week 4 directory exists. If not, create it.
if(!file.exists("./Coursera")){dir.create("./Coursera")}
if(!file.exists("./Coursera/3.GettingAndCleaning")){dir.create("./Coursera/3.GettingAndCleaning")}
if(!file.exists("./Coursera/3.GettingAndCleaning/week4")){dir.create("./Coursera/3.GettingAndCleaning/week4")}

# week 4 directory
week4_dir <- "./Coursera/3.GettingAndCleaning/week4"

# zip file's url
url_zip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# destination file
destfile <- paste0(week4_dir, "/cleaning_data_week4.zip")

# download file. "libcurl" method selected, as it is running on Windows.
download.file(url_zip,destfile, method = "libcurl")

# unzip file
unzip(destfile, exdir = week4_dir)

# unzipped file directory
unzipped_dir <- paste0(week4_dir, "/UCI HAR Dataset")

# loading required libraries
library(dplyr)
library(data.table)

# reading base files
features_names <- read.table(paste0(unzipped_dir, "/features.txt"))
activities_names <- read.table(paste0(unzipped_dir, "/activity_labels.txt"))

# reading train files
features_train <- read.table(paste0(unzipped_dir, "/train/X_train.txt"))
activities_train <- read.table(paste0(unzipped_dir, "/train/Y_train.txt"))
subjects_train <- read.table(paste0(unzipped_dir, "/train/subject_train.txt"))
body_acc_x_train <- read.table(paste0(unzipped_dir, "/train/Inertial Signals/body_acc_x_train.txt"))
body_acc_y_train <- read.table(paste0(unzipped_dir, "/train/Inertial Signals/body_acc_y_train.txt"))
body_acc_z_train <- read.table(paste0(unzipped_dir, "/train/Inertial Signals/body_acc_z_train.txt"))
body_gyro_x_train <- read.table(paste0(unzipped_dir, "/train/Inertial Signals/body_gyro_x_train.txt"))
body_gyro_y_train <- read.table(paste0(unzipped_dir, "/train/Inertial Signals/body_gyro_y_train.txt"))
body_gyro_z_train <- read.table(paste0(unzipped_dir, "/train/Inertial Signals/body_gyro_z_train.txt"))
total_acc_x_train <- read.table(paste0(unzipped_dir, "/train/Inertial Signals/total_acc_x_train.txt"))
total_acc_y_train <- read.table(paste0(unzipped_dir, "/train/Inertial Signals/total_acc_y_train.txt"))
total_acc_z_train <- read.table(paste0(unzipped_dir, "/train/Inertial Signals/total_acc_z_train.txt"))

# reading test files
features_test <- read.table(paste0(unzipped_dir, "/test/X_test.txt"))
activities_test <- read.table(paste0(unzipped_dir, "/test/Y_test.txt"))
subjects_test <- read.table(paste0(unzipped_dir, "/test/subject_test.txt"))
body_acc_x_test <- read.table(paste0(unzipped_dir, "/test/Inertial Signals/body_acc_x_test.txt"))
body_acc_y_test <- read.table(paste0(unzipped_dir, "/test/Inertial Signals/body_acc_y_test.txt"))
body_acc_z_test <- read.table(paste0(unzipped_dir, "/test/Inertial Signals/body_acc_z_test.txt"))
body_gyro_x_test <- read.table(paste0(unzipped_dir, "/test/Inertial Signals/body_gyro_x_test.txt"))
body_gyro_y_test <- read.table(paste0(unzipped_dir, "/test/Inertial Signals/body_gyro_y_test.txt"))
body_gyro_z_test <- read.table(paste0(unzipped_dir, "/test/Inertial Signals/body_gyro_z_test.txt"))
total_acc_x_test <- read.table(paste0(unzipped_dir, "/test/Inertial Signals/total_acc_x_test.txt"))
total_acc_y_test <- read.table(paste0(unzipped_dir, "/test/Inertial Signals/total_acc_y_test.txt"))
total_acc_z_test <- read.table(paste0(unzipped_dir, "/test/Inertial Signals/total_acc_z_test.txt"))

# renaming columns in subjects, activities and features train set
names(subjects_train) <- "subject"
names(activities_train) <- "activity"
names(features_train) <- features_names$V2

# renaming columns in subjects, activities and features test set
names(subjects_test) <- "subject"
names(activities_test) <- "activity"
names(features_test) <- features_names$V2

# using cbind to merge subjects, activities and features in train set
train_set <- cbind(subjects_train, activities_train, features_train)

# using cbind to merge subjects, activities and features in test set
test_set <- cbind(subjects_test, activities_test, features_test)

# Step 1: merging the training and the test sets to create one data set, full_set
full_set <- rbind(train_set, test_set)

# Step 2: extracting only the measurements on the mean and standard deviation for each measurement
# "subject" and "activity" columns were kept.
full_set_mean_sd <- full_set[, grepl("subject|activity|.*mean.*|.*std.*", names(full_set))]

# Step 3: using descriptive activity names to name the activities in the data set
full_set_descriptive <- full_set_mean_sd
full_set_descriptive$activity <- as.character(factor(full_set$activity, levels = 1:6, labels = activities_names$V2))

# Step 4: Appropriately labeling the data set with descriptive variable names.
names(full_set_descriptive) <- gsub("tBodyAcc-","body_acceleration_time_from_accelerometer_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("tGravityAcc-", "gravity_acceleration_time_from_accelerometer_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("tBodyAccJerk-", "body_acceleration_jerk_time_from_accelerometer_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("tBodyGyro-", "body_acceleration_time_from_gyroscope_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("tBodyGyroJerk-", "body_acceleration_jerk_time_from_gyroscope_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("tBodyAccMag-", "body_acceleration_time_magnitude_from_accelerometer_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("tGravityAccMag-", "gravity_acceleration_time_magnitude_from_accelerometer_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("tBodyAccJerkMag-", "body_acceleration_jerk_time_magnitude_from_accelerometer_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("tBodyGyroMag-", "body_acceleration_time_magnitude_from_gyroscope_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("tBodyGyroJerkMag-", "body_acceleration_jerk_time_magnitude_from_gyroscope_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("fBodyAcc-", "body_acceleration_frequency_from_accelerometer_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("fBodyAccJerk-", "body_acceleration_jerk_frequency_from_accelerometer_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("fBodyGyro-", "body_acceleration_frequency_from_gyroscope_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("fBodyAccMag-", "body_acceleration_frequency_magnitude_from_accelerometer_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("fBodyBodyAccJerkMag-", "body_acceleration_jerk_frequency_magnitude_from_accelerometer_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("fBodyBodyGyroMag-", "body_acceleration_frequency_magnitude_from_gyroscope_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("fBodyBodyGyroJerkMag-", "body_acceleration_jerk_frequency_magnitude_from_gyroscope_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("\\(\\)", "", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("-", "_", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("std", "standard_deviation", names(full_set_descriptive))
names(full_set_descriptive) <- gsub("Freq", "frequency", names(full_set_descriptive))

# Step 5: Creating a second, independent tidy data set with the average of each variable for each 
# activity and each subject
tidy_data <- full_set_descriptive %>% group_by(subject, activity) %>% summarise_all(mean)
write.table(tidy_data, file = paste0(unzipped_dir, "/tidy_data.txt"), row.names = FALSE)