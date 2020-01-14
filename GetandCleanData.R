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

# getting data from the internet
download.file()

fileUrl <- "http://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile = "/Users/alejandrosolis/Desktop/Data_Sc/R/GetandCleanData/cameras.csv", method = "curl")
list.files("/Users/alejandrosolis/Desktop/Data_Sc/R/GetandCleanData")
DateDownloaded <- date()# datasets change so keep track on when you downloaded

# OR
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
# heirarchical data format
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

# Read data from APIs ----
# application programming interfaces

# you will first need to create an application on each webpage in the developers interface
library(httr)

myapp = oauth_app("twitter",key = "your consumer key here", # authorization pathway
                  secret = "your consumer secret here")

sig = sign_oauth1.0(myapp,token = "your token here", # sign in
                    token_secret = "your token secret here")

homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json",sig) 
# GET command and the URL that refers to the API, very specific URL, look into the documentation of the API to know the URL
# converting the json object
json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1)) # the :: activates a package jsonlite
# taking the R object back to json
json2[1.1:4]

#httr allows GET, POST, PUT, and DELETE request if you are authorize

# Reading from ohter sources ----
# usuallythere is an R package for data search of everything
# use the file, url, gzfile (zip files), and bzfile commands, ?connections
# remember to close connections
install.packages("foreign") # serves to interact with other types of programming lnaguages
# others: PostgresSQL, RMongo, RODBC
# reading images with jpeg, readbitmap, png, EBImage(bioconductor)
# reading GIS data (geographic) rdgal, rgeos, raster
# read music data with tuneR, and seewave

# Week 2 quiz ----
library(httr)
install.packages("httpuv")
library(httpuv)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "b543748f2d7ae4e451a5",
                   secret = "6761961e9d7de2626d415362ee0b5017e146f402"
)

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp) # to get credentials you need package httpuv

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
json1 = content(req)
json2 = jsonlite::fromJSON(jsonlite::toJSON(json1))
json2[json2$full_name == "jtleek/datasharing", "created_at"] 

# OR:
req <- with_config(gtoken, GET("https://api.github.com/users/jtleek/repos"))
stop_for_status(req)
content(req)

# question 2
install.packages("sqldf")
library(sqldf) # this package will help simulate the dbSendQuery in RMySQL

acs <- read.csv("getdata_data_ss06pid.csv",header = TRUE)

result <- sqldf("select pwgtp1 from acs where AGEP < 50") # very important to detached RMySQL package to make it work
head(result)

# question 3
unique(acs$AGEP)
result1 <- sqldf("select distinct AGEP from acs")
result1 == unique(acs$AGEP)

# question 4
con = url("http://biostat.jhsph.edu/~jleek/contact.html") # open a connection
htmlCode = readLines(con) # read data from connection
close(con) # close the connection
htmlCode # code with no structure
c(nchar(htmlCode[10]), nchar(htmlCode[20]), nchar(htmlCode[30]), nchar(htmlCode[100]))
# obtain the result in 1 vector c()

# question 5
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
htmlCode <- readLines(url, n = 10)
data <- read.fwf(url,c(1, 9, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3),
                 header = FALSE,
                 skip = 4)# (Hint this is a fixed width file format)
str(data)
tail(data)
sum(data[,8]) # the fourth column is actually the eight element of the fix width format

# Subsetting and sorting ----
set.seed(13435)
x <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
x <- x[sample(1:5),]; x$var2[c(1,3)] = NA
x
x[,1]
x[,"var1"]
x[1:2,"var2"]
x[x$var1<=3 & x$var3>11,]
x[x$var1<=3 | x$var3>15,]
x[which(x$var2>8),] # which command will eliminate the NA

sort(x$var1)
sort(x$var1,decreasing = TRUE) 
sort(x$var2,na.last = TRUE)

x[order(x$var1),] # order works in data frames not just columns
x[order(x$var1,x$var3),]

library(plyr)
arrange(x,var1)
arrange(x,desc(var1))

# adding columns
x$var4 <- rnorm(5)
x

y <- cbind(x,rnorm(5))
y

# Summarizing data ----
getwd()
if(!file.exists("./rest")){dir.create("./rest")}
setwd("./rest")
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD&bom=true&format=true&delimiter=%3B"
download.file(fileUrl,destfile = "/Users/alejandrosolis/Desktop/Data_Sc/R/GetandCleanData/rest/Restaurants.csv", method = "curl")
restData <- read.csv("Restaurants.csv", header = TRUE,sep = ";")

