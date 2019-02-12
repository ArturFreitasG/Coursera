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
library(ggplot2)

# reading files
NEI <- readRDS(paste0(week4_dir, "/summarySCC_PM25.rds"))
SCC <- readRDS(paste0(week4_dir, "/Source_Classification_Code.rds"))

# merging NEI and SCC. Removing original datasets from environment to save memory.
NEI_SCC <- merge(NEI, SCC, by = "SCC")
rm(NEI, SCC)

# filtering SCC coal sources. Removing NEI_SCC from environment to save memory.
coal_sources <- grepl("coal", NEI_SCC$Short.Name, ignore.case = TRUE)
subset_coal <- NEI_SCC[coal_sources, ]
rm(NEI_SCC)

# agreggating by year
total_by_year <- subset_coal %>%
                 group_by(year) %>% 
                 summarize(total_emissions = sum(Emissions))

# plot 4
with(total_by_year, barplot(height = total_emissions,
                            names.arg = year, 
                            ylab="PM2.5 emissions",
                            main="Total PM2.5 emissions from coal sources per year"))

# saving plot 4 into .png file
dev.copy(png,paste0(week4_dir, "/plot4.png"))
dev.off()