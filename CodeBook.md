## Getting and Cleaning Data - Course Project - CodeBook.md

Sean Yarborough, Completed 06/29/2016

The run_analysis.R script creates a data.frame called **groupAverages** containing these variables:

* **subjectId** [integer] - a numeric label identifying the subject whom the data was collected for.  Ranges from 1 to 30.  Taken from the "subject_test.txt" and "subject_train.txt" files included with the original data.

* **activityType** [factor] - a character label representing the type of activity performed by the subject when the data was recorded.  One of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, or LAYING.  Mapped from an integer representation in the "y_test.txt" and "y_train.txt" files to its textual name with the "activity_labels.txt" file.

* **Measurement variables** [numeric] - accelerometer and gyroscope measurements from the original data set.  Variable names are in camel casing (e.g. thisIsCamelCasing) and are of the following form:
     
      * Element 1 (*time*, *freq*): Denotes whether the measurement is from the time domain sensor, or the frequency domain sensor.
      * Element 2 (*Body*, *Gravity*): Describes whether the measurement is of the body or gravitational motion component.
      * Element 3 (*Acc*, *Gyro*): Denotes whether the measurement is from the device accelerometer or gyroscope
      * Element 4 (*Jerk*, *JerkMag*): If included in the name, means that the measurement is of a jerk signal derived from the angular velocity measurements.
      * Element 5 (*Mean*, *Std*): Denotes whether the measurement is a mean or standard deviation value.
      * Element 6 (*-x*,*-y*,*-z*): If the measurement is of a single axial component, the hyphenated suffix indicates which axial component.
      
In the **groupAverages** dataset, the values shown in each row represent the mean of all measurements for a particular subject and activity (e.g. Subject 3, WALKING).      

For more information about the measurement methodology, please reference the original dataset located at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

***
**Notice per the original authors:**

Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.