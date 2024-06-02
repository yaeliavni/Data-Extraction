####################################################
#
#                    USER INPUTS            
#
####################################################
rm(list=ls())

setwd("O:/SMKLKALA/proj/data/r files")    # SET WORKING DIRECTORY, FOLDR WITH INPUT AND OUTPUT SUB FOLDERS
input.folder <- "../input/"   # DIRECTORY OF FILES TO TRANSFORM. Relative to wd. PAY ATTENTION TO \/!! R WORKS WITH /
output.folder <- "../output/"   # DIRECTORY OF OUTPUT c, g, ex, im,i XLS FILES

all_data_multipyer = 1000   # ALL DATA WILL BE MULTIPLYED BY THIS COEFFICIENT


sub_group = c("perc")   # ADD GROUP NAME AS PART OF LABELS OF VARIABLES
sub_group_multiplyer = c(1 / 1000)    # ADD MULTIPLYER FOR EACH SUB GROUP
update.packages()

#install.packages("Rtools")

#install.packages("readxl")   ## FOR THE FIRST USE ONLY
#install.packages("openxlsx")
#install.packages("plyr")
#install.packages("reshape2")

####################################################
#
#                END OF USER INPUTS            
#
####################################################

################### READ LABELS DATA ###############

## Load Packages
library(readxl)
library(openxlsx)
library(plyr)
library(reshape2)

# READ XLS FILE WITH SERIES CODE LABELS
labels <- read_xlsx("labels.xlsx") # read first sheet
labels <- labels[,c("code_series","eviews_name")]   # DROP NON RELEVANT COLUMNS
labels <- labels[!is.na(labels$eviews_name),]   # DROP SERIES WITHOUT LABELS
labels <- labels[!is.na(labels$code_series),]   # DROP SERIES WITHOUT CODES

################### READ DATA TABLES ###############

# READ DATA TO EDIT
for(i in c("y", "c", "g", "inv", "ex", "imp")) {
  assign(i, read_xlsx(paste(input.folder, i, ".xlsx", sep="")))
}


data_long = rbind.fill(y, c, g, inv, ex, imp)    # COMBINE ALL DATA SETS
data_long$value = as.numeric(as.character(data_long$value)) * all_data_multipyer   # Multiply by 1000

quarterly_pos <- grep("-Q", data_long$time_period, fixed = TRUE)           # Keep lines with quarterly data
data_long <- data_long[quarterly_pos, c("code_series","time_period","value")]   # KEEP COLUMNS code_series, time_period, value

data_long <- merge(data_long, labels)
#data_long$code_names <- labels[match(data_long$code_series, labels$code_series), 2] #Old merge method. Creates a problem with the code_series variable.
#data_long <- data_long[!is.na(data_long$eviews_name),]

for (i in 1:length(sub_group)){
  sub_group_pos <- grep(sub_group[i], data_long$eviews_name, fixed = TRUE)
  data_long$value[sub_group_pos] <- data_long$value[sub_group_pos] * sub_group_multiplyer[i]
}

#data_melted <- melt(data, id = c("time_period", "code_series"), na.rm = TRUE) #This line makes no sense whatsoever
data_wide <- dcast(data_long, time_period ~ eviews_name, mean)

rownames(data_wide) <- gsub("-","", data_wide$time_period)
data_wide$time_period <- NULL

#################### SAVE DATA AND DATA BACKUP ##############
write.xlsx(data_wide, file = paste(output.folder, "out", ".xlsx", sep = ""),rowNames = T)
#write.xlsx(data_wide, file = paste(output.folder, "old/out_backup", Sys.Date(), ".xls", sep = ""))


