library(gtools)
library(ggplot2)
library(RColorBrewer)
library(reshape2)
library(dplyr)

directory <- "."
setwd(directory)

filenames <- list.files(directory, recursive = FALSE, pattern = '*.table.csv',full.names = TRUE)
df.list <- lapply(filenames, read.table, sep = ',', header = TRUE, row.names = 1, stringsAsFactors=FALSE)



#Rescue we convert the 2s into 1s
df.rescue.list <- lapply(df.list, function(x) {
    tmp <- x
    #!!!!THIS ASSUMES THAT ORGANOID COMES FIRST AND TUMOR SECOND CAREFUL
    names(tmp) <- c("org", "tumor")
    tmp$type <- apply(tmp, 1, function(y){
        if (y["org"] > 0 && y["tumor"] > 0){
            type <- "shared"
        } else if (y["org"] > 0 && y["tumor"] == 0) {
            type <- "org"
        } else if (y["org"] == 0 && y["tumor"] > 0) {
            type <- "tumor"
        }
        else {type = "shared"}
        type
    })
    names(tmp) <- c(names(x), "type")
    as.data.frame(tmp)
})
df.rescue.percents <- lapply(df.rescue.list, function(x) {
    tmp <- table(x["type"])
    tmp$sample <- paste(colnames(x)[1], colnames(x)[2], sep = '~')
    # #Order elements to avoid problems when binding
    tmp <- tmp[c("tumor", "org", "shared", "sample")]
    tmp
})


#Merge the different matrices into one
df.rescue <- (as.data.frame(t(do.call("cbind", df.rescue.percents ))))
row.names(df.rescue) <- df.rescue$sample

df.rescue <- df.rescue %>%  mutate_all(as.character)
df.rescue$total <- apply(df.rescue, 1, function(x){
    as.integer(x["tumor"]) + as.integer(x["org"]) + as.integer(x["shared"])})


df.melt <- melt(df.rescue, id.vars=c("sample", "total"))
df.melt$value <- as.integer(df.melt$value)
df.melt$percent <- round(100 * df.melt$value / df.melt$total,0)
df.melt$pos <- apply(df.melt, 1, function(x){
    if (x["variable"] == "shared") {
        pos <- as.integer(x["value"]) %/% 2
    } else if (x["variable"] == "tumor") {
        add = df.melt[df.melt$sample == x["sample"] & df.melt$variable == "shared", "value"]
        pos <- add + (as.integer(x["value"]) %/% 2)
    } else if (x["variable"] == "org") {
        add = df.melt[df.melt$sample == x["sample"] & df.melt$variable == "shared", "value"] + 
            df.melt[df.melt$sample == x["sample"] & df.melt$variable == "tumor", "value"]
        pos <- add + (as.integer(x["value"]) %/% 2)
    }
    pos
})

df.melt$realsample <- apply(df.melt, 1, function(x){
    tmp <- unlist(strsplit(x["sample"], "_"))[1]
    tmp <- sub("\\.","-", tmp)
    if (tmp == "HGS-1.R2" || tmp == "HGS-1.R3") {
        tmp <- sub("\\.","-", tmp)
    }
    tmp
})

df.melt$realsample <- factor(df.melt$realsample)

df.melt$variable <- factor(df.melt$variable, levels = rev(c("shared", "tumor", "org")))

shared <- ggplot(df.melt, aes(x = realsample, y = value, fill=variable)) +
    geom_bar(stat="identity", width=.9) + theme_bw() + 
    theme(panel.grid = element_blank(),
          axis.line.x = element_line(colour = "black"),
          panel.spacing.y=unit(.3, "lines"),
          panel.border = element_rect(color = "black", fill = NA, size = .5),
          strip.text.y = element_text(size = 8, angle= 0, hjust = 0, vjust=0.5, face="bold"),
          axis.text.y =element_text(size=8, hjust=0,vjust=0.5, face = "bold"),
          axis.text.x =element_text(size=8, vjust=0.2, face="bold", angle=90),
          strip.background = element_blank()) +
    geom_label_repel(data = df.melt[df.melt$pos != 0,], aes(label = paste0(percent, '%'), y = pos, col = variable), fill = "white", direction = "y",
                     fontface = "bold") +
    scale_color_manual(name="Type", values = c("#fc8d62","#66c2a5","#8da0cb"), limits=c("shared", "tumor", "org"), 
                       labels = c("shared", "tumor", "org"), guide= F) +
    scale_fill_manual(name="Type", values = c("#fc8d62","#66c2a5","#8da0cb"), limits=c("shared", "tumor", "org"), labels = c("shared", "tumor", "org")) +
    
    ylab("# SNVs") + xlab("Sample")  +
    scale_y_continuous(breaks = seq(0,24000,2000), labels = seq(0,24000, 2000), expand = c(0.01, 0))

shared

write.csv(file = "sharedSNV.csv", x = df.rescue)
pdf(file =  "sharedSNV.pdf", width=16, height = 10)
shared
dev.off()
# ggsave(filename = "~/uproov_wd/PLOTS/revision/sharedSNV_legend.pdf", plot = slegend, device = pdf,
#        width=8, height = 5)


