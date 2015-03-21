## CodeBook.md

### Variables

* `xlabels   ` - loaded from `features.txt`, stores the x column headers
* `activities` - loaded from
* `x.test`, `y.test`, `s.test` - measurement, activity, and subject data for the **test** set
* `x.train`, `y.train`, `s.train` - measurement, activity, and subject data for the **training** set
* `columns   ` - the columns containing mean or standard deviation data to be subsetted
* `column    ` - the column number for the activity column
* `test      ` - the test set (created from x.test, y.test, s.test)
* `train     ` - the training set (created from x.train, y.train, s.train)
* `df        ` - the merged data set (created from test and train)
* `df2       ` - the aggregated data set (created from df by averaging over activities and subjects)
* `total.rows` - the total number of rows that df2a should have (30 x 6 = 180)

The final data set, `dfmeans.txt` is created from df2a using `write.table`.
The first row contains the column headers of which the first column contains the
activity type and the second column contains the subject who performed the
particular activity. The remaining columns contained the data averaged over all
the values matching the 'subject' and 'activity'.

### Data

The source of the data used in this analysis is the [Human Activity Recognition Using Smartphones Data/ Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) | [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.html), downloaded from the location: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

From this data set, the following files (in the folder `UCI HAR Dataset/` are used in the analysis:

```
features.txt             - for x column headers
activity_labels.txt      - to descriptively label activity types
test/X_test.txt          - for measurements (test set)
test/y_test.txt          - for activity type (test set)
test/subject_test.txt    - for subjects (test set)
train/X_train.txt        - for measurements (training set)
train/y_train.txt        - for activity type (training set)
train/subject_train.txt  - for subjects (training set)
```

### Transformations / work performed to clean the data

This R script `run_analysis.R` generates a tidy data set from the
data source mentioned above.
In order to do so, the following actions (1-5) are performed
(item 0 is optional--it is only performed if the zip file has not been
downloaded and unzipped).  Note that items 0-5 are performed in the
order 0, 4(a), 3, 2, 1, 4(b), 5.

0. **Download and unzip data as necessary**:
   If the data zip file does not exist, it is downloaded from the web.
   If the file has not been unzipped, this script will unzip its contents
   (for simplicity, only the folder `./UCI HAR Dataset` is checked for
   existence, rather than checking for the individually files--if these
   files are missing, the zip file may be unzipped manually.)

1. **Merge training and test sets into a single data set**
   Column binds are performed to create a data frames containing the
   test data and another data frame containing the training data.
   A row bind merges these two sets into a single data frame/table.

2. **Extract only the measurements on the mean and standard deviation for
   each measurement**. Note that both "mean()" and "meanFreq()" are captured
   subsetted here--if "meanFreq()" is to be excluded, the grep command
   for "mean" should be replaced by a grep for "mean()". In the case of
   standard deviation, greps for "std" and "std()" would result in the
   same column names, so no changes need to be made.

3. **Add descriptive activity names to name the activities in the data set**
   This is done by reading `activity_labels.txt` and storing it in
   the variable `activities`, which is used later to convert
   `y.test` and `y.train` into factor variables.

4. **Appropriately label data set with descriptive variable names.**
   (a) this is done by reading `features.txt`, and storing it in
   the variable `xlabels`, which is used later for the column headers
   in `x.test` and `x.train`.

   (b) since R converts dashes and brackets into
   dots for column names, multiple dots ('...') are subsequently
   replaced with a single dot ('.') for further readability.

5. **From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. Upload data set as a txt file created with write.table() using row.name=FALSE**
   The ddply command is used to average the data over each
   activity and subject.  Since there are 6 activities and
   30 subjects, the final data set should contain 180 rows.
