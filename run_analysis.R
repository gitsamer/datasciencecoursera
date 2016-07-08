# Set the working Directory using setwd() to the data folder "./data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset"

# read the X_test.txt file which has the test data
test <- read.table("./test/X_test.txt", header=FALSE)

# read the features file which has the headers of the X_test.txt file
header_row <- read.table("./features.txt", header=FALSE)
#assign the features file headers to X_test data file
colnames(test) <- header_row$V2


# adding the activity numbers from the activity_test file as a first column to test and call it test_v1
# read the activity file from Y_test.txt
activity_test <- read.table("./test/Y_test.txt", header=FALSE)
# USe activity as column name for the activity column
colnames(activity_test) <- "activity"
# get the aliases for the activities
# read the activity_labels_txt which has the word meaning of the activity numbers
activity_label <- read.table("./activity_labels.txt", header=FALSE)
#replace the numbers 1 to 6 in the activity columns of test_v2 with the activity labels.
library(dplyr)
activity_test_v1 <- mutate(activity_test,activity_label=activity_label$V2[activity_test$activity])
#add the activity names as a column to test file and call it test_v1
test_v1 <- cbind(activity_test_v1, test)


# adding the subject numbers from the subject_test file as a first column to test_v1 and call it test_v2
subject_test <- read.table("./test/subject_test.txt", header=FALSE)
colnames(subject_test) <- "subject"
test_v2 <- cbind(subject_test, test_v1)

###read the train file, and enrich it same we did for the test file
# read the X_train.txt file which has the train data
train <- read.table("./train/X_train.txt", header=FALSE)
#assign the features file headers to X_test data file
colnames(train) <- header_row$V2
# read the activity file from Y_test.txt
activity_train <- read.table("./train/Y_train.txt", header=FALSE)
# USe activity as column name for the activity column
colnames(activity_train) <- "activity"
# get the aliases for the activities
activity_train_v1 <- mutate(activity_train,activity_label=activity_label$V2[activity_train$activity])
#add the activity names as a column to train file and call it train_v1
train_v1 <- cbind(activity_train_v1, train)
# adding the subject numbers from the subject_train file as a first column to train_v1 and call it train_v2
subject_train <- read.table("./train/subject_train.txt", header=FALSE)
colnames(subject_train) <- "subject"
train_v2 <- cbind(subject_train, train_v1)


#Combine test_v2 and train_v2 into one data_frame
test_train_v2 <- rbind(test_v2,train_v2)
  
  
#replace the _ and () in the the header names with _
columns_v1 <- gsub("-","_",names(test_train_v2))
columns_v2 <- gsub("\\(\\)","",columns_v1)
test_train_v3 <- test_train_v2
colnames(test_train_v3) <- columns_v2

## select the measurements with mean and std, and drop all the rest
selected_columns <- grep("mean([_]|$)|std|subject|activity_label", names(test_train_v3), value=TRUE)
#select(test_v3,selected_columns)
test_train_v4 <- subset(test_train_v3,select=selected_columns)

#calculate the avg for each activity and subject (subsetting, sapply)
test_train_v5 <- group_by(test_train_v4,subject,activity_label)
test_train_v6 <- summarise_each(test_train_v5,funs(mean))
write.table(test_train_v6,file="./X_test_train_enriched.txt",row.name=FALSE)
