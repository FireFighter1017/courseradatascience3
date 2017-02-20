**Codebook**
============

###The Data

Source of dataset: [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The script will import data into subfolder named "data".  
Here is the content of this subfolder:

Object name             | Object type   | Purpose
------------------------|---------------|-----------------------
activity_labels.txt     | Table         | List of all 6 activities performed by subjects during the experiment.
features.txt            | Table         | List of measures available in "x" tables.  A full description of those measures is available in a file named "features_info.txt".
features_info.txt       | Text document | Detailled information of each measure, how they have been collected and how they have been transformed in order to produce the measurements tables (x_test, x_train).
README.txt              | Text document | Details about the study and organisation of data
subject_test.txt        | Table         | test subjects that were performing activities while data was collected
X_test.txt              | Table         | measurements of test subjects
y_test.txt              | Table         | test activities
subject_train.txt       | Table         | train subjects that were performing activities while data was collected
X_train.txt             | Table         | measurements of train subjects
y_train.txt             | Table         | train activites


###The script

Here are the steps required by the assignment:
  1. Merge the training and the test sets to create one data set.  
  2. Extract only the measurements on the mean and standard deviation for each measurement.  
  3. Use descriptive activity names to name the activities in the data set.  
  4. Appropriately label the data set with descriptive variable names.  
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

#### Preparation of the environment  
In order to complete these tasks, we need dplyr package:  
`library(dplyr)`

Then we can start with downloading the dataset:  
`download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./data/har.zip")`  
`unzip("./data/har.zip", exdir="./data")`

#### Loading data into R
Next thing we want to do is load the datasets into R.  

`dir = "./data/UCI HAR Dataset/"`
`file = paste(dir, "features.txt", sep="")`
`feat = read.table(file)`
`file = paste(dir, "activity_labels.txt", sep="")`
`act = read.table(file)`

`dir = "./data/UCI HAR Dataset/test/"`
`file = paste(dir, "subject_test.txt", sep="")`
`s_test = read.table(file)`
`file = paste(dir, "X_test.txt", sep="")`
`x_test = read.table(file)`
`file = paste(dir, "y_test.txt", sep="")`
`y_test = read.table(file)`

`dir = "./data/UCI HAR Dataset/train/"`
`file = paste(dir, "subject_train.txt", sep="")`
`s_train = read.table(file)`
`file = paste(dir, "X_train.txt", sep="")`
`x_train = read.table(file)`
`file = paste(dir, "y_train.txt", sep="")`
`y_train = read.table(file)`

Here is an explanation of the variables used:

Variable      |Description
--------------|-----------------
dir           | Folder used to read files
file          | file name that will be read
feat          | Features list
act           | Activity labels
s_test        | Subjects for test measurements
x_test        | Test measurements
y_test        | Test activities
s_train       | Subjects for test measurements
x_train       | Test measurements
y_train       | Test activities

#### The combination of datasets
Now we need to combine the datasets so we get one large dataset with all variables included.  We will also make sure the variables are named properly.

`x = rbind(x_test, x_train)`
`colnames(x) = feat$V2`

`y = rbind(y_test, y_train)`
`y = merge(y, act, by="V1")`
`colnames(y) = c("activity_id","activity_name")`

`s = rbind(s_test, s_train)`
`colnames(s) = "subject"`

`ds = cbind(s, y, x)`
Variables `x`, `y` and `s` contains the union of train and test datasets.
Variable `ds` contains the final full dataset with test, train, subject and activities data.

In `ds`, the first two columns are named `subject` and `activity_name`.  The other columns are named after the features from `feat` list.  

#### The selection of mean and standard deviation features
Ok, now that we have a full working dataset, we need to get rid of any feature that is not either a mean or a standard deviation.  But we have to make sure we keep `subject` and `activity_name` variables.
We do that by creating a logical vector (`measvect`) that tells us which columns satisfy these criterias.  By applying this vector to 

`measvect = grep("mean|std|activity_name|subject", colnames(ds))`
`ds = ds[,measvect]`

#### The aggregated results

Now that we have narrowed down the data we want, it is time to perform the last task:  Produce means for every features by subject, by activity.

`tds = aggregate(ds[,3:81], list(ds$subject,ds$activity), mean)`
`colnames(tds) = colnames(ds)`
`write.table(tds, file="./data/aggregated_results.txt")`

I have used a variable `tds` to store the resulting table so I can refer to the full dataset `ds` anytime even after the aggregation.
The resulting table is exported to file `"./data/aggregated_results.txt"

The result is a table of 81 variables 35 observations.

