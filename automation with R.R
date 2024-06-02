
#upload libraries
packages <- c("xlsx","readxl")
new.packages <- packages[!(packages %in% installed.packages()[, "Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(packages, library, character.only = TRUE)
library(xlsx)
library(readxl)
library(httr)


# מדד מחירים ואינפלציה 

inflation <- read.csv("https://api.cbs.gov.il/index/data/price?id=120010&format=csv&download=true")
inflation

#datanumber_of_unemployed <- read.csv("https://apis.cbs.gov.il/series/data/list?id=120020&startperiod=01-2022&endperiod=12-2022&format=csv&download=false")

# מספר מובטלים

datanumber_of_unemployed <- read.csv("https://apis.cbs.gov.il/series/data/list?id=40005&startperiod=01-2022&endperiod=07-2023&format=csv&download=false")
datanumber_of_unemployed = datanumber_of_unemployed[,c('obs_time_period', 'obs_value')]
datanumber_of_unemployed

# אחוז מובטלים
לסדר

datanumber_of_unemployed <- read.csv("https://apis.cbs.gov.il/series/data/list?id=40013&startperiod=04-2020&endperiod=12-2022&format=csv&download=false")
datanumber_of_unemployed = datanumber_of_unemployed[,c('obs_time_period', 'obs_value')]
datanumber_of_unemployed


# תוצר במחירים שוטפים

raw_xlsx <- httr::GET("https://apis.cbs.gov.il/series/data/list?id=62916&format=xls&download=false")$content
tmp <- tempfile(fileext = '.xlsx')
writeBin(raw_xlsx, tmp)
GDP <- readxl::read_excel(tmp)

# תוצר במחירים משורשרים של שנת 2015

raw_xlsx <- httr::GET("https://apis.cbs.gov.il/series/data/list?id=63456&format=xls&download=false")$content
tmp <- tempfile(fileext = '.xlsx')
writeBin(raw_xlsx, tmp)
GDP_R <- readxl::read_excel(tmp)
GDP_R = as.data.frame(GDP_R)

r = cbind(GDP_R$obs_time_period, GDP_R$`obs_value`)