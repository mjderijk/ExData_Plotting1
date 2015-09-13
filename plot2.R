## This R Script uses the base plotting system to examine how household energy usage varies 
## over a 2-day period in February, 2007

# store current working directory for later, and set the working directory
current_wd <- getwd()
setwd("~/Coursera/ExploratoryDataAnalysis/Project1/Repo/ExData_Plotting1")

# download the data (but only if it hasn't been downloaded yet!)
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("../data")) {dir.create("../data")}
if(!file.exists("../data/exdata-data-household_power_consumption.zip")) {
        download.file(fileUrl,destfile = "./../data/exdata-data-household_power_consumption.zip", mode = "wb")
}

# find out what the filename in the zipfile is, and if it doesn't exist, unzip it from the download.
setwd("./../data")
myFileData <- unzip("exdata-data-household_power_consumption.zip", list = TRUE)
myFileName <- myFileData$Name
if(!file.exists(myFileName)) {unzip("exdata-data-household_power_consumption.zip")}

# now we can read in our data. 
myData <- read.table(myFileName, header = TRUE, sep = ";", na.strings = "?", stringsAsFactors = FALSE)
# and finally set the working directory back to where our script is located...
setwd("../ExData_Plotting1")

# convert the Date field from string to Date
myData$Date <- as.Date(myData$Date, format = "%d/%m/%Y")
# use the dplyr package to subset our data, selecting Feb 1 & 2, 2007
library("dplyr")
myDataSubset <- filter(myData, Date=="2007-02-01" | Date=="2007-02-02")
# now take the Date and Time columns and combine to create a proper DateTime column
myDataSubset <- mutate(myDataSubset, DateTime = paste(Date,Time))
# finally use strptime to convert DateTime to POSIXlt
myDataSubset$DateTime <- strptime(myDataSubset$DateTime, "%Y-%m-%d %H:%M:%S")

# now create our plot: a histogram.
# first, open png device; create 'plot2.png' in the working directory
png(file = "plot2.png")
# create histogram and send to the file
plot(myDataSubset$DateTime, myDataSubset$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")# close the png file!
dev.off()

## still need to restore our working directory...

