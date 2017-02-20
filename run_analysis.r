library(dplyr)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./data/har.zip")
unzip("./data/har.zip", exdir="./data")

## Loading features and activity names
dir = "./data/UCI HAR Dataset/"
file = paste(dir, "features.txt", sep="")
feat = read.table(file)
file = paste(dir, "activity_labels.txt", sep="")
act = read.table(file)

## Loading Test datasets
dir = "./data/UCI HAR Dataset/test/"
file = paste(dir, "subject_test.txt", sep="")
s_test = read.table(file)
file = paste(dir, "X_test.txt", sep="")
x_test = read.table(file)
file = paste(dir, "y_test.txt", sep="")
y_test = read.table(file)

## Loading train datasets
dir = "./data/UCI HAR Dataset/train/"
file = paste(dir, "subject_train.txt", sep="")
s_train = read.table(file)
file = paste(dir, "X_train.txt", sep="")
x_train = read.table(file)
file = paste(dir, "y_train.txt", sep="")
y_train = read.table(file)

## Combine test and train datasets
  ## measurements
x = rbind(x_test, x_train)
colnames(x) = feat$V2

  ## activities
y = rbind(y_test, y_train)
y = merge(y, act, by="V1")
colnames(y) = c("activity_id","activity_name")

  ## subjects
s = rbind(s_test, s_train)
colnames(s) = "subject"

## merge all 3 tables together
ds = cbind(s, y, x)

## create indices vectors for selection of mean and std variables
measvect = grep("mean|std|activity_name|subject", colnames(ds))

## Create cleaned dataset
ds = ds[,measvect]

## Create tidy dataset with averages
tds = aggregate(ds[,3:81], list(ds$subject,ds$activity), mean)
colnames(tds) = colnames(ds)
write.table(tds, file="./data/aggregated_results.txt", row.names = FALSE)
