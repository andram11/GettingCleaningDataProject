## Project Part 1 
# Get feature names and subset to  features of mean or stdev measures 
feature.names <- read.table("UCI HAR Dataset/features.txt") 
desired.features <- grep("std|mean", feature.names$V2) 

# Do the same for train and test data sets
train.features <- read.table("UCI HAR Dataset/train/X_train.txt") 
desired.train.features <- train.features[,desired.features] 
test.features <- read.table("UCI HAR Dataset/test/X_test.txt") 
desired.test.features <- test.features[,desired.features] 

# Combine the two datasets into one data frame 
total.features <- rbind(desired.train.features, desired.test.features) 


# Attach column names to features 
colnames(total.features) <- feature.names[desired.features, 2] 


# Combine the train and test activity codes together
train.activities <- read.table("UCI HAR Dataset/train/y_train.txt") 
test.activities <- read.table("UCI HAR Dataset/test/y_test.txt") 
total.activities <- rbind(train.activities, test.activities) 

# Attach activity labels to activity codes 
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt") 
total.activities$activity <- factor(total.activities$V1, levels = activity.labels$V1, labels = activity.labels$V2)


# Combine the train and test subject ids 
train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt") 
test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt") 
total.subjects <- rbind(train.subjects, test.subjects) 


# Combine  subjects and activity names 
subjects.and.activities <- cbind(total.subjects, total.activities$activity) 
colnames(subjects.and.activities) <- c("subject.id", "activity") 


# Combine with measures of interest  
activity.frame <- cbind(subjects.and.activities, total.features) 

# Compute final Result 

result.frame <- aggregate(activity.frame[,3:81], by = list(activity.frame$subject.id, activity.frame$activity), FUN = mean) 
colnames(result.frame)[1:2] <- c("subject.id", "activity") 
write.table(result.frame, file="mean_measures.txt", row.names = FALSE) 

