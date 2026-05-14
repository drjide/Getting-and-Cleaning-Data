rm(list = ls())

library(tidyverse)
library(dplyr)

data_dir <- "C:/Users/HP/Downloads/Assignment/Getting-and-Cleaning-Data/UCI HAR Dataset"

# Reference tables
features        <- read_table(file.path(data_dir, "features.txt"),
                              col_names = c("id", "feature"), show_col_types = FALSE)
activity_labels <- read_table(file.path(data_dir, "activity_labels.txt"),
                              col_names = c("activity_id", "activity"), show_col_types = FALSE)

# Test set
X_test        <- read_table(file.path(data_dir, "test", "X_test.txt"),
                            col_names = features$feature, show_col_types = FALSE)
y_test        <- read_table(file.path(data_dir, "test", "y_test.txt"),
                            col_names = "activity", show_col_types = FALSE)
subject_test  <- read_table(file.path(data_dir, "test", "subject_test.txt"),
                            col_names = "subject_id", show_col_types = FALSE)

# Training set
X_train       <- read_table(file.path(data_dir, "train", "X_train.txt"),
                            col_names = features$feature, show_col_types = FALSE)
y_train       <- read_table(file.path(data_dir, "train", "y_train.txt"),
                            col_names = "activity", show_col_types = FALSE)
subject_train <- read_table(file.path(data_dir, "train", "subject_train.txt"),
                            col_names = "subject_id", show_col_types = FALSE)


#Prep test data
test_data <- bind_cols(subject_test, y_test, X_test)
mean_te_names <- names(test_data)[grepl("mean", names(test_data))]
std_te_names <- names(test_data)[grepl("std", names(test_data))]
test_data_mean_sd <- test_data |> 
  select(subject_id, activity, all_of(mean_te_names), all_of(std_te_names)) |> 
  mutate(source = "Test") 


#Prep training data
train_data <- bind_cols(subject_train, y_train, X_train)
mean_tr_names <- names(train_data)[grepl("mean", names(train_data))]
std_tr_names <- names(train_data)[grepl("std", names(train_data))]
train_data_mean_sd <- train_data |> 
  select(subject_id, activity, all_of(mean_tr_names), all_of(std_tr_names)) |> 
  mutate(source = "Train") 


#Combine test and training data
combo_mean_sd <- bind_rows(test_data_mean_sd, train_data_mean_sd)
combo_mean_sd <- combo_mean_sd |> select(subject_id, activity, source, sort(names(combo_mean_sd)))


##  Tidy data of average of each variable for each activity and each subject.
mean_names <- names(combo_mean_sd)[grepl("mean", names(combo_mean_sd))]
std_names <- names(combo_mean_sd)[grepl("std", names(combo_mean_sd))]


tidy_summary <- combo_mean_sd |> 
  group_by(subject_id, activity) |> 
  summarise(
    across(all_of(mean_names), mean),
    across(all_of(std_names), mean),
    .groups = "drop")


### Label activity variable
label_names <- activity_labels$activity
tidy_summary$activity <- as.factor(tidy_summary$activity)
levels(tidy_summary$activity)= label_names