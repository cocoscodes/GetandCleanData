# Raw and process data ----
# 1.- Raw data
# 2.- Tidy data sets
# 3.- code book - (metadata) describes each variable and value in the tidy data set
# 4.- instruction list - steps mapping (how you got from A to B), add any other programming languages code also

# Tidy data shouls have - one table per element, each variable in one column, 
#each observation in one row, row 1 should have human readable names, 
#foreign keys to loink tables, and one file per table

# Downloading files ----
getwd()
setwd()

# relative path
setwd("/Getting_and_Cleaning_Data")
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
download.file(fileUrl,destfile = "/Users/alejandrosolis/Desktop/Data_Sc/R/GetandCleanData/cameras.csv", method = "curl")
list.files("/Users/alejandrosolis/Desktop/Data_Sc/R/GetandCleanData")
DateDownloaded <- date()# datasets change so keep track on when you downloaded

cameras <- read.csv(fileUrl) # getting an error which this fixes
write.csv(cameras,"cameras.csv") # saves a dataframe to a csv file

# Reading local data ----
read.table()
read.csv()
read.csv2()

cameraData <- read.table("./cameras.csv",sep = ",",header = TRUE)
head(cameraData)

# Read excel files ----
getwd()
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD&bom=true&format=true&delimiter=;"
download.file(fileUrl,destfile = "/Users/alejandrosolis/Desktop/Data_Sc/R/GetandCleanData/cameras.xlsx", method = "curl")
list.files("/Users/alejandrosolis/Desktop/Data_Sc/R/GetandCleanData")
DateDownloadedxlsx <- date()

install.packages("XLConnect")
install.packages("rJava")
install.packages("xlsx") # this packages is not working in mac
library(XLConnectJars)
library(rJava)
library(xlsx)

# Read XML files ----
# Extensible markup languange - https://www.w3schools.com/xml/simple.xml
install.packages("XML")
library(XML)
library(RCurl)

fileUrl <- "https://www.w3schools.com/xml/simple.xml"
r = getURL(fileUrl)
doc <- xmlTreeParse(r, useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode[[1]] # subsetting is possible
rootNode[[1]][[1]]

xmlSApply(rootNode,xmlValue) # extract parts of the file

# XPath languange
xpathSApply(rootNode,"//name",xmlValue)
xpathSApply(rootNode,"//price",xmlValue)

fileUrl <- "https://www.espn.com/nfl/team/_/name/bal/baltimore-ravens"
r = getURL(fileUrl)
doc <- htmlTreeParse(r,useInternalNodes = TRUE)
scores <- xpathSApply(doc,"//div[@class='score']",xmlValue) # extracting values from the XML doc
teams <- xpathSApply(doc,"//div[@class='game-info']",xmlValue)# need to write in XPath languague
scores
teams

# Reading JSON file ----
# Javascript object notation - https://api.github.com/users/jtleek/repos
library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
names(jsonData$owner)
names(jsonData$owner$login)

# writting data to JSON
myjson <- toJSON(iris,pretty = TRUE)
cat(myjson)  

iris2 <- fromJSON(myjson) # turn it into a data frama with fromJSON
head(iris2)  

# Using data.table packages ----
install.packages("data.table")
library(data.table)  
?getDTthreads

DF = data.frame(x=rnorm(9),y=rep(c("a","b","c"),3),z=rnorm(9))  
head(DF,3)  

DT = data.table(x=rnorm(9),y=rep(c("a","b","c"),3),z=rnorm(9))  
head(DT,3)  # same result as above

tables() # see all data tables in memory
DT[2,]
DT[DT$y =="a",]
DT[c(2,3)] # without comma, only picks rows, it does not work with columns

DT[,list(mean(x),sum(z))] # passing a list of functions for each column
DT[,table(y)] # presenting a column in a table form

DT[,w:=z^2] # adding a new column using the := operator
DT

DT[,m:={tmp <- (x+z);log2(tmp+5)}] # adding a new column by using multiple operations, separate the expressions by ;
DT

DT[,a:=x>0] # binary variables, plyr like operations
DT

DT[,b:=mean(x+w),by=a] # variable groupe by another column
DT

set.seed(123);
DT<-data.table(x=sample(letters[1:3],1E5,TRUE))
DT[,.N,by=x] # .N allows you to count the number of each letter appear, group by the x variable

DT <- data.table(x=rep(c("a","b","c"),100),y=rnorm(300))
setkey(DT,x) # setting keys for quick subsetting
DT['a']

DT1 <- data.table(x=c("a","a","b","dt1"),y=1:4)
DT2 <- data.table(x=c("a","b","dt2"),z=5:7)
setkey(DT1,x); setkey(DT2,x)
merge(DT1,DT2)  

big_df <- data.frame(x=rnorm(1E6),y=rnorm(1E6))  
file <- tempfile()  
write.table(big_df,file=file,row.names = FALSE,
            col.names = TRUE,sep = "\t",quote = FALSE)  
system.time(fread(file))  # faster method to read a file
system.time(read.table(file,header = TRUE,sep = "\t")) # way slower elapsed time

# Week 1 quiz ----
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,destfile = "/Users/alejandrosolis/Desktop/Data_Sc/R/GetandCleanData/idahoSurvey.csv", method = "curl")
idaho_survey <- read.csv("idahoSurvey.csv")
head(idaho_survey,3)
summary(idaho_survey$VAL>=24)

