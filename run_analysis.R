
#R script called run_analysis.R that does the following. 

# Merges the training and the test sets to create one data set.
library(dplyr)
mydfXtest<- read.table("UCI HAR Dataset\\test\\X_test.txt")
mydfXtrain<- read.table("UCI HAR Dataset\\train\\X_train.txt")
mydfYtest<- read.table("UCI HAR Dataset\\test\\Y_test.txt")
mydfYtrain<- read.table("UCI HAR Dataset\\train\\Y_train.txt")
mydfSubTest<- read.table("UCI HAR Dataset\\test\\subject_test.txt")
mydfSubTrain<- read.table("UCI HAR Dataset\\train\\subject_train.txt")

mydfMeasures <-rbind(mydfXtest,mydfXtrain)
mydfActivity <-rbind(mydfYtest, mydfYtrain)
mydfSubjects <-rbind(mydfSubTest, mydfSubTrain)
mydf<-cbind(mydfSubjects,mydfActivity,mydfMeasures)

# Extracts only the measurements on the mean and standard deviation for each measurement.
features <-  read.table("UCI HAR Dataset\\features.txt")
mean_std_cols <- filter(features, grepl('mean|std', V2))
c <- mean_std_cols[,1]
mydf2 <- mydf[,c(1,2, c +2)]

# Uses descriptive activity names to name the activities in the data set
actTabel <- read.table("UCI HAR Dataset\\activity_labels.txt")
mydf3 <- merge(mydf2, actTabel, by.x = "V1.1", by.y = "V1")

# Appropriately labels the data set with descriptive variable names. 
colnames(mydf3)<- c("Activity_Key", "Subject", as.character(mean_std_cols[,2]), "Activity")

# From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.
untidyDataset <- tbl_df(mydf3)
untidyDataset <- select(untidyDataset, -Activity_Key)
untidyDataset <- select(untidyDataset, Activity, Subject, 2:80)
untidyDataset$Subject <- as.factor(untidyDataset$Subject) 

tidyDataset <- untidyDataset %>%
  group_by( Activity,Subject) %>%
     summarise_each(funs(mean))

