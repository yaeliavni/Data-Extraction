#Check the diffrence between final code 1.1 and final code 1.2
out1 <- read_xls("O:/SMKLKALA/proj/data/output/out.xls")
out2 <- read_xlsx("O:/SMKLKALA/proj/data/output/out2.xlsx")
out1 <- out1[,order(names(out1))]
out2 <- out2[,order(names(out2))]
compare <- match(out1,out2)
compare
out2 <- out2[,-c(38,71)]                          #these variables only exist in out2
comp <- out1[2:95,1:93] - out2[2:95,1:93]
comp <- comp[ , colSums(is.na(comp)) == 0]        #remove NA's
summary(colMeans(comp))                           #if all are 0's then we're good
View(comp)