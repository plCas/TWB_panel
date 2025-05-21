library(dplyr)
library(tidyr)
library(ggplot2)

outfile  = "/../by_sample/res/results.txt"

df = data.frame()

for(i in c(0, 0.2, 0.5, 0.8))
{
    file_res = paste0("/../by_sample/res/R2_",i,".txt")
    df.R2 = read.table(file_res, sep = "\t", header= T)
    df.R2$group = i
    df = data.frame(rbind(df, df.R2))
}

df$precision = df$TP / (df$TP + df$FP)
df$recall    = df$TP / (df$TP + df$FN)


res = df %>% group_by(SVTYPE,group) %>% summarise(precision_mean = mean(precision), precision_sd = sd(precision), recall_mean = mean(recall), recall_sd = sd(recall))
write.table(res, quote = F, sep = "\t", row.names = F, file = outfile)