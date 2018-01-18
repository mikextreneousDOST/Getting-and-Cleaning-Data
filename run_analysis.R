
##This portions creates a "Modue 3 Getting and Cleaning Data" directory where will save all the downloaded data if the said data doesn't exist.

if (!file.exists("Modue 3 Getting and Cleaning Data")){
  
  dir.create("Modue 3 Getting and Cleaning Data")
}

#This portions download the data with a file name "getdat.dataset.zip" if doesn't exist in the directory

filename <- "getdat_dataset.zip"

if (!file.exists("filename")){
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, filename, method= "curl")
dateDownloaded <- date() ##Putting a date when the data was downloaded
}

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# This portion loads the  activity labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# This portion extract only the data on mean and standard deviation
WantedData <- grep(".*mean.*|.*std.*", wanted[,2])
WantedData.names <- features[WantedData,2]
WantedData.names = gsub('-mean', 'Mean', WantedData.names)
WantedData.names = gsub('-std', 'Std', WantedData.names)
WantedData.names <- gsub('[-()]', '', WantedData.names)

# This portions load the data set
train <- read.table("UCI HAR Dataset/train/X_train.txt")[WantedData]
trainAct <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainAct, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[WantedData]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# This portion merges datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", WantedData.names)

# This portions turns the  activities and subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)