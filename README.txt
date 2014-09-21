****************************************************************************************************************************************************************
Please download the source data from the URL and unzip the folder UCI HAR Dataset to your working directory

****************************************************************************************************************************************************************


=============================================================================
R script is called run_analysis.R . Below is the sequence of execution and what is being achieved at each step
=============================================================================

___________________________
0 . loding dplyr function
---------------------------------------------------------------
library(dplyr)


---------------------------------------------------------------------------------------------------------------------------------------------------
1. Merges the training and the test sets to create one data set.
---------------------------------------------------------------------------------------------------------------------------------------------------


read test and Train files from folder UCI HAR Dataset
---------------------------------------------------------------------------------------------------------------------------------
mydfXtest<- read.table("UCI HAR Dataset\\test\\X_test.txt")
mydfXtrain<- read.table("UCI HAR Dataset\\train\\X_train.txt")
mydfYtest<- read.table("UCI HAR Dataset\\test\\Y_test.txt")
mydfYtrain<- read.table("UCI HAR Dataset\\train\\Y_train.txt")
mydfSubTest<- read.table("UCI HAR Dataset\\test\\subject_test.txt")
mydfSubTrain<- read.table("UCI HAR Dataset\\train\\subject_train.txt")


1.1 binds dataframes containng measures of variables of test and train files
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
mydfMeasures <-rbind(mydfXtest,mydfXtrain)

1.2 binds dataframe containng activity number of test and train file
--------------------------------------------------------------------------------------------------------------------------------------------------------------
mydfActivity <-rbind(mydfYtest, mydfYtrain)

1.3 binds dataframe containng subjects of test and train file
------------------------------------------------------------------------------------------------------------------------------------------------
mydfSubjects <-rbind(mydfSubTest, mydfSubTrain)

1.4 Merges the training and the test sets to create one data set.
------------------------------------------------------------------------------------------------------------------------------------------------------
mydf<-cbind(mydfSubjects,mydfActivity,mydfMeasures)



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2. Extracts only the measurements on the mean and standard deviation for each measurement.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


2.1 reading feature variables folder UCI HAR Dataset
-------------------------------------------------------------------------------------------------------------------------
features <-  read.table("UCI HAR Dataset\\features.txt")

2.2 Extracting relevant columns containng "mean" and "std"
------------------------------------------------------------------------------------------------------------------------------------------------
mean_std_cols <- filter(features, grepl('mean|std', V2))
c <- mean_std_cols[,1]

2.3  create a temp dataset mydef2, where only relevant columns extracted to c are kept. Note that the first 2 columns of mydf has subject and activty . so the relevant columns of variable measures shifted by 2. 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
mydf2 <- mydf[ ,c(1,2, c +2)]



-------------------------------------------------------------------------------------------------------------------------------------------------------------------
3. Uses descriptive activity names to name the activities in the data set
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

3.1 reading activity label which contains activity name and number in actTabel dataframe
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
actTabel <- read.table("UCI HAR Dataset\\activity_labels.txt")

3.2 merging the ActTables and mydf2 to get Activity names attached and store the result in mydf3 dataframe.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
mydf3 <- merge(mydf2, actTabel, by.x = "V1.1", by.y = "V1")



_____________________________________________________________________
4. Appropriately labels the data set with descriptive variable names. 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
colnames(mydf3)<- c("Activity_Key", "Subject", as.character(mean_std_cols[,2]), "Activity")


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

5.1.conbert mydf3 dataframe into dplyr compatible table, drop column Activity_key, sequence the columns, and convert the subject column as a facto variable.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
untidyDataset <- tbl_df(mydf3)
untidyDataset <- select(untidyDataset, -Activity_Key)
untidyDataset <- select(untidyDataset, Activity, Subject, 2:80)
untidyDataset$Subject <- as.factor(untidyDataset$Subject) 

5.2 Create a tidy data set vy grouping the Activity and subject column and summarising the grouped levels with mean/average
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
tidyDataset <- untidyDataset %>%
  group_by( Activity,Subject) %>%
     summarise_each(funs(mean))




