


## Import Activity Labels Data -----------------------------------------

# import txt file as data frame
activity_labels <- read.table("Course 3 - Assignment/UCI Har Dataset/activity_labels.txt")

# add headers to data frame
names(activity_labels) <- c("activity_id", "activity")

# show output
activity_labels



## Import Column Names -----------------------------------------
column_names <- read.table("Course 3 - Assignment/UCI Har Dataset/features.txt")



## Import Test Data -----------------------------------------

# Import Activity ID
test_activity_id <- read.table("Course 3 - Assignment/UCI Har Dataset/test/y_test.txt")

# Import Activity Values
test_activity_val <- read.table("Course 3 - Assignment/UCI Har Dataset/test/X_test.txt")

# Import Subject ID
test_subject <- read.table("Course 3 - Assignment/UCI Har Dataset/test/subject_test.txt")

# Combine Test Data and Add Column Names
test_data <- cbind(test_subject, test_activity_id, test_activity_val)
names(test_data) <- c("subject_id", "activity_id", column_names[,2])

# show table stats
print("Test Data")
print(paste("Count of Rows:", nrow(test_data)))
print(paste("Count of Columns: ", ncol(test_data)))



## Import Train Data -----------------------------------------

# Import Activity ID
train_activity_id <- read.table("Course 3 - Assignment/UCI Har Dataset/train/y_train.txt")

# Import Activity Values
train_activity_val <- read.table("Course 3 - Assignment/UCI Har Dataset/train/X_train.txt")

# Import Subject ID
train_subject <- read.table("Course 3 - Assignment/UCI Har Dataset/train/subject_train.txt")

# Combine Test Data and Add Column Names
train_data <- cbind(train_subject, train_activity_id, train_activity_val)
names(train_data) <- c("subject_id", "activity_id", column_names[,2])

# show table stats
print("Train Data")
print(paste("Count of Rows:", nrow(train_data)))
print(paste("Count of Columns: ", ncol(train_data)))



## Combine Test and Train Data -----------------------------------------
activity_data <- rbind(test_data, train_data)


# show table stats -----------------------------------------
print("Test and Train Data")
print(paste("Count of Rows:", nrow(activity_data)))
print(paste("Count of Columns: ", ncol(activity_data)))



## Show Mean and Standard Deviation for Each Activity / Row -----------------------------------------

# Load dplyr
library(dplyr)

# Calculate for mean and standard dev for each row and combine all tables
summary_subject_id <- activity_data[,1]
summary_activity_id <- activity_data[,2]
summary_activity_mean <- rowwise(activity_data[,c(-1,-2)]) %>% summarize(mean(c_across(cols = everything())))
summary_activity_standard <- rowwise(activity_data[,c(-1,-2)]) %>% summarize(sd(c_across(cols = everything())))

summary_activity_data <- cbind(summary_subject_id, summary_activity_id, summary_activity_mean, summary_activity_standard)
names(summary_activity_data) <- cbind("subject_id", "activity_id", "activity_mean", "activity_standard_dev")
                          
# show table stats 
print("Summarized Data per Activity/Row")
head(summary_activity_data)
tail(summary_activity_data)
print(paste("Count of Rows:", nrow(summary_activity_data)))
print(paste("Count of Columns: ", ncol(summary_activity_data)))



## add activity names to both un-aggregated and aggregated data -----------------------------------------
activity_labels

# Un-aggregated Data
activity_data <- merge(activity_labels, activity_data, by.x = "activity_id", by.y = "activity_id", no.dups = TRUE)

names(activity_data)
head(activity_data[,c(1,2,3,4,5)])

# Aggregated Data
summary_activity_data <- merge(activity_labels, summary_activity_data, by.x = "activity_id", by.y = "activity_id", no.dups = TRUE)

names(summary_activity_data)
head(summary_activity_data)


## Aggregated Metric by Activity and Subject

summary_act_subject_data <- aggregate(activity_data[, c(-1,-2,-3)], by=list(activity_data$activity_id, activity_data$activity, activity_data$subject_id), FUN=mean)

names(summary_act_subject_data) <- c("activity_id", "activity", "subject_id", names(summary_act_subject_data[,c(-1,-2,-3)]))
head(summary_act_subject_data[,c(1,2,3,4,5)])

print(paste("unique categories: ", nrow(unique(summary_act_subject_data[,c(1,2,3)]))))
print(paste("total rows: ", nrow(summary_act_subject_data)))

# output content
write.table(summary_act_subject_data, file = "Course 3 - Assignment/output_step5.txt", row.names = FALSE)
