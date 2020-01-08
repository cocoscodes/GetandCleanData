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



