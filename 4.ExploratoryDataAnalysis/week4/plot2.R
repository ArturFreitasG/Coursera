# check if course's week 4 directory exists. If not, create it.
if(!file.exists("./Coursera")){dir.create("./Coursera")}
if(!file.exists("./Coursera/4.ExploratoryDataAnalysis")){dir.create("./Coursera/4.ExploratoryDataAnalysis")}
if(!file.exists("./Coursera/4.ExploratoryDataAnalysis/week4")){dir.create("./Coursera/4.ExploratoryDataAnalysis/week4")}

# week 4 directory
week4_dir <- "./Coursera/4.ExploratoryDataAnalysis/week4"

# file's url
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# destination file
destfile <- paste0(week4_dir, "/Data for Peer Assessment.zip")

# download file. "libcurl" method selected, as it is running on Windows.
download.file(url, destfile, method = "libcurl")

# unzip file
unzip(destfile, exdir = week4_dir)

# loading required libraries
library(dplyr)

# reading files
NEI <- readRDS(paste0(week4_dir, "/summarySCC_PM25.rds"))
SCC <- readRDS(paste0(week4_dir, "/Source_Classification_Code.rds"))

# filtering Baltimore data and agreggating by year
baltimore_by_year <- NEI %>%
                 filter(fips=="24510") %>%
                 group_by(year) %>% 
                 summarize(total_emissions = sum(Emissions))

# plot 2
with(baltimore_by_year, barplot(height = total_emissions,
                            names.arg = year, 
                            ylab="PM2.5 emissions",
                            main="Total PM2.5 emissions in Baltimore per year"))

# saving plot 2 into .png file
dev.copy(png,paste0(week4_dir, "/plot2.png"))
dev.off()