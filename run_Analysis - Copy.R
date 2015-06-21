load.train <- function() {
	x_train <- read.table("train/X_train.txt")
	y_train <- read.table("train/y_train.txt")
	s_train <- read.table("train/subject_train.txt")
	
	train <- cbind(s_train, y_train, x_train);
}

load.test <- function() {
	x_test <- read.table("test/X_test.txt")
	y_test <- read.table("test/y_test.txt")
	subject_test <- read.table("test/subject_test.txt")
	
	train <- cbind(s_test, y_test, x_test);
}

test <- load.test
train <- load.train
mData <- rbind(train, test)

features <- read.table("UCI HAR Dataset/features.txt")
fColumns <- grep(".*mean.*|.*std.*", features[,2])
features <- features[fColumns,]
mData <- mData[, fColumns]

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  allData$activity <- gsub(currentActivity, currentActivityLabel, allData$activity)
  currentActivity <- currentActivity + 1
}

allData$activity <- as.factor(allData$activity)
allData$subject <- as.factor(allData$subject)

tidy = aggregate(allData, by=list(activity = allData$activity, subject=allData$subject), mean)
tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t")