head(restData)
str(restData)
summary(restData)
quantile(restData$councilDistrict,na.rm = TRUE)
quantile(restData$councilDistrict,probs = c(0.5,0.75,0.9))
table(restData$zipCode,useNA = "ifany")# useNA to count the missing values
table(restData$councilDistrict,restData$zipCode) # 2 dimensional tables
sum(is.na(restData$councilDistrict)) # sum the NA
any(is.na(restData$councilDistrict)) # is there any NA
all(restData$zipCode>0) # does avery single value satisfy this condition
colSums(is.na(restData)) # sum the NAs of every column
any(colSums(is.na(restData))==0) # are there no missing values
table(restData$zipCode %in% c("21212")) # search for specific values
table(restData$zipCode %in% c("21212","21213"))
restData[restData$zipCode %in% c("21212","21213"),] # subsetting a dataset with a variable

data("UCBAdmissions")
DF <- as.data.frame(UCBAdmissions)
summary(DF)
# Cross tabs
xt <- xtabs(Freq ~ Gender + Admit, data = DF) # first variable is displayed, brokendown to gender and admitted
xt
# Flat tables
warpbreaks$replicate <- rep(1:9,len=54)
xt = xtabs(breaks ~.,data = warpbreaks) # breaks for all variables
xt
ftable(xt) # create the table
# Size of data
fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData),units = "Mb")

# Creating new variables ----
# common variables to create: missing indicators, cutting up quatitative variables, and applying transform
# creating sequences to index your data
s1 <- seq(1,10,by=2); s1 # by adding two values
s2 <- seq(1,10,length=3); s2 # lenght of the list
x <- c(1,3,8,25,100); seq(along=x) # create an index the length of the number of values
# logical operation that determines if they are near me
restData$nearMe <- restData$neighborhood %in% c("Roland Park","Homeland")
table(restData$nearMe)
# create binary variables
restData$zipWrong <- ifelse(restData$zipCode<0,TRUE,FALSE)
table(restData$zipWrong,restData$zipCode<0)
# creating categorical variables
restData$zipGroups <- cut(restData$zipCode,breaks = quantile(restData$zipCode))
table(restData$zipGroups)
table(restData$zipGroups,restData$zipCode)

install.packages("Hmisc")
library(Hmisc)
restData$zipGroups <- cut2(restData$zipCode,g=4) # easier cutting, g equal to quantiles
table(restData$zipGroups)
# creating factor variables
restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]
class(restData$zcf)
# levels of factor varialbes
yesno <- sample(c("yes","no"),size = 10,replace = TRUE)
yesnofac <- factor(yesno, levels = c("yes","no"))
relevel(yesnofac,ref = "yes")
as.numeric(yesnofac)

library(plyr)
restData2 = mutate(restData, zipGroups=cut2(zipCode,g=4)) # using mutate to create a new variable
table(restData2$zipGroups)
# common transforms
x <- 3.475
abs(x)
sqrt(x)
ceiling(x)
floor(x)
round(x,digits = 2)
signif(x,digits = 2)
cos(x)
sin(x)
log(x)
log2(x)
log10(x)
exp(x)
  
# Reshaping data ----
library(reshape2)
head(mtcars)  
# Melt data frames
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars,id=c("carname","gear","cyl"),measure.vars=c("mpg","hp"))  
# melt will display the DF with the id columns and melt the others in one column
head(carMelt,n=3)  
tail(carMelt,n=3)
# Casting data frames
cylData <- dcast(carMelt,cyl~variable) # casting a summarized data set sum of variables
cylData  
cylData <- dcast(carMelt,cyl~variable,mean) # casting the mean of the variables
cylData

head(InsectSprays)
tapply(InsectSprays$count,InsectSprays$spray,sum)
# another way to split and apply
spIns <- split(InsectSprays$count,InsectSprays$spray)
spIns
sprCount <- lapply(spIns,sum)
sprCount # we dont want lists so we turn into vector
unlist(sprCount)
sapply(spIns,sum)# remember that sapply always simplifies the data structure
# another way
library(plyr)
ddply(InsectSprays,.(spray)# .() to avoid using ""
      ,summarize,sum=sum(count))

spraysums <- ddply(InsectSprays,.(spray),summarize,sum=ave(count,FUN = sum))
dim(spraysums)
head(spraysums)

# another functions to be aware of
acast() # multi-dimensional array
arrange() # faster than order()
mutate() # add new variables

# Managing data frames with dplyr ----
# NOTE: some function might be masked by other packages
library(dplyr) # optimized and destilled version of plyr
select() # returns a subset of the columns
filter() # extracts a subset of the rows based on logical conditions
arrange() # reorder rows of the DF
rename() # rename varialbes
mutate() # add or transform variables
summarise() # generates a summary stastistics different variables 

# Managin data with dplyr basic tools ----
chicago <- readRDS("chicago")
dim(chicago)
names(chicago)

head(select(chicago, city:dptp)) # view all columns from city to dptp
head(select(chicago, -(city:dptp))) # view all columns except those mentioned

chic.f <- filter(chicago,pm25tmean2 >30) # createsa subset
head(chic.f,10)
chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
head(chic.f)

