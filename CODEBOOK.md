# Code Book — Getting and Cleaning Data Course Project

## Output File: `tidy_summary.txt`

One row per subject-activity combination. Each measurement column is the **average** of that measurement for that group.

- **Rows:** 180 (30 subjects × 6 activities)\
- **Columns:** 82

------------------------------------------------------------------------

## Identifier Columns

| Column | Type | Description |
|----|----|----|
| `subject_id` | Integer (1–30) | Unique participant identifier |
| `activity` | Factor | Activity performed: `WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING` |
| `source` | Character | Whether participant was in the `"test"` or `"train"` set |

------------------------------------------------------------------------

## Measurement Columns (79 columns)

All values are normalised and bounded within **[−1, 1]**.

### Naming convention

| Part               | Meaning                                            |
|--------------------|----------------------------------------------------|
| `t` / `f`          | Time domain / Frequency domain (FFT)               |
| `Body` / `Gravity` | Body motion / Gravity component                    |
| `Acc` / `Gyro`     | Accelerometer / Gyroscope                          |
| `Jerk`             | Rate of change of acceleration or angular velocity |
| `Mag`              | Magnitude (Euclidean norm across X, Y, Z)          |
| `mean()` / `std()` | Mean / Standard deviation                          |
| `meanFreq()`       | Weighted average of frequency components           |
| `-X`, `-Y`, `-Z`   | Axial direction                                    |

### Signals included

| Signal group                               | Axes    | Statistics          |
|--------------------------------------------|---------|---------------------|
| `tBodyAcc`                                 | X, Y, Z | mean, std           |
| `tBodyAccJerk`                             | X, Y, Z | mean, std           |
| `tBodyAccMag`, `tBodyAccJerkMag`           | —       | mean, std           |
| `tGravityAcc`                              | X, Y, Z | mean, std           |
| `tGravityAccMag`                           | —       | mean, std           |
| `tBodyGyro`                                | X, Y, Z | mean, std           |
| `tBodyGyroJerk`                            | X, Y, Z | mean, std           |
| `tBodyGyroMag`, `tBodyGyroJerkMag`         | —       | mean, std           |
| `fBodyAcc`                                 | X, Y, Z | mean, std, meanFreq |
| `fBodyAccJerk`                             | X, Y, Z | mean, std, meanFreq |
| `fBodyAccMag`, `fBodyBodyAccJerkMag`       | —       | mean, std, meanFreq |
| `fBodyGyro`                                | X, Y, Z | mean, std, meanFreq |
| `fBodyBodyGyroMag`, `fBodyBodyGyroJerkMag` | —       | mean, std, meanFreq |

------------------------------------------------------------------------

## Transformations Applied

1.  Feature names from `features.txt` applied as column names to measurement files
2.  Subject IDs, activity IDs, and measurements combined with `bind_cols()` for each set
3.  Test and train datasets combined with `bind_rows()`
4.  Numeric activity IDs replaced with descriptive names from `activity_labels.txt`
5.  Only `mean` and `std` columns retained using `grepl()`
6.  Means computed per subject and activity using `group_by()` and `summarise(across(...))`
