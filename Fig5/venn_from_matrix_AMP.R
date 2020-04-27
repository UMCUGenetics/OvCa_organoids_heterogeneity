library(VennDiagram)

#First create matrix from SURVIVOR merged VCF using vcf_to_matrix.py

venn_twoSamples <- function(df)
{
    venn <- draw.pairwise.venn(area1=sum(df[,1]), area2=sum(df[,2]), 
                       cross.area = nrow(df[which(df[,1] == 1 & df[,2] == 1),]),
                       category = c(paste(colnames(df)[1], as.character(sum(df[,1])), sep = '-'),
                                    paste(colnames(df)[2], as.character(sum(df[,2])), sep = '-')),
                       fill=c('#7b3294','#a6dba0'), fontface = 'bold', cat.fontface = 'bold', margin=0.1)
                       
    venn
}

venn_threeSamples <- function(df)
{
    venn <- draw.triple.venn(area1=sum(df[,1]), area2=sum(df[,2]), area3=sum(df[,3]), 
                               n12 = nrow(df[which(df[,1] == 1 & df[,2] == 1),]),
                               n13 = nrow(df[which(df[,1] == 1 & df[,3] == 1),]),
                               n23 = nrow(df[which(df[,2] == 1 & df[,3] == 1),]),
                               n123 = nrow(df[which(df[,1] == 1 & df[,2] == 1 & df[,3] == 1),]),
                               category = c(paste(colnames(df)[1], as.character(sum(df[,1])), sep = '-'),
                                            paste(colnames(df)[2], as.character(sum(df[,2])), sep = '-'),
                                            paste(colnames(df)[3], as.character(sum(df[,3])), sep = '-')),
                               fill=c('#7b3294', '#a6dba0','#008837' ), fontface = 'bold', cat.fontface = 'bold', margin=0.1)
    
    venn
}

venn_fourSamples <- function(df)
{
    venn <- draw.quad.venn(area1=sum(df[,1]), area2=sum(df[,2]), area3=sum(df[,3]), area4=sum(df[,4]),
                             n12 = nrow(df[which(df[,1] == 1 & df[,2] == 1),]),
                             n13 = nrow(df[which(df[,1] == 1 & df[,3] == 1),]),
                             n14 = nrow(df[which(df[,1] == 1 & df[,4] == 1),]),
                             n23 = nrow(df[which(df[,2] == 1 & df[,3] == 1),]),
                             n24 = nrow(df[which(df[,2] == 1 & df[,4] == 1),]),
                             n34 = nrow(df[which(df[,3] == 1 & df[,4] == 1),]),
                             n123 = nrow(df[which(df[,1] == 1 & df[,2] == 1 & df[,3] == 1),]),
                             n124 = nrow(df[which(df[,1] == 1 & df[,2] == 1 & df[,4] == 1),]),
                             n134 = nrow(df[which(df[,1] == 1 & df[,3] == 1 & df[,4] == 1),]),
                             n234 = nrow(df[which(df[,2] == 1 & df[,3] == 1 & df[,4] == 1),]),
                             n1234 = nrow(df[which(df[,1] == 1 & df[,2] == 1 & df[,3] == 1 & df[,4] == 1),]),
                             category = c(paste(colnames(df)[1], as.character(sum(df[,1])), sep = '-'),
                                          paste(colnames(df)[2], as.character(sum(df[,2])), sep = '-'),
                                          paste(colnames(df)[3], as.character(sum(df[,3])), sep = '-'),
                                          paste(colnames(df)[4], as.character(sum(df[,4])), sep = '-')),
                             fill=c('#7b3294','#c2a5cf', '#a6dba0', '#008837'), fontface = 'bold', cat.fontface = 'bold', margin=0.1)
    
    venn
}

