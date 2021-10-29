# Getting and Cleaning Data Assignment
This README file describes the analysis made in the R-script "run_analysis.R". 

## 0. Packages
run_analysis.R uses the following packages, all available via CRAN:
- data.table: for performance reasons I use data.table and associated functions to process the data set
- dplyr: part of the tidyverse, includes the %>% operator that makes data transformation neat and clear

## 1. Download and unzip
The script downloads the zip-file from the URL indicated in the assignment and unzips the content into the working directory

## 2. Data loading and transformation
I use fread() to load the txt-files into data.table objects and combine the test and train data sets with the command funion().

When loading subject_\*.txt, y_\*.txt, I manually set the col.names attribute. However, before reading the content of X_\*.txt, I read the variable names from feature.txt and use those as variable names. I then use select() from dplyr together with the contains() selection helper to extract measurements on the mean and standard deviation for each measurement. I also drop the brackets "()" in the variable names. 

Finally, I also read the contents of activity_labels.txt and save it in y_label.

## 3. Combine --> tidy
I then combine the three data.tables subject, y and X by using the cbind() function. Also, I make an inner join with y_label, in order to have descriptive variable names.

NB: It is crucial to first combine subject, y and X and only afterwords do the join, because the join changes the ordering!

## 4. Create new data set --> tidySmall
I group the tidy data set by subjectId and activity and summarise all other variables applying the mean() function.