chicago <- arrange(chicago,date) # arrange by date
head(chicago)
tail(chicago)
chicago <- arrange(chicago,desc(date)) # descending
head(chicago)

chicago <- rename(chicago,pm25=pm25tmean2,dewpoint=dptp)
head(chicago)

chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(select(chicago,pm25,pm25detrend))
chicago <- mutate(chicago,tempcat=factor(1*(tmpd>80),labels = c("cold","hot")))
tail(chicago)
hotcold <- group_by(chicago,tempcat)
hotcold
summarise(hotcold,pm25=mean(pm25),o3=max(o3tmean2),no2=median(no2tmean2))
summarise(hotcold,pm25=mean(pm25,na.rm = TRUE),o3=max(o3tmean2),
          no2=median(no2tmean2))
chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
years <- group_by(chicago,year)
summarise(years,pm25=mean(pm25,na.rm = TRUE),o3=max(o3tmean2),
          no2=median(no2tmean2))
# pipeline operator %>% runs the data to a series of command to obtain a new dataset
chicago %>% 
  mutate(month = as.POSIXlt(date)$mon + 1) %>%
  group_by(month) %>%
  summarize(pm25 = mean(pm25, na.rm = TRUE),
            o3 = max(o3tmean2, na.rm = TRUE),
            no2 = median(no2tmean2, na.rm = TRUE))

# Merging data ----

if(!file.exists("./peer")){dir.create("./peer")}
fileUrl1 <- "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 <- "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1,destfile = "./peer/reviews.csv",method = "curl")
download.file(fileUrl2,destfile = "./peer/solutions.csv",method = "curl")
getwd()
setwd("./peer")
reviews = read.csv("reviews.csv")
solutions = read.csv("solutions.csv")
head(reviews,2)
head(solutions,2)
names(reviews)
names(solutions)

mergeData = merge(reviews,solutions,by.x = "solution_id",by.y = "id",all = TRUE)
head(mergeData)

intersect(names(solutions),names(reviews)) # merge all common column names
mergeData2 = merge(reviews,solutions,all = TRUE)
head(mergeData2)

library(plyr) # using the join command
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
arrange(join(df1,df2),id) # join by id

df3 = data.frame(id=sample(1:10),z=rnorm(10))
dfList = list(df1,df2,df3)
join_all(dfList) # join_all to merge multiple datsets (more than 2)

# Week 3 quiz ----
# question 1
if(!file.exists("./qz3")){dir.create("./qz3")}
getwd()
setwd("./qz3")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,destfile = "communities.csv", method = "curl" ) 
communities <- read.csv("communities.csv")
str(communities)
summary(communities$ACR)
agricultureLogical <- c(communities$ACR == 3 & communities$AGS == 6)
which(agricultureLogical)

# question 2
library(jpeg)
fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileUrl1,destfile = "jeff.jpeg", method = "curl")
quantile(readJPEG("jeff.jpeg",native = TRUE),probs = c(0.3,0.8))

# question 3
library(data.table)
fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl2, destfile = "GDP.csv", method = "curl")
GDP <- fread("./GDP.csv", skip = 5, nrows = 190, select = c(1, 2, 4, 5), 
             col.names = c("CountryCode", "Rank", "Economy", "Total"))
str(GDP)

fileUrl3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl3,destfile = "edu.csv", method = "curl")
edu <- fread("./edu.csv")
str(edu)

matches <- merge(GDP,edu, by="CountryCode")
str(matches)
head(arrange(matches[,1:3],desc(Rank)),15)

# question 4
names(matches)
matches$`Income Group`
OECD <- filter(matches, `Income Group`=="High income: OECD")
nonOECD <- filter(matches, `Income Group`=="High income: nonOECD")

mean(OECD$Rank)
mean(nonOECD$Rank)

# question 5
quantile(matches$Rank)
matches %>% 
  arrange(desc(Rank)) %>%
  select(CountryCode:`Income Group`) %>%
  filter(Rank <= 38 & `Income Group`=="Lower middle income") %>%
  print

# Editing text variables ----
getwd()
setwd("/Users/alejandrosolis/Desktop/Data_Sc/R/GetandCleanData")
cameraData <- read.csv("cameras.csv")
names(cameraData)
tolower(names(cameraData)) # made all letters lower case
toupper(names(cameraData)) # made all letters upper case

splitNames <- strsplit(names(cameraData),"\\.") # taking the period from the heading
splitNames[[5]]
splitNames[[6]]

mylist <- list(letters = c("A","b","c"),number = 1:3, matrix(1:25,ncol = 5))
mylist
mylist[1]
mylist[[1]]
mylist[[1]][1]

splitNames[[6]][1]

firstElement <- function(x){x[1]}
sapply(splitNames,firstElement)

