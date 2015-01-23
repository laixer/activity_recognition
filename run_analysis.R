library(dplyr)

run_analysis <- function() {
  features <- read.table("features.txt", col.names = c("column_index", "name"))
  activity_labels <- read.table("activity_labels.txt", col.names = c("id", "label"))
  
  load_activity_dataset <- function(activity_data_file, activity_label_file, subject_id_file) {
    activity_data <- tbl_df(read.table(activity_data_file, colClasses = "numeric"))
    colnames(activity_data) <- features$name
    activity_labels <- read.table(activity_label_file, col.names = c("activity"))
    subject_ids <- read.table(subject_id_file, col.names = c("subject_id"))
    combined_activity_data <- tbl_df(cbind(activity_data, activity_labels, subject_ids))
    return(combined_activity_data)
  }
  
  training_data <- load_activity_dataset("train/X_train.txt", "train/y_train.txt", "train/subject_train.txt")
  test_data <- load_activity_dataset("test/X_test.txt", "test/y_test.txt", "test/subject_test.txt")
  
  combined_data <- rbind_list(training_data, test_data)
  combined_data <- select(combined_data, subject_id, activity, contains("std()"), contains("mean()"))
  combined_data <- mutate(combined_data, activity=factor(activity, levels=activity_labels$id, labels=activity_labels$label))
  combined_data <- gather(combined_data, measurement, value, -subject_id, -activity)
  combined_data <- summarize(group_by(combined_data, subject_id, activity, measurement), measurement_mean=mean(value))
  return(combined_data)
}

combined_data <- run_analysis()

# subject, activity, variable, mean