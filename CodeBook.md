---
title: "Course Project's CodeBook, making a tidy data set"
author: "Andrius Dalinkevicius"
date: "2015-06-20"
---
 
## Project Description
This is the project to make a tidy data set of the "Human Activity Recognition Using Smartphones Dataset" experiment.

##Study design and data processing
A bit of information about the experiment(raw data generating process):

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (*WALKING*, *WALKING_UPSTAIRS*, *WALKING_DOWNSTAIRS*, *SITTING*, *STANDING*, *LAYING*) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the testdata.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

More information:

[Link to the site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 

###Collection of the raw data
The raw data was obtained from:

[Link to raw data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

Files used to make a tidy data set:

* "UCI HAR Dataset/test/X_test.txt" : Test set;
* "UCI HAR Dataset/test/y_test.txt" : Test labels;
* "UCI HAR Dataset/train/X_train.txt": Training set;
* "UCI HAR Dataset/train/y_train.txt": Training labels;
* "UCI HAR Dataset/activity_labels.txt": Activity names;
* "UCI HAR Dataset/features.txt": List of all features;
* "UCI HAR Dataset/test/subject_test.txt": Test subject labels;
* "UCI HAR Dataset/train/subject_train.txt": Trainin subject labels;

###Notes on the original (raw) data 
More information about the experiment and all raw data could be found in:

* "UCI HAR Dataset/README.txt": describes the experiment and lists all files available (raw data).
* "UCI HAR Dataset/features_info.txt": Shows information about the variables in the raw data(features). 

##Creating the tidy datafile
Aspects of the tidy data is provided in the [README](https://github.com/andrius87/Getting_and_Cleaning_Data_Coursera/blob/master/README.md) file.

###Guide to create the tidy data file
1. Open R-studio.
2. Make sure you have the following packages installed: *dlyr*, *tidyr*.
3. In the Console window run the line: source("run_analysis.R"). [Link to the file](https://github.com/andrius87/Getting_and_Cleaning_Data_Coursera/blob/master/run_analysis.R)
4. The output (tidy data set) is stored in your working directory named *tidy_data_set_as_per_README.txt*.

###Getting, cleaning, summarizing of the data
0. Downloading the data and reading files listed in the *Collection of the raw data* section.
1. Making one data set by combining training and test data sets(*X_test.txt*, *X_train.txt*).
2. Taking only mean and standard deviation estimates of variables (more info in *features_info.txt* file).
3. Assigning activity and subject labels to the data set (*activity_labels.txt*, *subject_test.txt*,  *subject_train.txt*).
4. Assigning variable names (*y_test.txt*, *y_train.txt*).
5. Making a tidy data set by:
* summarizing it as average of each variable for each activity and each subject,
* making molten data set,
* decomposing variable names into separate columns and making them more clear and readable.

The detailed explanation of above steps is in the [README](https://github.com/andrius87/Getting_and_Cleaning_Data_Coursera/blob/master/README.md) file.
 
##Description of the variables in the tiny_data_set_as_per_README file
* The dimension of the data set: 5940 obs. of 9 variables.
* Variables: *subject*, *activity*, *device*, *signal*, *jerk*, *axis*,
  *domain*, *mean*, *std*;

###subject
This variable represents volunteers of the experiment:
* Class - *interger*;
* There are 30 persons named as integers from 1 to 30;

###activity
This variable represents activities the person performed during the experiment:
* Class - *character*;
* 6 unique activities: *walking*, *walking_upstairs*, *walking_downstairs*, *sitting*, *standing*, *laying*;

###device
This variable represents the device embedded in the smartphone which captures signals of movements.
* Class - *character*;
* 2 devices were used to capture movements: *accelerometer* and *gyroscope*.

###signal
This variable represents two separate acceleration signals, body acceleration and gravity acceleration signals. The separation makes sence for only signals captured by a accelerometer(device == "accelerometer"). For signals captured by a gyroscope the value is always *body*.
* Class - *character*;
* Unique values: *body*, *gravity*;

###jerk
This variable represents Jerk signals. 
* Class - *character*;
* Unique values: *Yes* - Jerk signal was obtained, *No* - Jerk signal was not obtained;

###axis
This variable represents the dimension of which the signal was captured.
* Class - *character*;
* unique values: *X* - x axis, *Y* - y axis, *Z* - z axis, *mag* - the magnitude of these three-dimensional signals calculated using the Euclidean norm.

###domain
This variable represents the domain in which a signal was captured: time or frequency.
* Class - *charatcer*;
* unique values: *time* for time domain and *freq* for frequency domain.

###mean
This variable represents the mean estimation of the signal.
* Class - *numeric*;
* Measures are normalized and bounded within [-1,1];

###std
This variable represents the standard deviation estimation of the signal.
* Class - *numeric*;
* Measures are normalized and bounded within [-1,1];
 
