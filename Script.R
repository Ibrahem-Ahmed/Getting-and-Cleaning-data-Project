##set "My Documents" as path in windows enviroment
setwd(path.expand(('~')))

##download Dataset and unzip downloads
FilesURL<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
FilesURL<-gsub("https","http",FilesURL)
download.file(FilesURL,destfile = "Dataset.zip",method = "auto")
Dataset_Date<-date()
unzip("Dataset.zip")
setwd("./UCI HAR Dataset")

##read files
####read Labels (y_test.txt , y_train.txt)
y_test <- read.table(file = "./test/y_test.txt")
y_train <- read.table(file = "./train/y_train.txt")
####read Features (x_test.txt , x_train.txt)
x_test <- read.table(file = "./test/x_test.txt")
x_train <- read.table(file = "./train/x_train.txt")
####read Subject (subject_train.txt , subject_test.txt)
Subject_test <- read.table(file = "./test/subject_test.txt")
Subject_train <- read.table(file = "./train/subject_train.txt")
####Read Names
FeaturesNames <- read.table("./features.txt")
ActivityNames <- read.table("./activity_labels.txt")

##Merge Rows
X <- rbind(x_test,x_train)
Y <- rbind(y_test,y_train)
Subject <- rbind(Subject_test,Subject_train)

##Set Names
colnames(X) <- FeaturesNames$V2
colnames(Y) <- c("ActivityId")
names(Subject) <- c("SubjectId")
colnames(ActivityNames) <-c("ActivityId", "ActivityType")

##Merge Columns
Data_Sub_Y <- cbind(Subject, Y)
Data <- cbind(X, Data_Sub_Y)

##Get columns with names Mean or Std
Mean_Std<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
##Names of all selected columns
SelectedColumns<-c(as.character(Mean_Std), "SubjectId", "ActivityId" )
##Subsetting Data
Data<-subset(Data,select=SelectedColumns)

##Replace Activity ID with Activity Description from "ActivityNames"
Data$ActivityId<- factor(Data$ActivityId,labels=as.character(ActivityNames$ActivityType))
###Rename Data$ActivityId to Data$ActivityDescription
names(Data)[68]<-c("ActivityDescription")

##Get the tidy dataset
TidyData<-aggregate(. ~SubjectId + ActivityDescription, Data, mean)
TidyData<-Data[order(Data$SubjectId),]
write.table(Data, file = "TidyData.txt",row.name=FALSE)
write.csv(TidyData, "TidyData.csv")