dat <- read.table("getdata_data_DATA.gov_NGAP.xlsx")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
r = getURL(fileUrl)
doc <- htmlTreeParse(r, useInternalNodes = TRUE)
zipcode <- xpathSApply(doc,"//zipcode",xmlValue)
summary(zipcode[zipcode=="21231"])

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl,destfile = "/Users/alejandrosolis/Desktop/Data_Sc/R/GetandCleanData/idahoSurvey.csv", method = "curl")
DT <- fread("idahoSurvey.csv")
system.time(DT[,mean(pwgtp15),by=SEX])

# Reading from MySQL ----
install.packages("RMySQL")
library(RMySQL)
# connecting and listing databases
ucscDb <- dbConnect(MySQL(),user="genome",
                    host="genome-euro-mysql.soe.ucsc.edu") # connect to the database server
result <- dbGetQuery(ucscDb,"show databases;"); dbDisconnect(ucscDb); # get a query, ALWAYS disconnect when finish the query
result

hg19 <- dbConnect(MySQL(),
                  user="genome",db="hg19", # connect ot the specific DB
                  host="genome-euro-mysql.soe.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]
dbListFields(hg19,"affyU133Plus2") # columns are just like fields
dbGetQuery(hg19,"select count(*) from affyU133Plus2") # counted the rows
affyData <- dbReadTable(hg19,"affyU133Plus2") # read from table
head(affyData)

query <- dbSendQuery(hg19,"select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches) # using semicolon ; helps adding function to the data
affyMisSmall <- fetch(query,n=10); dbClearResult(query); # fetching a subset of the table, and clear the query in the server
dim(affyMisSmall)
dbDisconnect(hg19) # ALWAYS close your connection after yo have extracted the data
# NOTE, try ONLY to use the SELECT command on this packages, you could delete or modify some elses data

# Reading HDF5 ----
# heirarchical data format¡
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install()
BiocManager::available()
BiocManager::install("rhdf5")
library(rhdf5)

created = h5createFile("example.h5")
created
# create groups within the file
created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
created = h5createGroup("example.h5","foo/foobaa")
h5ls("example.h5")
# write to groups
A = matrix(1:10,nr=5,nc=2)
h5write(A, "example.h5","foo/A")
B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5","foo/B")
h5ls("example.h5")
# write a data set
df = data.frame(1L:5L,seq(0,1,length.out = 5),
                c("ab","cde","fghi","a","s"),stringsAsFactors = FALSE)
h5write(df,"example.h5","df")
h5ls("example.h5")
# Read data
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/B")
readdf = h5read("example.h5","df")
readA
# writting and reading chunks
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1)) # first three rows of the first column
h5read("example.h5","foo/A")

# Reading data from the web ----
# getting data from webpages
con = url("https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en") # open a connection
htmlCode = readLines(con) # read data from connection
close(con) # close the connection
htmlCode # code with no structure

# NOTE parse it with XML one way to improve readability and data extraction
url <- "https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
r <- getURL(url)
html <- htmlTreeParse(r,useInternalNodes = TRUE)

xpathSApply(html,"//title",xmlValue)
xpathSApply(html,"//td[@id='col-citedby']",xmlValue)

# GET from the httr package
library(httr)
html2 = GET(url)
content2 = content(html2,as="text") # extracting content from html page
parsedHTML = htmlParse(content2,asText = TRUE)

xpathSApply(parsedHTML,"//title",xmlValue)

# Accessing webpages with password
pg1 = GET("http://httpbin.org/basic-auth/user/passwd")
pg1 # you get status 401 cause it needs password to log in
# authenticate yourself
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user","passwd"))
pg2 # status 200 we have gain access
names(pg2)

# using handles to authenticate over multiple websites
google = handle("http://google.com") # this is the handle, when you authenticate the handle you can access the website cause the cookies will stay in the website
pg1 = GET(handle = google,path="/")
pg2 = GET(handle = google,path="search")
















