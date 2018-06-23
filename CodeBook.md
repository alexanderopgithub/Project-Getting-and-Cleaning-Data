#Codebook
# The script "run_analysis.R" produces 2 dataframes from the original datasets 
# The script returns two dataframes. dfmelt and dfmelt_red
# In dataframe dfmelt there are six columns
# -- activities (6): WALKING / WALKING_UPSTAIRS / WALKING_DOWNSTAIRS / SITTING / STANDING / LAYING
# -- subject (30): data from 30 people, where 70% entered the training set and 30% the test set. Indicated by an integer
# -- measurement (3): "body acc" // "body gyro" // "total acc". Three different types of measures were taken. 
# -- xyz (3): measures were taken in three directions
# -- statistic (2): we calculated the mean and standard deviation from 128 readings
# Note 1: in original dataset not each subject is measured on the same amount of each activity. 
#   In the original dataset all subjects are measured multiple times for each activity. 
#   The exact number changes from subject to subject, and from activity to activity.
#   This overlap is maintained in dataframe dfmelt: the total number of rows = 185382 and not 6*30*3*3*2 = 3240
# Note 2: it could be that column measure and column xyz belong together in all circumstances. 
# With the current setup we intend to allow for an easy analysis focussing eg on the x-direction over different measures

# with dataframe dfmelt_red we simplify dfmelt. The column statistic has been taken out from dataframe, and the overlap from Note 1
# has been taken out. That is: the mean has been taken over each activity,subject, measurement/xyz 
# Thus we obtain 3240/2 = 1620 rows in dfmelt_red
