## This R Script uses the base plotting system to examine how household energy usage varies 
## over a 2-day period in February, 2007. 

## store current working directory for later, and set the working directory
current_wd <- getwd()
setwd("~/Coursera/ExploratoryDataAnalysis/Project1/Repo/ExData_Plotting1")

## download the data (but only if it hasn't been downloaded yet!)
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("../data")) {dir.create("../data")}
if(!file.exists("../data/exdata-data-household_power_consumption.zip")) {
        download.file(fileUrl,destfile = "./../data/exdata-data-household_power_consumption.zip", mode = "wb")
}

## find out what the filename in the zipfile is, and if it doesn't exist, unzip it from the download.
setwd("./../data")
# note: unzipping with "list = TRUE" returns the filename(s) (and other data, so just get $Name)
myFileName <- unzip("exdata-data-household_power_consumption.zip", list = TRUE)$Name
# now we check for the unzipped file - if it doesn't yet exist, unzip the downloaded file.
if(!file.exists(myFileName)) {unzip("exdata-data-household_power_consumption.zip")}

# now we can read in the data. 
# to minimise the data that needs to be read, we're using a variation of a method 
# described by Chad Junkermeier, found at:
# https://class.coursera.org/exdata-032/forum/thread?thread_id=5#post-32

# first, read the header of our data
myHeader <- read.table(myFileName, header = TRUE, sep = ";", nrows = 1)
# create a grep expression (so that we can use the dynamically stored filename in 'myFileName')
grepExpression <- paste0("grep ", "\"^[1-2]/2/2007\"", " \"", myFileName, "\"")
myData <- read.table(pipe(grepExpression), sep = ";", na.strings = "?", stringsAsFactors = FALSE)
# copy the column names from myHeader to myData
names(myData) <- names(myHeader)
# and finally set the working directory back to where this script is located...
setwd("../ExData_Plotting1")

## now tidy the data to prepare it for creating plots
# first, convert the Date field from string to Date
myData$Date <- as.Date(myData$Date, format = "%d/%m/%Y")
# use the dplyr package to combine the Date and Time columns
library("dplyr")
myData <- mutate(myData, DateTime = paste(Date,Time))
# now use strptime to convert DateTime to POSIXlt
myData$DateTime <- strptime(myData$DateTime, "%Y-%m-%d %H:%M:%S")

## now create the required plot: a three-data set plot.
# first, open png device; create 'plot3.png' in the working directory
png(file = "plot3.png")

# create plot and send to the file
with(myData, {
        # first set up the plot so we can add multiple point sets to it, by setting the plot type = "n"
        plot(DateTime,Sub_metering_1, xlab = "", ylab = "Energy sub metering ", type = "n")
        # now add each point set: Sub_meter 1, 2 and 3:
        points(DateTime,Sub_metering_1, col = "black", type = "l")
        points(DateTime,Sub_metering_2, col = "red", type = "l")
        points(DateTime,Sub_metering_3, col = "blue", type = "l")
        # lastly, add the legend:
        legend("topright", lty = c(1,1,1), col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
} )
# now close the png device.
dev.off()

## finally, restore our working directory...
setwd(current_wd)
