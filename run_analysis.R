# this script combines data from training set (2947 rows) and test set (7352 rows) to derive two data frames
# input: we read measured data on 128 readings from 11 training files, 11 test files and file "activity labels.txt"

# output
# -- dfmelt: for different activities (6) and subjects (30), different measurements (3) 
#          in different axis (3 = x/y/z) and two statistics (mean and sd)
#          in original dataset every subject takes each acitivity multiple times (but not every subject has the same as any other subject)
#          This enlarges the dataset to 185382 rows (much more than  6*30*3*3*2 = 3240)
# -- dfmelt_Red: reduced form of A. We take out statistic "standard deviation" and take average. That is the expected 6*30*3*3 = 1620 rows  

# we use 3 extra packages
library(dplyr)
library(reshape2)
library(tidyr)

# read activity labels, and adjust headers for activity labels
activity_labels<-read.table('./UCI HAR Dataset/activity_labels.txt')  # 6 activities
colnames(activity_labels) <- c("ActivityNr","Activity")

# read all training data [11 sets]
body_acc_x_train<-read.table('./UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt',stringsAsFactors=FALSE)
body_acc_y_train<-read.table('./UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt',stringsAsFactors=FALSE)
body_acc_z_train<-read.table('./UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt',stringsAsFactors=FALSE)
body_gyro_x_train<-read.table('./UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt',stringsAsFactors=FALSE)
body_gyro_y_train<-read.table('./UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt',stringsAsFactors=FALSE)
body_gyro_z_train<-read.table('./UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt',stringsAsFactors=FALSE)
total_acc_x_train<-read.table('./UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt',stringsAsFactors=FALSE)
total_acc_y_train<-read.table('./UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt',stringsAsFactors=FALSE)
total_acc_z_train<-read.table('./UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt',stringsAsFactors=FALSE)
subject_train<-read.table('./UCI HAR Dataset/train/subject_train.txt',stringsAsFactors=FALSE)
y_train<-read.table('./UCI HAR Dataset/train/y_train.txt',stringsAsFactors=FALSE)

# read all test data [11 sets]
body_acc_x_test<-read.table('./UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt',stringsAsFactors=FALSE)
body_acc_y_test<-read.table('./UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt',stringsAsFactors=FALSE)
body_acc_z_test<-read.table('./UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt',stringsAsFactors=FALSE)
body_gyro_x_test<-read.table('./UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt',stringsAsFactors=FALSE)
body_gyro_y_test<-read.table('./UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt',stringsAsFactors=FALSE)
body_gyro_z_test<-read.table('./UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt',stringsAsFactors=FALSE)
total_acc_x_test<-read.table('./UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt',stringsAsFactors=FALSE)
total_acc_y_test<-read.table('./UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt',stringsAsFactors=FALSE)
total_acc_z_test<-read.table('./UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt',stringsAsFactors=FALSE)
subject_test<-read.table('./UCI HAR Dataset/test/subject_test.txt',stringsAsFactors=FALSE)
y_test<-read.table('./UCI HAR Dataset/test/y_test.txt',stringsAsFactors=FALSE)


# above we read 11 sets for train and 11 sets for test
# put names of all read files in a list
z <- list('y','subject',
          'body_acc_x','body_acc_y','body_acc_z',
          'body_gyro_x', 'body_gyro_y', 'body_gyro_z',
          'total_acc_x', 'total_acc_y', 'total_acc_z')
nrz = length(z)
names(z) = 1:nrz

# initialize dataframe
nrobs <- nrow(y_test) + nrow(y_train) #10299 observations
df = data.frame(id=1:nrobs)

# extend dataframe with new columns containing mean and sd of variables (for y and subject only mean)
pl=1
for (k in 1:nrz) {

    # dynamically bind the test and train dataframe into one dataframe A
    A <- rbind.data.frame(get(paste0(z[k],"_test")) , get(paste0(z[k],"_train")))

    pl=pl+1
    df <- mutate(df, apply(X = A,MARGIN=1,FUN=mean)) # take average over 128 measurements
    names(df)[pl] <- c(paste(z[k],'mean',sep='_'))
    
    
    if (k >= 3) {   # case y and subject are excluded 
      df <- mutate(df,apply(X = A,MARGIN=1,FUN=sd)) # take standard deviation over 128 measurements
      pl=pl+1
      names(df)[pl] <- c(paste(z[k],'sd',sep='_'))
     }
}
names(df)[2:3] <- c("y", "subject")

# table(df$subject_mean,df$y_mean) show distribution subject/activity

# melt into long format: from 10299*21 to 10299*18=185382 rows and 4 columns
calcvar <- colnames(df)[4:ncol(df)]
dfmelt <- melt(df,id=c("y","subject"),measure.vars = calcvar )

# separate column "variable" into 3 columns
dfmelt$variable <- sub("_"," ",dfmelt$variable)
dfmelt <- separate(data = dfmelt, col = variable, into = c("measure","xyz","statistic"), sep = "_")

# replace number of "Activty number" by description of "Activity
dfmelt <- merge(activity_labels,dfmelt,by.y="y",by.x="ActivityNr")   # add ActivityNr and Activity  
dfmelt <- select(dfmelt,-ActivityNr)                                 # take out ActivityNr

#  reduce data set A: for each activity and each subject, present average of each variable
dfmelt_red <- mutate(dfmelt) %>%
    filter(statistic == "mean") %>%
    group_by(Activity,subject,measure,xyz)  %>%
    summarize(mean = mean(value))

