Getting and Cleaning Data - Project
===================================

## Background
> ### Human Activity Recognition Using Smartphones Dataset 
> #### Version 1.0

> Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
> Smartlab - Non Linear Complex Systems Laboratory
> DITEN - Università degli Studi di Genova.
> Via Opera Pia 11A, I-16145, Genoa, Italy.
> activityrecognition@smartlab.ws

> The experiments have been carried out with a group of 30 volunteers within an 
> age bracket of 19-48 years. Each person performed six activities 
> (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
> wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded 
> accelerometer and gyroscope, we captured 3-axial linear acceleration and 
> 3-axial angular velocity at a constant rate of 50Hz. The experiments have been
> video-recorded to label the data manually. The obtained dataset has been 
> randomly partitioned into two sets, where 70% of the volunteers was selected 
> for generating the training data and 30% the test data. 

> The sensor signals (accelerometer and gyroscope) were pre-processed by 
> applying noise filters and then sampled in fixed-width sliding windows 
> of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration 
> signal, which has gravitational and body motion components, was separated 
> using a Butterworth low-pass filter into body acceleration and gravity. 
> The gravitational force is assumed to have only low frequency components, 
> therefore a filter with 0.3 Hz cutoff frequency was used. 
> From each window, a vector of features was obtained by calculating variables 
> from the time and frequency domain. 

## Code Book

### Methodology

#### Tidy Data 1

1. Fetch data set archive and extract it 
2. Load subjects for the *train* set:
 - Load subjects for the *train* set from file *subject_train.txt*
 - Convert subjects to a factor
3. Load activities for the *train* set:
 - Load activity labels from file *activity_labels.txt*
 - Load activities for the *train* set from file *y_train.txt*
 - Convert activities to a factor using levels and labels from the previously loaded activity labels
4. Load measurements for the *train* set:
 - Load measurements for the *train* set from file *X_train.txt*
 - Load features from file *features.txt*
 - Improve the names of features:
  - replace *()* with *""* (blank)
  - replace *t* at the beginning with *time-*
  - replace *f* at the beginning with *frequency-*
  - replace *Acc* with *Acceleration*
  - replace *Mag* with *Magnitude*
 - Use the features as the column names for the measurements table 
 - Filter out everything but the columns that contain either *mean* or *std* but not *meanFreq* in their name
5. Combine subjects, activities and measurements using the *cbind()* function
6. Name the first column of the combined result *Subject* and the second column *Activity* 
7. Repeat 2 - 6 for the *test* set
8. Combine the 2 tables produced to one table using the *rbind()* function
9. Write table to disk named *tidy_data_1.txt*

#### Tidy Data 2

1. Use function *tidy_data_1()* that was created to generate the *tidy_data_1.txt* file to obtain the tidy data
2. Convert the data frame to a data table
3. Apply the *mean* function (using *lapply*) to all columns (but the first two) while grouping by **Subject** and **Activity**
4. Write table to disk named *tidy_data_2.txt*

### Variable Definition


| Variable              | Definition                                |
| :-------------------- | :---------------------------------------- | 
| Subject               | The id of the subject                     |
| Activity              | The label of the activity (one of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) |
| time-BodyAcceleration-mean-X | value |  
| time-BodyAcceleration-mean-Y | value |  
| time-BodyAcceleration-mean-Z | value |  
| time-BodyAcceleration-std-X | value |  
| time-BodyAcceleration-std-Y | value |  
| time-BodyAcceleration-std-Z | value |  
| time-GravityAcceleration-mean-X | value |  
| time-GravityAcceleration-mean-Y | value |  
| time-GravityAcceleration-mean-Z | value |  
| time-GravityAcceleration-std-X | value |  
| time-GravityAcceleration-std-Y | value |  
| time-GravityAcceleration-std-Z | value |  
| time-BodyAccelerationJerk-mean-X | value |  
| time-BodyAccelerationJerk-mean-Y | value |  
| time-BodyAccelerationJerk-mean-Z | value |  
| time-BodyAccelerationJerk-std-X | value |  
| time-BodyAccelerationJerk-std-Y | value |  
| time-BodyAccelerationJerk-std-Z | value |  
| time-BodyGyro-mean-X | value |  
| time-BodyGyro-mean-Y | value |  
| time-BodyGyro-mean-Z | value |  
| time-BodyGyro-std-X | value |  
| time-BodyGyro-std-Y | value |  
| time-BodyGyro-std-Z | value |  
| time-BodyGyroJerk-mean-X | value |  
| time-BodyGyroJerk-mean-Y | value |  
| time-BodyGyroJerk-mean-Z | value |  
| time-BodyGyroJerk-std-X | value |  
| time-BodyGyroJerk-std-Y | value |  
| time-BodyGyroJerk-std-Z | value |  
| time-BodyAccelerationMagnitude-mean | value |  
| time-BodyAccelerationMagnitude-std | value |  
| time-GravityAccelerationMagnitude-mean | value |  
| time-GravityAccelerationMagnitude-std | value |  
| time-BodyAccelerationJerkMagnitude-mean | value |  
| time-BodyAccelerationJerkMagnitude-std | value |  
| time-BodyGyroMagnitude-mean | value |  
| time-BodyGyroMagnitude-std | value |  
| time-BodyGyroJerkMagnitude-mean | value |  
| time-BodyGyroJerkMagnitude-std | value |  
| frequency-BodyAcceleration-mean-X | value |  
| frequency-BodyAcceleration-mean-Y | value |  
| frequency-BodyAcceleration-mean-Z | value |  
| frequency-BodyAcceleration-std-X | value |  
| frequency-BodyAcceleration-std-Y | value |  
| frequency-BodyAcceleration-std-Z | value |  
| frequency-BodyAccelerationJerk-mean-X | value |  
| frequency-BodyAccelerationJerk-mean-Y | value |  
| frequency-BodyAccelerationJerk-mean-Z | value |  
| frequency-BodyAccelerationJerk-std-X | value |  
| frequency-BodyAccelerationJerk-std-Y | value |  
| frequency-BodyAccelerationJerk-std-Z | value |  
| frequency-BodyGyro-mean-X | value |  
| frequency-BodyGyro-mean-Y | value |  
| frequency-BodyGyro-mean-Z | value |  
| frequency-BodyGyro-std-X | value |  
| frequency-BodyGyro-std-Y | value |  
| frequency-BodyGyro-std-Z | value |  
| frequency-BodyAccelerationMagnitude-mean | value |  
| frequency-BodyAccelerationMagnitude-std | value |  
| frequency-BodyBodyAccelerationJerkMagnitude-mean | value |  
| frequency-BodyBodyAccelerationJerkMagnitude-std | value |  
| frequency-BodyBodyGyroMagnitude-mean | value |  
| frequency-BodyBodyGyroMagnitude-std | value |  
| frequency-BodyBodyGyroJerkMagnitude-mean | value |  
| frequency-BodyBodyGyroJerkMagnitude-std| 
