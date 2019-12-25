# Raw and process data ----
# 1.- Raw data
# 2.- Tidy data sets
# 3.- code book - (metadata) describes each variable and value in the tidy data set
# 4.- instruction list - steps mapping (how you got from A to B), add any other programming languages code also

# Tidy data shouls have - one talbe per element, each variable in one column, 
#each observation in one row, row 1 should have human readable names, 
#foreign keys to loink tables, and one file per table

# Downloading files ----
getwd()
setwd()

# relative path
setwd("./Getting_and_Cleaning_Data")
# absolute path
setwd("/Users/alejandrosolis/Desktop/Data_Sc/R/Getting_and_Cleaning_Data")

# checking for and creating directories
file.exists()
dir.create()

if(!file.exists("GetandCleanData")){ # check and create
  dir.create("GetandCleanData")
}

# getting data forom the internet
download.file()

fileUrl <- "http://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile = "./GetandCleanData/cameras.csv", method = "curl")
list.files("./GetandCleanData")
DateDownloaded <- date()# datasets change so keep track on when you downloaded

cameras <- read.csv(fileUrl) # getting an error which this fixes
write.csv(cameras,"cameras.csv") # saves a dataframe to a csv file


