---
title: "Course Project's README file, making a tidy data set"
author: "Andrius Dalinkevicius"
date: "2015-06-20"
---

# Getting_and_Cleaning_Data_Coursera
This is the repository for the course project of the Getting and Cleaning Data course at Coursera.
 
##Description
This is the README file of the project to make a tidy data set of the "Human Activity Recognition Using Smartphones Dataset" experiment. The file includes some aspects of tidy data set and detailed explanation of the [script](https://github.com/andrius87/Getting_and_Cleaning_Data_Coursera/blob/master/run_analysis.R) for carrying out the transformation.

##Tidy data definition
According to the [article "Tidy Data"](http://vita.had.co.nz/papers/tidy-data.pdf) of Hadley Wickham, the tidy data should NOT have the following problems:

1. Column headers are values, not variable names.
2. Multiple variables are stored in one column.
3. Variables are stored in both rows and columns.

The raw data of this project contains above problems. So fixing them makes the raw data the tidy one with some features:

1. Each variable in one column.
2. Each different observation of that variable is in a different row.
3. Descriptive variable headings and values.

##Code for tidying the raw data
Here is the detailed explanation of the [script](https://github.com/andrius87/Getting_and_Cleaning_Data_Coursera/blob/master/run_analysis.R) to carry out a data tidying. The code is structured in some steps: *downloading data*, *getting data*, *step 1: merging*, *step 2: mean and std*, *step 3: activities, subjects*, *step 4: variable names*, *step 5: tidy data set*.

###Downloading data
This part of the code is for downloading the data using a url.

###Getting data
This part of the code is for reading the files from the source. The *list.files* object contains all file names. Not all of them are needed to complete the task. The needed files is listed on the [CodeBook](https://github.com/andrius87/Getting_and_Cleaning_Data_Coursera/blob/master/CodeBook.md).

###Step 1: merging
This part of the code represents the first step of the task: merging test and training data sets(*X_test* and *X_train*). As the number of columns of these objects are equal, I assume that variables(columns) match between these two data frames. So *rbind()* function is used.

###Step 2: mean and std
This part of the code represents the second step of the task: extracting only the measurements on the mean and standard deviation for each measurement. As stated in the *features_info* object, a mean estimate is labeled with *mean()* and a standard deviation  - *std()*. The *grep()* function is used to match required measurements. As the number of rows of the *features* object is equal to the number of columns of test and training data sets, I assume that the ordering is the same: rows in the *features* object match columns of *X_train* and *X_test* objects. 

###Step 3: activities, subjects
This part of the code represents the third step of the task: uses descriptive activity names to name the activities in the data set. The number of rows of objects *y_test* and *y_train*  is equal to the number of rows of objects *X_test* and *X_train* respectively. So I assume that the ordering matches. So the *cbind()* function is used to add activity codes to the main data set. Subjects are also added to the data set assuming the same ordering(*subject_test* and *subject_train*). Explicit activity names(*activity_labels*) are merged **lastly** as *merge()* function reorders the data frame, so the *cbind()* function couldn'd be applied. Activity names are descriptive itselfs so no renaming is needed.

###Step 4: variable names
This part of the code represents the fourth step of the task: appropriately label the data set with descriptive variable names. The *features* object contains all possible variables and I assume that the ordering matches: e.g., the 5'th row of the *features* object matches the 5'th column of *X_train* or *X_test* object(*V5* column). According to this assumption labels are attached. Those labels are not descriptive so far. The fifth part of the code sorts out that.

###Step 5: tidy data set 
This part of the code represents the fifth step of the task: from the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject. 

The following steps are required to make the data to be tidy:

1. In the table *dt1* there are many observations(rows) of variables for each subject and activity. As such the data frame is grouped by subject and activity and after that summarised by making averages of each variable  within the group. That makes the summarised data frame - *dt2*. For each combination of the *subject* and *activity* there is one observation of each variable. 

2. The *dt2* table is not tidy, because column headers are values(e.g., *tBodyAcc-mean()-X*), not variable names. As such it is needed to turn columns into rows. That creates molten data set with 4 columns: *subject*, *activity*, *variable*, *value*.

3. The molten data set is almost tidy, but  multiple variables are stored in one column. So the *variable* column is separated into 6 columns(see [CodeBook](https://github.com/andrius87/Getting_and_Cleaning_Data_Coursera/blob/master/CodeBook.md) for more details]): *signal*, *estimate*, *axis*,
*domain*, *device* and *jerk*. Also, descriptive variable names are made.

4. The *estimate* column contains two variables, *mean* and *std*, in rows. So the data is casted to make those variable to be in columns. The data set is now **tidy** according to features stated in the  *Tidy data definition* section.

5. Some more actions are made on data afterwards: all characters objects are in lower case, columns ordering are changed, data set is ordered. The final tidy data set is named as **tidy_dt** and exported to the *tidy_data_set_as_per_README.txt* file.
