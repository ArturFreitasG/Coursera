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

# I will consider motor vehicle sources as being of "ON-ROAD" type.
# I tried filtering NEI$SCC by "motor" using the same approach adopted in plot4.
# However, the results were too confusing and returned non-vehicle observations.

# filtering Baltimore and LA data, as well as "on-road" type. Agreggating by year
baltimore_la_by_year <- NEI %>%
  filter(fips %in% c("24510", "06037"), type == c("ON-ROAD")) %>%
  group_by(fips, year) %>% 
  summarize(total_emissions = sum(Emissions))

# plot 6
labels <- c("24510" = "Baltimore City", "06037" = "Los Angeles County")

plot6 <- ggplot(baltimore_la_by_year, aes(factor(year), total_emissions)) + 
  facet_grid(. ~ fips, labeller = labeller(fips = labels)) +
  geom_bar(stat="identity") +
  ggtitle("Total emissions in Baltimore and Los Angeles (1999 - 2008)") +
  xlab("Year") +
  ylab("PM2.5 emissions")

print(plot6)

# saving plot 6 into .png file
dev.copy(png,paste0(week4_dir, "/plot6.png"))
dev.off()