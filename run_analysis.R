rm(list = ls())

library(tidyverse)
library(dplyr)

data_dir <- "UCI HAR Dataset"

# Reference tables
features <- read_table(
  file.path(data_dir, "features.txt"),
  col_names = c("id", "feature"), 
  show_col_types = FALSE)

activity_labels <- read_table(
    file.path(data_dir, "activity_labels.txt"),
    col_names = c("activity_id", "activity"), 
    show_col_types = FALSE)

# Test set
X_test        <- read_table(file.path(data_dir, "test", "X_test.txt"),
                            col_names = features$feature, show_col_types = FALSE)
y_test        <- read_table(file.path(data_dir, "test", "y_test.txt"),
                            col_names = "activity_id", show_col_types = FALSE)
subject_test  <- read_table(file.path(data_dir, "test", "subject_test.txt"),
                            col_names = "subject_id", show_col_types = FALSE)

# Training set
X_train       <- read_table(file.path(data_dir, "train", "X_train.txt"),
                            col_names = features$feature, show_col_types = FALSE)
y_train       <- read_table(file.path(data_dir, "train", "y_train.txt"),
                            col_names = "activity_id", show_col_types = FALSE)
subject_train <- read_table(file.path(data_dir, "train", "subject_train.txt"),
                            col_names = "subject_id", show_col_types = FALSE)

# Combine components of tes  and training data seperately
test_data  <- bind_cols(subject_test,  y_test,  X_test)  |> mutate(source = "test")
train_data <- bind_cols(subject_train, y_train, X_train) |> mutate(source = "train")

# Filter name
measure_cols <- sort(names(X_test)[grepl("mean|std", names(X_test))])

# Combine test and training data
combo_mean_sd <- bind_rows(test_data, train_data) |>
  left_join(activity_labels, by = "activity_id") |>
  select(subject_id, activity, source, all_of(measure_cols)) |>
  mutate(activity = as.factor(activity))


# Tidy summary: average of each variable per subject and activity
tidy_summary <- combo_mean_sd |>
  group_by(subject_id, activity, source) |>
  summarise(across(where(is.numeric), mean), .groups = "drop")


