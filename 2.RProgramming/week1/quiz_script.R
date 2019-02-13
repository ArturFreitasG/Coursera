# check if course's week 1 directory exists. If not, create it.
if(!file.exists("./2.RProgramming")){dir.create("./2.RProgramming")}
if(!file.exists("./2.RProgramming/week1")){dir.create("./2.RProgramming/week4")}

# week 1 directory
week1_dir <- "./2.RProgramming/week1"

# file's url
url <- "https://d396qusza40orc.cloudfront.net/rprog/data/quiz1_data.zip"

# destination file
destfile <- paste0(week1_dir, "/Data for Peer Assessment.zip")

# download file. "libcurl" method selected, as it is running on Windows.
download.file(url, destfile, method = "libcurl")

# unzip file
unzip(destfile, exdir = week1_dir)

# cleaning memory
rm(destfile, url)

# loading libraries
library(readr)

# reading file
data <- read_csv(paste0(week1_dir, "/hw1_data.csv"))

# Question 11
## In the dataset provided for this Quiz, what are the column names of the dataset?
names(data)

# Question 12
## Extract the first 2 rows of the data frame and print them to the console.
## What does the output look like?
head(data, n = 2)

# Question 13
## How many observations (i.e. rows) are in this data frame?
nrow(data)

# Question 14
## Extract the last 2 rows of the data frame and print them to the console.
## What does the output look like?
tail(data, n = 2)

# Question 15
## What is the value of Ozone in the 47th row?
data[47, ]

# Question 16
## How many missing values are in the Ozone column of this data frame?
sum(is.na(data$Ozone))

# Question 17
## What is the mean of the Ozone column in this dataset?
## Exclude missing values (coded as NA) from this calculation.
mean(data$Ozone, na.rm = TRUE)

# Question 18
## Extract the subset of rows of the data frame where Ozone values are above 31 and Temp values are
## above 90. What is the mean of Solar.R in this subset?
subset18 <- data$Ozone > 31 & data$Temp > 90
data_subset <- data[subset18, ]
mean(data_subset$Solar.R, na.rm = TRUE)
rm(subset18, data_subset)

# Question 19
## What is the mean of "Temp" when "Month" is equal to 6?
subset19 <- data$Month == 6
data_subset <- data[subset19, ]
mean(data_subset$Temp)
rm(subset19, data_subset)

# Question 20
## What was the maximum ozone value in the month of May (i.e. Month is equal to 5)?
subset20 <- data$Month == 5
data_subset <- data[subset20, ]
max(data_subset$Ozone, na.rm = TRUE)
rm(subset20, data_subset)