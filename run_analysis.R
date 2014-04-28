library(data.table)

################################################################################
## Constants
const.dataSetBasePath <- "UCI HAR Dataset"
const.dataSetUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
const.featuresFilename <- "features.txt"
const.activityLabelsFilename <- "activity_labels.txt"
const.subjectActivityColnames <- c("Subject", "Activity")

################################################################################
## Functions

## Checks if the project data has already been downloaded and extracted
## and downloads/extracts it if necessary. 
## Args:
##   dataSetBasePath: the base location for the extracted project data
##   dataSetUrl: the URL to fetch the project data from
## Returns:
##   dateDownloaded: the date the project data was downloaded
fetch_data_set <- function(dataSetBasePath = const.dataSetBasePath,
                           dataSetUrl = const.dataSetUrl) {
    if (!file.exists(dataSetBasePath)) {        
        download.file(dataSetUrl, destfile="dataset.zip", method="curl")
        unzip("dataset.zip")
        dateDownloaded <<- date()
    }
    dateDownloaded
}

## Loads the features and attempts to make the feature names a bit more
## human readable
## Args:
##   dataSetBasePath: the base location for the extracted project data
## Returns:
##   betterNamedFeatures: the features list after making it more human readable
load_features <- function(dataSetBasePath = const.dataSetBasePath) {
    featuresAsTable <- read.table(paste0(dataSetBasePath, "/", 
                                         const.featuresFilename))
    features <- featuresAsTable$V2
    # remove ()
    betterNamedFeatures <- gsub("\\(\\)", "", features)
    # simple t to time-
    betterNamedFeatures <- gsub("^t", "time-", betterNamedFeatures)
    # simple f to frequency-
    betterNamedFeatures <- gsub("^f", "frequency-", betterNamedFeatures)
    # Acc to Accelaration (full word)
    betterNamedFeatures <- gsub("Acc", "Acceleration", betterNamedFeatures)
    ## Mag to Magnitude (full word)
    betterNamedFeatures <- gsub("Mag", "Magnitude", betterNamedFeatures)
    betterNamedFeatures
}

## Loads activity labels
## Args:
##   dataSetBasePath: the base location for the extracted project data
## Returns:
##   activityLabelsAsTable: the activity labels as a table
load_activity_labels <- function(dataSetBasePath = const.dataSetBasePath) {
    activityLabelsAsTable <- read.table(paste0(dataSetBasePath, "/", 
                                               const.activityLabelsFilename))
    activityLabelsAsTable
}

## Loads measurements for a particular data set (train or test), sets the column
## names to the features returned by the load_features() function and filters out 
## all the columns that are not mean or std measurements
## Args:
##   dataSetBasePath: the base location for the extracted project data
##   dataSetName: the name of the data set to load the measurements for
## Returns:
##   measurements: the filtered measurements for a data set as a table 
##                 with features as the column names
load_data_set_measurements <- function(dataSetBasePath = const.dataSetBasePath, 
                                       dataSetName) {
    # construct the filepath for the file that contains the measurements for this
    # data set (train or test)
    measurementsFilepath <- paste0(dataSetBasePath, "/", dataSetName, "/", 
                                   "X_", dataSetName, ".txt")
    # read the measurements into a table
    measurements <- read.table(measurementsFilepath)    
    # use the load_data_set_features function to get the feature names
    features <- load_features(dataSetBasePath)
    # use the feature names as the column names
    colnames(measurements) <- features 
    # construct a logical vector to choose just the mean and 
    # standard deviation for each measurement
    filter <- grepl("mean|std", features) & !grepl("meanFreq", features)
    # filter the measurements (keep just the mean and std ones)
    measurements <- measurements[, filter]
    # return the measurements
    measurements
}

## Loads subjects for a particular data set (train or test) and converts them
## to a factor
## Args:
##   dataSetBasePath: the base location for the extracted project data
##   dataSetName: the name of the data set to load the subjects for
## Returns:
##   subjects: the subjects for a data set as a factor
load_data_set_subjects <- function(dataSetBasePath = const.dataSetBasePath, 
                                   dataSetName) {
    # construct the filepath for the file that contains the subjects for this
    # data set (train or test)
    subjectsFilepath <- paste0(dataSetBasePath, "/", dataSetName, "/", 
                               "subject_", dataSetName, ".txt")
    # read the subjects into a table
    subjects <- read.table(subjectsFilepath)
    # convert the subjects table to a factor
    subjects <- factor(subjects[, 1], levels=1:30)
    # return the subjects
    subjects
}

