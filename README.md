## 1. Overview

This code performs an analysis following ideas described in
the article [Data Science, Wearable Computing and the Battle for the Throne as World’s Top Sports Brand](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/).

## 2. Data Sources

The source of the data used in this analysis is the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) | [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.html), downloaded from the location: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## 3. File Descriptions

### 3.1 `run_analysis.R`

This R script file generates a tidy data set from the data source mentioned
above, via the following actions (1-5). A more detailed description is provided
in `CodeBook.md`.

0. Download and unzip data as necessary.
1. Merge training and test sets into a single data set.
2. Extract only the measurements on the mean and standard deviation for
   each measurement.
3. Add descriptive activity names to name the activities in the data set.
4. Appropriately label data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set
   with the average of each variable for each activity and each subject.
   Upload data set as a txt file created with write.table() using row.name=FALSE.

### 3.2 `CodeBook.md`

This is a code book that describes the variables, the data, and any
transformations or work performed to clean up the data.
These actions (loading the data into the variables and cleaning the
data) are carried out in the script `run_analysis.R`

### 3.3 `dfmeans.txt`

This file will be generated after a successful execution of `run_analysis.R`
