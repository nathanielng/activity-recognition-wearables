require(data.table)
require(plyr)
require(reshape2)

#0. Download and unzip data as necessary
if (!file.exists("./UCI-HAR-Dataset.zip")) { download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","./data/UCI-HAR-Dataset.zip",method="curl") }
if (!file.exists("./UCI HAR Dataset")) { require(downloader); unzip("./UCI-HAR-Dataset.zip", exdir = "./") }

#4. (a) Appropriately label data set with descriptive variable names
xlabels <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
xlabels <- xlabels[,2]

#3. Add descriptive activity names to name the activities in the data set
activities <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)

#Read in the data using the information in `xlabels` for the column names
#and use `activities` to convert y.test/y.train into factor variables.
x.test  <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=xlabels, nrows=3000, colClasses = "numeric")
y.test  <- read.table("UCI HAR Dataset/test/y_test.txt", col.names=c("y"), nrows=3000, colClasses = "integer")
y.test <- factor(activities[y.test$y,2])
s.test  <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"), nrows=3000, colClasses = "integer")

x.train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=xlabels, nrows=7400, colClasses = "numeric")
y.train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names=c("y"), nrows=7400, colClasses = "integer")
y.train <- factor(activities[y.train$y,2])
s.train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("subject"), nrows=7400, colClasses = "integer")
#note that the intertial folder is not loaded with read.table() here,
#as it does not contain any mean and standard deviation data.
#df <- data.table(rbind(cbind(s.test,y.test,x.test),cbind(s.train,y.train,x.train)))

#2. Extract measurements only on the mean and standard deviation
#   Note that grep captures both "mean()" and "meanFreq()" here.
#   If one wishes to avoid capturing "meanFreq()" the grep
#   command should be changed.
columns <- union(grep("mean",xlabels),grep("std",xlabels))
x.test  <- x.test[,columns]
x.train <- x.train[,columns]

#1. Merge training set and test set to create a single data set
test  <- cbind(x.test,y.test,s.test)
train <- cbind(x.train,y.train,s.train)
column <- length(names(x.test)) + 1
names(test)[column] <- "activity"
names(train)[column] <- "activity"
df <- data.table(rbind(test,train))

#4. (b) Appropriately label the data set with descriptive variable names (Part II)
#   replace occurrences of '...' with '.' in column names.
xlabels <- gsub(pattern = "\\.\\.", replacement = "", x = names(df))
#xlabels <- gsub(pattern = "Acc", replacement = "Accelerometer", x = xlabels) #didn't do this replacement because it isn't clear from features_info.txt where Acc=Acceleration vs Acc=Accelerometer!
xlabels <- gsub(pattern = "Gyro", replacement = "Gyroscope", x = xlabels)
xlabels <- gsub(pattern = "Freq", replacement = "Frequency", x = xlabels)
xlabels <- gsub(pattern = "BodyBody", replacement = "Body", x = xlabels)
setnames(df,names(df),xlabels)

#5. From the data set in step 4, create a second, independent tidy data set
#   with the average of each variable for each activity and each subject
df$subject <- factor(df$subject)
df2<- ddply(df,.(activity,subject), function(x) colMeans(x[, -c(column,column+1)]))
#removed below due to warning message
#df2 <- aggregate(df,by=list(activity=df$activity, subject=df$subject), mean)
#df2["activity"] <- NULL
#df2["subject"] <- NULL

#Upload data set as a txt file created with write.table() using row.name=FALSE
write.table(df2,file="dfmeans.txt",row.names=FALSE)

total.rows <-  (max(s.test,s.train) - min(s.test,s.train) + 1) * (nrow(activities)) # there should be 30 x 6 = 180 rows.
if (nrow(df2) != total.rows) {
  print(sprintf("Warning: there is a problem with the data set; there should be %d x %d = %d rows", no.of.subjects, no.of.activities, total.rows))
}
