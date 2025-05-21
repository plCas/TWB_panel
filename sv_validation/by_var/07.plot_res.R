library(dplyr)
library(tidyr)
library(ggplot2)

file_res = "/../by_var/res/accuracy_mode1.txt"
outfile  = "/../by_var/res/precision_violinplot_R2_0.png"

df = read.table(file_res, sep = "\t", header= T)

df$precision = df$TP / (df$TP + df$FP)
df$recall    = df$TP / (df$TP + df$FN)
df$SVTYPE    = gsub(".+_([A-Z]+)$", "\\1", df$var_id) 

df$bin = ifelse(df$AF_wgs > 0.05, "(0.05-0.5]", 
                ifelse(df$AF_wgs > 0.01, "(0.01-0.05]", "(0-0.01])"))

SVCOLOR = c("#E64B3599", "#00A08799")


p3 = ggplot(df , aes(bin, precision, fill = SVTYPE)) +
    geom_violin(scale = "width")+
    geom_boxplot(width=0.1, fill='#A4A4A4', color="black") +
    scale_x_discrete( limits = c("(0.01-0.05]", "(0-0.01])", "(0.05-0.5]")) +
    scale_fill_manual(values=SVCOLOR)+
    facet_grid(.~SVTYPE) +
    xlab("Bin") + ylab("Concordance Rate (Imputation)")+
    theme_minimal()+
    theme(axis.title = element_text(size = 20),
        axis.text.x = element_text(size = 18, angle = 45, hjust = 1),
        axis.text.y = element_text(size = 18),
        strip.text = element_text(size = 20),
        legend.position="none")


png(outfile, width = 8*2, height = 8, units = "in", res = 300)
print(p3)
dev.off()
