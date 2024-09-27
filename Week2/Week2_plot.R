library(ggplot2)
library(dplyr)

data <- read.table("snp_counts.txt", header = TRUE, sep = "\t")

data$MAF <- as.numeric(gsub("chr1_snps_", "", data$MAF))  # Extract numeric part

data$log2_enrichment <- log2(data$Enrichment)

p <- ggplot(data, aes(x = MAF, y = log2_enrichment, color = Feature, group = Feature)) +
  geom_line(size = 1) +                 
  geom_point(size = 2) +             
  scale_x_continuous(breaks = unique(data$MAF)) +  
  labs(x = "MAF", y = "log2(Enrichment)", title = "SNP Enrichment by Feature and MAF") +
  theme_minimal() +                     
  theme(legend.title = element_blank())  

ggsave("snp_enrichments.pdf", plot = p, width = 8, height = 6)