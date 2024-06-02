#compare output  data with arkadi data
#before we run the script we should update the file arkadii compare
install.packages("readxl")
library(readxl)
arkadii_compare <- read_excel("O:/SMKLKALA/proj/data/r files/arkadii_compare.xlsx",col_names = FALSE)
out <- read_excel("O:/SMKLKALA/proj/data/output/out.xlsx")
M_arkadii=arkadii_compare$X__11
K_arkadii=arkadii_compare$X__9
T_arkadii=arkadii_compare$X__18
I_arkadii=arkadii_compare$X__7
D_arkadii=arkadii_compare$X__2
date=out$X__1
M_out=out$imp_n[61:length(date)]
K_out=out$ex_n[61:length(date)]
T_out=out$GDP_bs_n[61:length(date)]
I_out=out$finv_inventories_n[61:length(date)]
D_out=out$gcons_n[61:length(date)]
M_out_new=M_out/1000
signif(M_arkadii,1)==signif(M_out_new,1)
K_out_new=K_out/1000
signif(K_arkadii,1)==signif(K_out_new,1)
T_out_new=T_out/1000
signif(T_arkadii,1)==signif(T_out_new,1)
I_out_new=I_out/1000
signif(I_arkadii,1)==signif(I_out_new,1)
D_out_new=D_out/1000
signif(D_arkadii,1)==signif(D_out_new,1)
#check the output in the console if everything is true then the files are the same.