head(reviews,2)
head(solutions,2)
sub("_","",names(reviews)) # replacing underscore _ for ""

testName <- "this_is_a_test"
sub("_","",testName) # only affects the first element
gsub("_","",testName) # changes all the characters

grep("Alameda",cameraData$intersection) # find all the intersections that contained a string
table(grepl("Alameda",cameraData$intersection)) # returns logicals for grep

cameraData2 <- cameraData[!grepl("Alameda",cameraData$intersection),] # subsetting using grepl

grep("Alameda",cameraData$intersection, value = TRUE) # return the value that matched
grep("JeffStreet",cameraData$intersection) # interger (0) no vaues found
length(grep("JeffStreet",cameraData$intersection))

library(stringr)
nchar("Alex Solis") # number of characters
substr("Alex Solis",1,4) # bring just some characters of a string start, stop
paste("Alex","Solis") # paste into one string, puts spaces in between words
paste0("Alex","Solis") # paste with no spaces
str_trim("Alex      ") # eliminates blanks

# best practices for text
# 1.- All lower case
# 2.- Descriptive when possible, no acronyms
# 3.- No duplicates
# 4.- Avoid dots, underscores, or white spaces
# 5.- Turn into factors when possible

# Regular expressions ----
# literals and metacharacters - they can be used with 
grep() 
grepl()
sub()
gsub()
str_extract()
str_replace()

# ^i think represents the beginning of a line
# morning$ represents the end of a line
# Character classes [Bb] [Uu] [Ss] [Hh] matching upper and lower versions of the letter
# combining metacharacters ^[Ii] am
# range of characters [a-z] [a-zA-Z] - ^[0-9][a-zA-Z] beginning of a line, all numbers from 0 to 9 and any character upper or lower case
# [^?.]$ anything that ends except periods and question marks the ^ functions here as NOT

# Regular expressions II ----

# dot means any characters - 9.11 find any line that has a 9follow by any character and then an 11
# | or - flood|fire it can be any number of alternatives
# ^[Gg]ood|[Bb]ad
# ^([Gg]ood|[Bb]ad) by adding parenthesis we apply the metacharacters to all the conditions
# [Gg]eorge( [ww]\.)? [Bb]ush - the qustion mark allows this to be optional, with backslash we tell it is literallly dot
# * mean repeated any times + means at least repeated once - (.*) find any characters, repeated any number of times
# [0-9]+ (.*)[0-9]+ find any numbers repeated at least once follow by any characters follow by numbers
# {} interval quantifiers, min and mac number of matches - [Bb]ush( +(^ )+ +){1,5} debate space at least once, something it is not an space at least once, follow by at least once space
# m,n within curly brackets minimum of m but not more the n
# m exactly m maches
# m, at least m matches
# matched text is referred as scaped numbers such as - \1, \2 - +([a-zA-Z]+) +\1 + 
# - the \1 refers to the previous expression, so to repeat, " night night "
# ^s(.*)s - the * symbol matches the longet string the matches the condition
# ^s(.*)s$ - with the dollar sign we limit the search for the longest string

# very goos to use with unfriendly formats and files

# Working with dates ----
d1 = date()
d1
class(d1) # character

d2 = Sys.Date()
d2
class(d2) # Date

format(d2, "%a %b %d")
# %d - day as number
# %a - abbreviated weekday
# %A - Unabbreviated weekday
# %m - month as number
# %b - abbreviated month
# %B - unabbraviated month
# %y - two digit year
# %Y - four digit year

x = c("1jan1960","2jan1960","31mar1960","30jul1960")
z = as.Date(x,"%d%b%Y")
z

z[1]-z[2] # showing time difference between dates
as.numeric(z[1]-z[2]) # only the numeric value of the the time difference

weekdays(d2)
months(d2)
julian(d2) # julian date returns the number of days since the origin - "1970-01-01

library(lubridate)
ymd("20200114") # returns a date in the order and format you have written
mdy("01/14/2020") # returns a date in the order and format you have written
dmy("14-01-2020") # returns a date in the order and format you have written

ymd_hms("2020-01-14 13:11:03")
ymd_hms("2020-01-14 13:11:03",tz="Europe/Berlin")
Sys.timezone() # if having trouble find the local timezone

x = dmy(c("1jan2020","2jan2020","31mar2020","30jul2020"))
wday(x[1])
wday(x[1],label = TRUE)

# Data resources ----
# UN data.un,org/
# US data.gov/ 
# UK data.gov.uk/
# France data.gouv.fr/
# Ghana data.giv.gh/
# Australia data.gov.au/
# Germany govdata.de/
# HK gov.hk/en/theme/psi/datasets/
# Japan data.go.jp/
# others data.gov/opendatasites
# Gapminder
# Us surveys asdfree.com/
# infochimps
# Kaggle




