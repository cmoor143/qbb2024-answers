# Exercise 1, Step 1.1

# Load libraries
library(DESeq2)
library(tidyverse)

# Load data
gene_expr <- read_delim("gtex_whole_blood_counts_downsample.txt")
metadata <- read_delim("gtex_metadata_downsample.txt")

# Move gene names to row names
gene_expr <- gene_expr %>% column_to_rownames(var = "GENE_NAME")

# Move subject IDs to row names in metadata
metadata <- metadata %>% column_to_rownames(var = "SUBJECT_ID")

# Peek at data
head(gene_expr[, 1:5])
head(metadata)

# Exercise 1, Step 1.2

# Check order cosistency
all(rownames(metadata) == colnames(gene_expr))

# Create DESeq2 object
dds <- DESeqDataSetFromMatrix(
  countData = gene_expr,
  colData = metadata,
  design = ~ SEX + DTHHRDY + AGE
)

# Exercise 1, Step 1.3

# Variance Stabilization Transformation
vsd <- vst(dds)

# Plot PCA
png("pca_by_sex.png")
plotPCA(vsd, intgroup = "SEX")
dev.off()

png("pca_by_age.png")
plotPCA(vsd, intgroup = "AGE")
dev.off()

png("pca_by_death_cause.png")
plotPCA(vsd, intgroup = "DTHHRDY")
dev.off()

# Step 1.3.3 (Answers)
# Principal component 1 explains 48% of variance in our data
# Principal component 2 explains 7% of the variance in our data
# PC1 appears to explain a large portion of variance, and clustering along this axis is most strongly associated with cause of death, indicating it as a primary factor in expression variation. 
# PC2, explaining a smaller percentage, seems associated with age, suggesting a secondary effect. There is also some evidence of sex-associated variation, though it appears dispersed across PCs, suggesting it contributes to variance but less dominantly.

# Exercise 2

# Step 2.1: Test for Differential Expression of WASH7P
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()

vsd_df <- bind_cols(metadata, vsd_df)

m1 <- lm(formula = WASH7P ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
# WASH7P doesn't show significant evidence of sex-differential expression because p > 0.05

m2 <- lm(formula = SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
# SLC25A47 shows evidence of sex-differential expression because p < 0.05
# We see it in the positive direction for males because the value is positive

# Step 2.2: Apply the DESeq Function
dds <- DESeq(dds)

# Step 2.3: Extract and Interpret DE Results for Sex
res_sex <- results(dds, name = "SEX_male_vs_female") %>%
  as_tibble(rownames = "GENE_NAME")

# Count Significant Genes at 10% FDRs
sig_genes <- res_sex %>%
  filter(padj < 0.1)
# 262 genes are differentially expressed between males and females at 10% FDR

# Chromosomal Distribution of Top Hits
chrom_map <- read_delim("gene_locations.txt")
res_sex_merged <- left_join(res_sex, chrom_map, by = "GENE_NAME") %>%
  arrange(padj)

# Chromosome Y encodes for genes that are most strongly upregulated in males versus females 
# There are more male-upregulated genes at the top of the list
# Only males have a Y chromosome, so any genes expressed on that chromosome will be differentially expressed in males v. females 

WASHP7DESeq = res_sex_merged %>% filter(GENE_NAME == "WASH7P")
SLC25A47DESeq = res_sex_merged %>% filter(GENE_NAME == "SLC25A47")

# The results for the two genes are broadly consistent with the linear regression findings in 2.1
# We see no significance for WASH7P, but do see significance for SLC25A47

# Step 2.4: DE Analysis by Death Classification
res_death <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes") %>%
  as_tibble(rownames = "GENE_NAME")

# Filter for rows with padj < 0.1 and removing where padj = NA 
res_death %>%
  filter(!is.na(padj)) %>%
  arrange(padj) %>%
  filter(padj < 0.1) %>%
  nrow()
# There are 16069 genes that are differentially expressed according to death classification at a 10% FDR
# 2.4.2 Answer: Finding 16,069 differentially expressed genes at a 10% FDR suggests that the cause of death is associated with widespread changes in gene expression across the genome in whole blood
# This could imply that physiological changes occurring in the body near the time of death significantly impact gene expression patterns
# Since cause of death accounted for 48% of the differential expression compared to just 7% for sex, it’s expected that around 48% of all differentially expressed genes appear in the dataset when filtered with cause of death as the primary variable of interest.

# Exercise 3

# Step 3.1: Create a Volcano Plot with ggplot
library(ggplot2)

res_sex <- res_sex %>%
  mutate(significant = ifelse(padj < 0.1 & abs(log2FoldChange) > 1, "Significant", "Not Significant"))

ggplot(res_sex, aes(x = log2FoldChange, y = -log10(padj), color = significant)) +
  geom_point() +
  labs(x = "log2(Fold Change)", y = "-log10(FDR-adjusted p-value)", title = "Volcano Plot of DE by Sex") +
  theme_minimal() +
  scale_color_manual(values = c("Significant" = "red", "Not Significant" = "grey"))

ggsave("volcano_plot_sex_de.png", width = 8, height = 6)