venn_fiveSamples <- function(df) {
    venn <- draw.quintuple.venn(area1=sum(df[,1]), area2=sum(df[,2]), area3=sum(df[,3]), area4=sum(df[,4]), area5=sum(df[,5]),
                           n12 = nrow(df[which(df[,1] == 1 & df[,2] == 1),]),
                           n13 = nrow(df[which(df[,1] == 1 & df[,3] == 1),]),
                           n14 = nrow(df[which(df[,1] == 1 & df[,4] == 1),]),
                           n15 = nrow(df[which(df[,1] == 1 & df[,5] == 1),]),
                           n23 = nrow(df[which(df[,2] == 1 & df[,3] == 1),]),
                           n24 = nrow(df[which(df[,2] == 1 & df[,4] == 1),]),
                           n25 = nrow(df[which(df[,2] == 1 & df[,5] == 1),]),
                           n34 = nrow(df[which(df[,3] == 1 & df[,4] == 1),]),
                           n35 = nrow(df[which(df[,3] == 1 & df[,5] == 1),]),
                           n45 = nrow(df[which(df[,4] == 1 & df[,5] == 1),]),
                           n123 = nrow(df[which(df[,1] == 1 & df[,2] == 1 & df[,3] == 1),]),
                           n124 = nrow(df[which(df[,1] == 1 & df[,2] == 1 & df[,4] == 1),]),
                           n125 = nrow(df[which(df[,1] == 1 & df[,2] == 1 & df[,5] == 1),]),
                           n134 = nrow(df[which(df[,1] == 1 & df[,3] == 1 & df[,4] == 1),]),
                           n135 = nrow(df[which(df[,1] == 1 & df[,3] == 1 & df[,5] == 1),]),
                           n145 = nrow(df[which(df[,1] == 1 & df[,4] == 1 & df[,5] == 1),]),
                           n234 = nrow(df[which(df[,2] == 1 & df[,3] == 1 & df[,4] == 1),]),
                           n235 = nrow(df[which(df[,2] == 1 & df[,3] == 1 & df[,5] == 1),]),
                           n245 = nrow(df[which(df[,2] == 1 & df[,4] == 1 & df[,5] == 1),]),
                           n345 = nrow(df[which(df[,3] == 1 & df[,4] == 1 & df[,5] == 1),]),
                           n1234 = nrow(df[which(df[,1] == 1 & df[,2] == 1 & df[,3] == 1 & df[,4] == 1),]),
                           n1235 = nrow(df[which(df[,1] == 1 & df[,2] == 1 & df[,3] == 1 & df[,5] == 1),]),
                           n1245 = nrow(df[which(df[,1] == 1 & df[,2] == 1 & df[,4] == 1 & df[,5] == 1),]),
                           n1345 = nrow(df[which(df[,1] == 1 & df[,3] == 1 & df[,4] == 1 & df[,5] == 1),]),
                           n2345 = nrow(df[which(df[,2] == 1 & df[,3] == 1 & df[,4] == 1 & df[,5] == 1),]),
                           n12345 = nrow(df[which(df[,1] == 1 & df[,2] == 1 & df[,3] == 1 & df[,4] == 1 & df[,5] == 1),]),
                           category = c(paste(colnames(df)[1], as.character(sum(df[,1])), sep = '-'),
                                        paste(colnames(df)[2], as.character(sum(df[,2])), sep = '-'),
                                        paste(colnames(df)[3], as.character(sum(df[,3])), sep = '-'),
                                        paste(colnames(df)[4], as.character(sum(df[,4])), sep = '-'),
                                        paste(colnames(df)[5], as.character(sum(df[,5])), sep = '-')),
                           fill=c('#7b3294','#c2a5cf', '#a6dba0', '#008837', '#d73027'), 
                           fontface = 'bold', cat.fontface = 'bold', margin=0.1)
    
    venn
}




args <- commandArgs()
filename <- args[6]
all <- read.table(filename, sep =',', header=T, stringsAsFactors = F)
all$gene <- NULL
colnames(all) <- gsub("_raw", "", colnames(all))
all[all==1] <- 0
all[all==2] <- 1
nsamples <- ncol(all)

if (nsamples == 2) {
    venn <- venn_twoSamples(all)
} else if (nsamples == 3) {
    venn <- venn_threeSamples(all)
} else if (nsamples == 4) {
    venn <- venn_fourSamples(all)
} else if (nsamples == 5) {
    venn <- venn_fiveSamples(all)
} else if (nsamples < 2) {
    stop("Not enough samples! I need at least 2 samples for a Venn Diagram")
} else if (nsamples > 4) {
    stop("Too many samples! I do not know what to do with more than 5 samples")
} 
pdf(NULL)
pdf(file=paste(filename,".amp.Venn.pdf", sep =''), height=12, width=12)
grid.draw(venn)
dev.off()
pdf(NULL)

