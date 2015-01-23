library(dplyr)
library(tidyr)

create_measurement_mean_dataset <- function() {
  # The feature file contains identifiers of the columns in the data file.
  features <- read.table("features.txt", col.names = c("column_index", "name"))
  # The activity labels file contains the human readable labels for the numeric
  # activity identifiers.
  activity_labels <- read.table("activity_labels.txt", col.names = c("id", "label"))
  
  # Loads and returns an activity dataset that has been split into three files
  # (data, corresponding activity labels and subject IDs).
  load_activity_dataset <- function(activity_data_file, activity_label_file, subject_id_file) {
    activity_data <- tbl_df(read.table(activity_data_file, colClasses = "numeric"))
    colnames(activity_data) <- features$name
    activity_labels <- read.table(activity_label_file, col.names = c("activity"))
    subject_ids <- read.table(subject_id_file, col.names = c("subject_id"))
    # Combine the three data frames column-wise as the rows are in order.
    combined_activity_data <- tbl_df(cbind(activity_data, activity_labels, subject_ids))
    return(combined_activity_data)
  }
  
  training_data <- load_activity_dataset(
    "train/X_train.txt", "train/y_train.txt", "train/subject_train.txt")
  test_data <- load_activity_dataset(
    "test/X_test.txt", "test/y_test.txt", "test/subject_test.txt")
  
  measurement_mean_by_subject_and_activity <-
    # Merge the training data and test data so that we have all the data in one data frame.
    rbind_list(training_data, test_data) %>%
    # Only select columns for measurement means and standard deviations
    # (in addition to subject_id and activity)
    select(subject_id, activity, contains("std()"), contains("mean()")) %>%
    # Turn activity into a factor so that we can work with them by name instead of number.
    mutate(activity=factor(activity, levels=activity_labels$id, labels=activity_labels$label)) %>%
    # Transform into long form with a row per measurement value.
    gather(measurement, value, -subject_id, -activity) %>%
    # Summarize the measurement data by their means.
    group_by(subject_id, activity, measurement) %>%
    summarize(measurement_mean=mean(value))

  write.table(measurement_mean_by_subject_and_activity,
              file = "measurement_mean_by_subject_and_activity.txt",
              row.names = FALSE)
}

create_measurement_mean_dataset()
