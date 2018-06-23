# We take the data as provided by the original zip file at 
#    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Ensure to unzip these data in a subdirectory of the script "run_analysis.R" before you run it.
# For a description on the physical interpretation of the original data, we refer to the original ReadMe.txt. 
# For convenience that file is included at the bottom of this file.
# 
# The original zip file consists of 12 files in directory "test", 12 files in direcory "train" and 4 separate files in the meain directory.
# We read data from 11 (out of 12) training files, 11 (out of 12) test files and 1 (out of 4) separate files.
# Note that the following files from the original zip file are not read into R:
#   ./UCI HAR Dataset       --> features.txt // features_info.txt // README.txt
#   ./UCI HAR Dataset/train --> X_train.txt 
#   ./UCI HAR Dataset/test  --> X_test.txt
#
# Each training and test file consists of 128 readings. 
# Each training set consists of 2947 rows, and each test set constains 7352 rows.
# The script "runanalysis.R" reads in all different training and test files 
# For each of the 11 measures we combine the training and testset into one dataframe 
#   and calculate mean and standard deviation over the 128 readings
# the dataframe is extended with all measures to wide format and subsequenly melt into long format (personal interest during the project)
# Finally the dataframe readability is improved with Activity names and improved headers

# output
# -- dfmelt: for different activities (6) and subjects (30), different measurements (3) 
#          in different axis (3 = x/y/z) and two statistics (mean and sd)
#          in original dataset every subject takes each acitivity multiple times (but not every subject has the same as any other subject)
#          This enlarges the dataset to 185382 rows (much more than  6*30*3*3*2 = 3240)
# -- dfmelt_Red: reduced form of A. We take out statistic "standard deviation" and take average. That is the expected 6*30*3*3 = 1620 rows  


# ------------------------------------
# information from original ReadMe.txt
# data from 30 people, 70% is training data, 30% is testdata
# The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
# Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
# wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 
# we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
# The experiments have been video-recorded to label the data manually. 
# The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected 
# for generating the training data and 30% the test data. 

#The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width 
# sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational 
# and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. 
# The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used.
# From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 
# See 'features_info.txt' for more details. 

#For each record it is provided:
#  ======================================
#  
#  - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
#- Triaxial Angular velocity from the gyroscope. 
#- A 561-feature vector with time and frequency domain variables. 
#- Its activity label. 
#- An identifier of the subject who carried out the experiment.
#
#The dataset includes the following files:
#  =========================================
#  - 'README.txt'
#- 'features_info.txt': Shows information about the variables used on the feature vector.
#- 'features.txt': List of all features.
# - 'activity_labels.txt': Links the class labels with their activity name.
#- 'train/X_train.txt': Training set.    -- de meting van elke feature voor elke observatie (getallen tussen 0 en 1)
#- 'train/y_train.txt': Training labels. -- de activiteiten behorende bij observatie (gaat van 1 tot 6)
#- 'test/X_test.txt': Test set.          -- de meting van elke feature voor elke observatie (getallen tussen 0 en 1)
#- 'test/y_test.txt': Test labels.       -- de activiteiten behorende bij observatie (gaat van 1 tot 6)

#The following files are available for the train and test data. Their descriptions are equivalent. 
#- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
#- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. 
#          Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
#- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
#- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

#Notes: 
#  ======
#  - Features are normalized and bounded within [-1,1].
#- Each feature vector is a row on the text file.

