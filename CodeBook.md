### Summary

This data set summarizes the mean/standard deviation of measurements from the "Human Activity Recognition Using Smartphones" data set.

### Original Data Set

Information, including the raw data, for the original data set may be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Variables

| variable         | description                                                                                                                                                                           |
|------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| subject_id       | Unique subject identifier.                                                                                                                                                            |
| activity         | Activity subject was performing when the measurements were taken.                                                                                                                     |
| measurement      | Type of the measurement. These correspond to the features of the original data set. Refer to the documentation for the original dataset.                                              |
| measurement_mean | The mean of all the measurements from the original data set for same subject_id/activity. As the original data is normalized, these values are unitless and lie in the range [-1, 1]. |

### Transformations

The original data is split into training and test data sets, and within each data set the columns are split between the data, activity label and subject id files.
The data was recombined into a single dataset before further processing was done. 

Mean and standard deviation columns were selected from the combined data set, the data was reshaped into long form with a row for every measurement/value and then summarized
by computing the mean of the measurement for each subject_id, activity, measurement combination.
Columns containing the keywords "mean()" or "std()" were selected to represent the mean and standard deviation measures of the original data set.

The numeric label identifier in the original data set was transformed into a character label using the activity_labels.txt data from the original data set.

The measurement names were not renamed to make it easier to refer to the original data set, if necessary.

