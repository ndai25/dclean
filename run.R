library("dplyr")
library("data.table")

subjectData <- rbind(read.table(file.path("./UCI HAR Dataset/train/Y_train.txt"),header = FALSE), read.table(file.path("./UCI HAR Dataset/test/Y_test.txt"),header = FALSE))
featureData<- rbind(read.table(file.path("./UCI HAR Dataset/train/X_train.txt"),header = FALSE), read.table(file.path("./UCI HAR Dataset/test/x_test.txt"),header = FALSE))
activityTest<-read.table(file.path("./UCI HAR Dataset/test/subject_test.txt"),header = FALSE)
activityTrain<-read.table(file.path("./UCI HAR Dataset/train/subject_train.txt"),header = FALSE)
activityData<-rbind(activityTrain,activityTest)

#Qustion 1
mergedData <- cbind(featureData, cbind(subjectData, activityData))


#Qustion 2
featureNames <- read.table(file.path("./UCI HAR Dataset/features.txt"),head=FALSE)
selectedNames<-c(as.character(featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]), "subject", "activity" )
mergedData<-subset(mergedData,select=selectedNames)


#Question 3
activityLabels <- read.table(file.path("./UCI HAR Dataset/activity_labels.txt"),header = FALSE)
activityTest$V1 <- factor(activityTest$V1,levels=activityLabels$V1,labels=activityLabels$V2)
activityTrain$V1 <- factor(activityTrain$V1,levels=activityLabels$V1,labels=activityLabels$V2)

#question 4
activityData<-rbind(activityTrain,activityTest)
names(subjectData)<-c("subject")
names(activityData)<- c("activity")
names(featureData)<- read.table(file.path("./UCI HAR Dataset/features.txt"),head=FALSE)$V2
mergedData <- cbind(featureData, cbind(subjectData, activityData))
mergedData<-subset(mergedData,select=selectedNames)


#question 5
secondData<-aggregate(. ~subject + activity, mergedData, mean)
secondData<-secondData[order(secondData$subject,secondData$activity),]
write.table(mergedData, file = "firstData.txt",row.name=FALSE)
write.table(secondData, file = "secondData.txt",row.name=FALSE)