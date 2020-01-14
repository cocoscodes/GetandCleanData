library(swirl)
ls()
rm(list = ls()) # this removes all elements from the workspace
install_from_swirl("Getting and Cleaning Data")
# Getting and cleaning data ----
swirl()

# Manipulating data with dplyr ----
mydf <- read.csv(path2csv,stringsAsFactors = FALSE)
dim(mydf)
head(mydf)
library(dplyr)
packageVersion("dplyr")

cran <- tbl_df(mydf) # creates a tibble
rm("mydf")
# dplyr supplies five 'verbs' that cover most fundamental data manipulation tasks: select(), filter(), arrange(), mutate(), and summarize().
?select # helps subsetting columns
select(cran, ip_id, package, country) # the function knows we are asking for columns and the order of them
select(cran, r_arch:country) # select a range of column from x to y
select(cran, country:r_arch) # reverse order
cran
select(cran, -time) # omits the time column
select(cran,-(X:size)) # omits a range

filter(cran, package == "swirl") # filter help subsetting rows
filter(cran, r_version == "3.1.1", country == "US") # add ore filters

?Comparison
filter(cran, r_version <= "3.0.2", country == "IN")
filter(cran, country == "US" | country == "IN") # OR
filter(cran,size>100500,r_os=="linux-gnu")
filter(cran, !is.na(r_version)) # delete NAs

cran2 <- select(cran,size:ip_id)
arrange(cran2, ip_id) # arrange rows, sorting
arrange(cran2, desc(ip_id)) # descending order
arrange(cran2, package, ip_id)
arrange(cran2,country,desc(r_version),ip_id)

cran3 <- select(cran,ip_id,package,size)
cran3
mutate(cran3, size_mb = size / 2^20)
mutate(cran3, size_mb = size / 2^20, size_gb = size_mb / 2^10)
mutate(cran3,correct_size=size+1000)

summarize(cran, avg_bytes =mean(size))
bye()

# Grouping and chaining data with dplyr ----
library(dplyr)
cran <- tbl_df(mydf)
rm("mydf")
cran # is a tibble
by_package <- group_by(cran,package) # this new tibble is grouped by package
summarize(by_package, mean(size))

pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))

quantile(pack_sum$count, probs = 0.99) # determine the value above the 99%
top_counts <- filter(pack_sum,count>679) # 1% of values
top_counts_sorted <- arrange(top_counts,desc(count)) 
View(top_counts_sorted)

quantile(pack_sum$unique, probs = 0.99)
top_unique <- filter(pack_sum,unique>465)
View(top_unique)
top_unique_sorted <- arrange(top_unique,desc(unique))
View(top_unique_sorted)
# chaining or piping
top_countries <- filter(pack_sum, countries > 60)
result1 <- arrange(top_countries, desc(countries), avg_bytes)

print(result1) # more ineficient way of creating your tibble

result2 <-
  arrange(
    filter(
      summarize(
        group_by(cran,
                 package
        ),
        count = n(),
        unique = n_distinct(ip_id),
        countries = n_distinct(country),
        avg_bytes = mean(size)
      ),
      countries > 60
    ),
    desc(countries),
    avg_bytes
  )
# Print result to console
print(result2) # clean but repetitive

result3 <-
  cran %>%
  group_by(package) %>%
  summarize(count = n(),
            unique = n_distinct(ip_id),
            countries = n_distinct(country),
            avg_bytes = mean(size)
  ) %>%
  filter(countries > 60) %>%
  arrange(desc(countries), avg_bytes)

# Print result to console
print(result3) # easiest way

# other chaining
cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size / 2^20) %>%
  filter(size_mb <= 0.5) %>%
  arrange(desc(size_mb)) %>%
  print

# Tidying Data with tidyr ----
library(dplyr)
library(readr)
library(tidyr)
students # data sets
?gather # this function has been retired, please use pivot_longer()
gather(students,sex,count,-grade) # all columns except grades, since grades is already a proper column

res <- gather(students2,sex_class,count,-grade)
res # need a second step to separate the sex_class
separate(res,sex_class,into = c("sex","class"))

# chain operation
students2 %>%
  gather(sex_class,count,-grade) %>%
  separate(sex_class,into = c("sex","class")) %>%
  print

students3 %>%
  gather(class, grade,class1:class5,na.rm = TRUE) %>% # after the value you can specify the column sequence class1:class5
  spread(test, grade) %>% 
  mutate(class = parse_number(class)) %>%
  print

student_info <- students4 %>%
  select(id, name, sex) %>%
  unique %>%
  print

gradebook <- students4 %>%
  select(id,class,midterm,final) %>% # we kepp id on both df to preserve a primary key
  print

passed
failed
passed <- passed %>% mutate(status = "passed")
failed <- failed %>% mutate(status = "failed")
bind_rows(passed,failed)

sat
sat %>%
  select(-contains("total")) %>% # -contains() eliminaes columns with an specific element
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  group_by(part,sex) %>%
  mutate(total = sum(count),
         prop = count / total) %>% 
  print

# Dates and Times with lubridate ----
swirl()
# When you are at the R prompt (>):
# -- Typing skip() allows you to skip the current question.
# -- Typing play() lets you experiment with R on your own; swirl will ignore what you do...
# -- UNTIL you type nxt() which will regain swirl's attention.
# -- Typing bye() causes swirl to exit. Your progress will be saved.
# -- Typing main() returns you to swirl's main menu.
# -- Typing info() displays these options again.

Sys.getlocale("LC_TIME")
library(lubridate)
help(package = lubridate)
this_day <- today() # today's date
this_day
year(this_day)
month(this_day)
day(this_day)
wday(this_day)
wday(this_day,label = TRUE)
this_moment <- now() # today's date with time
this_moment
hour(this_moment)
minute(this_moment)
second(this_moment)

my_date <- ymd("1989-05-17")
my_date
class(my_date)
ymd("1989 May 17") # ymd understands the format to indentify the element
mdy("March 12, 1975")
dmy(25081985)
ymd("1920/1/2")
dt1
ymd_hms(dt1)
hms("03:22:14")
dt2
ymd(dt2)
update(this_moment, hours = 8, minutes = 34, seconds = 55)
this_moment <- update(this_moment, hours = now(), minutes = now())

nyc <- now("America/New_York") # list of timezones http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
nyc
depart <- nyc + days(2)
depart
depart <- update(depart,hours = 17, minutes = 34)
depart
arrive <- depart + hours(15) + minutes(50)
?with_tz # returns a date-time as it would appear in a different time zone
arrive <- with_tz(arrive,"Asia/Hong_Kong")
arrive
last_time <- mdy("June 17, 2008", tz="Singapore")
last_time
?interval #  creates an Interval object with the specified start and end dates
how_long <- interval(last_time,arrive)
as.period(how_long) # to see how long in time
stopwatch()



