# Getting and Cleaning Data — Course Project

A repository for the Course Project on Getting and Cleaning Data.

The analysis script is saved as `run_analysis.R`. The raw data is stored in the working directory under `UCI HAR Dataset/`.

Raw data can be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

---

## Data Structure

The dataset has 2 main parts:

### 1. Reference Data

Two key reference files are used:

- **`features.txt`** — Contains the names of the 561 measurements captured for each participant. These are used as descriptive column names (`colnames`) when loading the participant measurement data.
- **`activity_labels.txt`** — Contains the 6 activities tracked during testing (e.g. WALKING, SITTING). The descriptive activity names from this file are mapped onto the numeric activity IDs in the dataset.

Note: The **`features.txt`** file in the raw UCI HAR Dataset contains duplicate column names for a number of  measurements, which were recorded across X, Y, and Z axes but mistakenly given identical names — these are automaitcally flagged read_table() flagged and auto-appended with _1, _2 suffixes to deduplicate them. This will have no impact on current  analysis since those columns contain neither "mean" nor "std" are not affected by this


### 2. Subject Data (Test and Train)

For both the test and train sets, three files are combined using column binding (`bind_cols`) to form one dataset each:

| File            | Contents                     |
|-----------------|------------------------------|
| `subject_*.txt` | Participant (subject) IDs    |
| `y_*.txt`       | Activity IDs per observation |
| `X_*.txt`       | The 561 measurement columns  |

The reference data above ensures that activity IDs and measurements are mapped correctly and have descriptive labels.

## Combined Dataset

After forming the test and train datasets separately, they are combined by row binding (`bind_rows`).

Only **mean** and **standard deviation** measurements are required for this analysis. These are extracted by filtering column names using `grepl()` earlier to retain only columns containing `"mean"` or `"std"`.


## Tidy Data of Mean of **means** and **standard deviations**

A tidy data is created of means of  **means** and **standard deviations** across participants across activities using `group_by` and `summarize` with piping
