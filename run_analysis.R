run.analysis <- function() {
	activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("id", "label"))
	features <- read.table("UCI HAR Dataset/features.txt", col.names=c("id", "label"))
	
	columnsNeeded <- grep(".*mean.*|.*std.*", features$label)
	columnsNeeded.names <- features[columnsNeeded,2]
	columnsNeeded.names = gsub('-mean', 'Mean', columnsNeeded.names)
	columnsNeeded.names = gsub('-std', 'Std', columnsNeeded.names)
	columnsNeeded.names <- gsub('[-()]', '', columnsNeeded.names)
	
	x_train <- read.table("UCI HAR Dataset/train/X_train.txt")[columnsNeeded]
	y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
	s_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
	train <- cbind(s_train, y_train, x_train)
	
	x_test <- read.table("UCI HAR Dataset/test/X_test.txt")[columnsNeeded]
	y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
	s_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
	test <- cbind(s_test, y_test, x_test)
	
	merged <- rbind(train, test)
	colnames(merged) <- c("subject", "activity", columnsNeeded.names)
	
	merged$activity <- factor(merged$activity, levels = activityLabels$id, labels = activityLabels$label)
	merged$subject <- factor(merged$subject)
	
	tidy = aggregate(merged, by=list(activity = merged$activity, subject=merged$subject), mean)
	
	write.table(merged, "tidy.txt", quote=FALSE, row.names=FALSE)
}