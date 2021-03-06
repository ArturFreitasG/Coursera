# check if course's week 1 directory exists. If not, create it.
if(!file.exists("./Coursera")){dir.create("./Coursera")}
if(!file.exists("./Coursera/4.ExploratoryDataAnalysis")){dir.create("./Coursera/4.ExploratoryDataAnalysis")}
if(!file.exists("./Coursera/4.ExploratoryDataAnalysis/week1")){dir.create("./Coursera/4.ExploratoryDataAnalysis/week1")}

# week 1 directory
week1_dir <- "./Coursera/4.ExploratoryDataAnalysis/week1"

# file's url
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# destination file
destfile <- paste0(week1_dir, "/Electric power consumption.zip")

# download file. "libcurl" method selected, as it is running on Windows.
download.file(url, destfile, method = "libcurl")

# unzip file
unzip(destfile, exdir = week1_dir)

# loading required libraries
library(dplyr)

# reading file
dataset_week1 <- read.table(paste0(week1_dir, "/household_power_consumption.txt"),
                            header = TRUE,
                            sep = ";",
                            stringsAsFactors = FALSE,
                            na.strings = "?")

# merging and converting "Date" and "time columns into a single "DateTime" column
dataset_week1 <- dataset_week1 %>%
  mutate(DateTime = as.POSIXct(paste(Date, Time), format ="%d/%m/%Y %H:%M:%S")) %>%
  filter(DateTime >= "2007-02-01" & DateTime < "2007-02-03") %>%
  select(DateTime, Global_active_power:Sub_metering_3)

# plot 3
with(dataset_week1, plot(DateTime,
                         Sub_metering_1,
                         type = "l",
                         col = "black",
                         xlab = "",
                         ylab = "Energy sub metering"))

with(dataset_week1, lines(DateTime,
                          Sub_metering_2,
                          type = "l",
                          col = "red"))

with(dataset_week1, lines(DateTime,
                          Sub_metering_3,
                          type = "l",
                          col = "blue"))

legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1)

# saving plot 3 into .png file
dev.copy(png,paste0(week1_dir, "/plot3.png"))
dev.off()