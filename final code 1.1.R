####################################################
#
#                    USER INPUTS            
#
####################################################

setwd("O:/SMKLKALA/proj/data/r files")    # SET WORKING DIRECTORY, FOLDR WITH INPUT AND OUTPUT SUB FOLDERS
input.folder <- "O:/SMKLKALA/proj/data/input/"   # DIRECTORY OF FILES TO TRANSFORM. PAY ATTENTION TO \/!! R WORKS WITH /
output.folder <- "O:/SMKLKALA/proj/data/output/"   # DIRECTORY OF OUTPUT c, g, ex, im,i XLS FILES

all_data_multipyer = 1000   # ALL DATA WILL BE MULTIPLYED BY THIS COEFFICIENT


sub_group = c("perc")   # ADD GROUP NAME AS PART OF LABELS OF VARIABLES
sub_group_multiplyer = c(1 / 1000)    # ADD MULTIPLYER FOR EACH SUB GROUP

#install.packages("xlsx")   ## FOR THE FIRST USE ONLY
#install.packages("plyr")
#install.packages("reshape2")

####################################################
#
#                END OF USER INPUTS            
#
####################################################

################### READ LABELS DATA ###############

## Load Packages
library(xlsx)
library(plyr)
library(reshape2)

# READ XLS FILE WITH SERIES CODE LABELS
labels <- read.xlsx("labels.xlsx", 1) # read first sheet
labels <- labels[,c("code_series","eviews_name")]   # DROP NON RELEVANT COLUMNS
labels <- labels[!is.na(labels$eviews_name),]   # DROP SERIES WITHOUT LABELS
labels <- labels[!is.na(labels$code_series),]   # DROP SERIES WITHOUT CODES

################### READ DATA TABLES ###############

# READ DATA TO EDIT
for(i in c("y", "c", "g", "inv", "ex", "imp")) {
  assign(i, read.xlsx(paste(input.folder, i, ".xlsx", sep=""), 1, header=TRUE))
}


data = rbind.fill(y, c, g, inv, ex, imp)    # COMBINE ALL DATA SETS
data$value = as.numeric(as.character(data$value)) * all_data_multipyer   # REPLACE ALL NON NUMERIC VALUES WITH NA

quarterly_pos <- grep("-Q", data$time_period, fixed = TRUE)
data <- data[quarterly_pos, c("code_series","time_period","value")]   # KEEP COLUMNS code_series, time_period, value

data$code_series <- labels[match(data$code_series, labels$code_series), "eviews_name"]
data <- data[!is.na(data$code_series),]

for (i in 1:length(sub_group)){
  sub_group_pos <- grep(sub_group[i], data$code_series, fixed = TRUE)
  data$value[sub_group_pos] <- data$value[sub_group_pos] * sub_group_multiplyer[i]
}

data_melted <- melt(data, id = c("time_period", "code_series"), na.rm = TRUE)
data_wide <- dcast(data_melted, time_period ~ code_series, mean)

rownames(data_wide) <- gsub("-","", data_wide$time_period)
data_wide$time_period <- NULL

#################### SAVE DATA AND DATA BACKUP ##############
write.xlsx(data_wide, file = paste(output.folder, "out", ".xls", sep = ""))
write.xlsx(data_wide, file = paste(output.folder, "old/out_backup", Sys.Date(), ".xls", sep = ""))
