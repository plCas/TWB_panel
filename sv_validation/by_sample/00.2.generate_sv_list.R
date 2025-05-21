library(dplyr)
library(tidyr)
var_id_dir = "/../var_ids/snv_sv"
out_dir    = "/../SV_list"


for (CHR in c(1:22))
{
    df = read.table(paste0(var_id_dir, "/chr",CHR,".var_id.txt"), sep = "\t", header = F)
    #colnames(df) = c("CHR", "POS", "REF", "ALT", "SVLEN")
    pattern = "(chr[0-9]+):([0-9]+):([A-Z]+):(.+)"
    df$CHR = gsub(pattern, "\\1", df$V1)
    df$POS = gsub(pattern, "\\2", df$V1)
    df$REF = gsub(pattern, "\\3", df$V1)
    df$ALT = gsub(pattern, "\\4", df$V1)

    df = df %>% mutate(REF_len = nchar(REF), ALT_len = nchar(ALT))
    df$SVLEN = gsub(".+SVSIZE=([0-9]+).+", "\\1", df$ALT) %>% as.numeric()

    df$var_type = ifelse(grepl("DEL", df$ALT), "del",
                        ifelse((df$REF_len == 1) & (df$REF_len == df$ALT_len), "snv",
                            ifelse(df$REF_len > df$ALT_len, "del", "ins")))
    df$SVSIZE   = ifelse( grepl("DEL", df$ALT), abs(as.numeric(df$SVLEN) ),
                        ifelse(df$REF_len > df$ALT_len, df$REF_len, df$ALT_len) )
    df$check_SV       = ifelse(df$SVSIZE >= 50, "SV", "noSV" )

    data = df %>% filter(var_type %in% c("del", "ins") & check_SV == "SV")

    write.table(data$V1, quote = F, sep = "\t", row.names = F, col.names = F,
            paste0(out_dir, "/chr",CHR,"_SV_list.txt"))
}