## Loads activities for a particular data set (train or test), sets the column 
## names to the activity labels returned by the load_activity_labels() function 
## and converts them to a factor
## Args:
##   dataSetBasePath: the base location for the extracted project data
##   dataSetName: the name of the data set to load the activities for
## Returns:
##   activities: the activities for a data set as a factor
load_data_set_activities <- function(dataSetBasePath = const.dataSetBasePath, 
                                     dataSetName) {
    # construct the filepath for the file that contains the activities for this
    # data set (train or test)
    activitiesFilepath <- paste0(dataSetBasePath, "/", dataSetName, "/", 
                                 "y_", dataSetName, ".txt")
    # read the activities into a table
    activities <- read.table(activitiesFilepath)
    # use the load_data_set_activity_labels function to get the activity labels
    activityLabels <- load_activity_labels(dataSetBasePath)
    # convert the activities table to a factor
    activities <- factor(activities[,1], levels=activityLabels[, 1], 
                         labels=activityLabels[, 2])
    # return the activities
    activities
}

## Invokes previously defined methods to:
##  - fetch data
##  - load subjects
##  - load activities
##  - load measurements
## And then combines their results to a single table
## Finally it ensures that the column names for column 1 and 2 are set correctly
## Args:
##   dataSetBasePath: the base location for the extracted project data
##   dataSetName: the name of the data set to load
## Returns:
##   combined: the combined data set
load_data_set <- function(dataSetBasePath = const.dataSetBasePath, 
                          dataSetName) {
    # fetch data
    fetch_data_set()
    # use the load_data_set_subjects function to get the subjects
    subjects <- load_data_set_subjects(dataSetBasePath, dataSetName)
    # use the load_data_set_activities function to get the activities
    activities <- load_data_set_activities(dataSetBasePath, dataSetName)
    # use the load_data_set_measurements function to get the measurements
    measurements <- load_data_set_measurements(dataSetBasePath, dataSetName)
    # combine the subjects, activities and measurements to one table
    combined <- cbind(subjects, activities, measurements)
    # make column names better
    colnames(combined)[1:2] <- const.subjectActivityColnames
    combined
}

## Generates the tidy data (part 1) as required 
## by combining the tables for the train data set and the test data set
## Args:
##   dataSetBasePath: the base location for the extracted project data
## Returns:
##   tidy_data_1: the tidy data (part 1) as required
tidy_data_1 <- function(dataSetBasePath = const.dataSetBasePath) {
    if (!file.exists("tidy_data_1.txt")) {
        # load the train data set
        train <- load_data_set(dataSetBasePath, "train")
        # load the test data set
        test <- load_data_set(dataSetBasePath, "test")
        # merge the train and test data sets
        tidy_data_1 <- rbind(train, test)
        # write to a file
        write.table(tidy_data_1, file="tidy_data_1.txt")
    }
    else {
        tidy_data_1 <- read.table("tidy_data_1.txt")
    }
    tidy_data_1
}

## Generates the tidy data (part 2) as required by calling 
## the tidy_data_1() function and then:
##  - converting the data frame to a data table
##  - using lapply to apply the mean function while
## grouping by "Subject" and "Activity"
## Args:
##   dataSetBasePath: the base location for the extracted project data
## Returns:
##   tidy_data_2: the tidy data (part 2) as required
tidy_data_2 <- function(dataSetBasePath = const.dataSetBasePath) {
    if (!file.exists("tidy_data_2.txt")) {
        # use the tidy_data_1 function to get the tidy data as it stands
        tidy_data_1 <- tidy_data_1(dataSetBasePath)
        # convert tidy_data_1 data frame to a data table
        tidy_data_1_dt <- data.table(tidy_data_1)
        # apply the mean function to all columns but the first two 
        # grouping by "Subject" and "Activity"
        tidy_data_2 <- tidy_data_1_dt[, lapply(.SD, mean), 
                                      .SDcols=tail(names(tidy_data_1_dt), -2), 
                                      by=const.subjectActivityColnames]
        # write to a file
        write.table(tidy_data_2, file="tidy_data_2.txt")
    }
    else {
        tidy_data_2 <- read.table("tidy_data_2.txt")
    }
    tidy_data_2
}

################################################################################
## Produce tidy data

d1<-tidy_data_1()
d2<-tidy_data_2()

