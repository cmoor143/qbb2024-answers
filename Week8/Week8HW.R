#Load packages
library(zellkonverter)
library(scuttle)
library(scater)
library(scran)
library(ggplot2)

#Load Data
gut <- readH5AD("~/qbb2024-answers/Week8/v2_fca_biohub_gut_10x_raw.h5ad")

# Rename Assay to counts
assayNames(gut) <- "counts"

# Normalize counts 
gut <- logNormCounts(gut)

#Inspect object
gut

# Determine number of genes and cells
num_genes <- nrow(gut) #Number of genes is 13407
num_cells <- ncol(gut) #Number of cells is 11788

# Dimension reduction
reducedDims(gut) #Dimension reduction datasets are X_pca, X_tsne, and X_umap

#Inspect colData
col_data <- colData(gut) #There are 39 columns in colData

# Find interesting columns
interesting_columns <- colnames(col_data)[1:39] # I find columns tissue, any of the leiden columns, and percent mito interesting.
# Tissue is interesting because I'm curious what different types of tissue within the Drosophila gut that they sampled
# Any of the leidin columns are interesting because it's a gene that plays a role in central nervous system development and I wonder what its role in the gut is
# Percent_mito is interesting because I wonder if it has data about mitochondria or mitochrondrial DNA 

#Plot cells using UMAP and color by broad_annotation
plotReducedDim(gut, dimred = "X_umap", color_by = "broad_annotation")

# Sum expression of each gene across all cells
genecounts <- rowSums(assay(gut, "counts"))

# Summary stats
summary(genecounts) # Mean is 3185 and median is 254. This might mean the distribution of counts is very broad. 

# Sort genes by expression to get the top 3
sorted_genes <- sort(genecounts, decreasing = TRUE)
top_genes <- names(sorted_genes) [1:3]
top_genes # Top 3 genes are  "lncRNA:Hsromega"  "pre-rRNA:CR45845" "lncRNA:roX1"
# All three of these genes seem to potentially be involved in RNA regulation and processing

# Find total expression across all genes for each cell
cellcounts <- colSums(assay(gut, "counts"))

# Make a histogram of cell counts
hist(cellcounts, main = "Total Expression per Cell", xlab = "Total Counts", breaks = 50)

# Find the mean expression per cell
mean_cellcounts <- mean(cellcounts)
mean_cellcounts # Mean expression per cell is 3622.082
# Cells with expression above 10000 may be large (but not necessarily) and potentially a specialized cell type, which may produce larger amounts of mRNA  

# Number of detected genes per cell
celldetected <- colSums(assay(gut, "counts") > 0)

# Create a histogram of detected genes
hist(celldetected, main = "Number of Genes Detected per Cell", xlab = "Number of Genes", breaks = 50)

# Mean number of detected genes 
mean_genes_detected <- mean(celldetected)
mean_genes_detected # The mean number of genes detected per cell is 1059.392

# Fraction of total genes detected 
fraction_detected <- mean_genes_detected / nrow(gut)
fraction_detected # The fraction of genes this represents is 0.07901785

# Identify mitochondrial genes
mito <- grep("^mt:", rownames(gut), value = TRUE)

# Create data frame with mitochondrial content
df <- perCellQCMetrics(gut, subsets = list(Mito = mito))

# Confirm metrics match previous calculations
df_summary <- as.data.frame(summary(df))
df_summary

# Add QC metrics to cell metadata
colData(gut) <- cbind(colData(gut), df)

# Plot percentage of mitochondrial reads
plotColData(gut, 
            y = "subsets_Mito_percent", 
            x = "broad_annotation") + 
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle("Percent Mitochondrial Reads by Cell Type")
ggsave("~/qbb2024-answers/Week8/percentage+of_mitochondrial_reads.png")
# Epithelial cells and gut cells have a higher percentage of mitochondrial reads.
# Epithelial cells and gut cells are often highly metabolically active because they perform critical functions.
# These functions include nutrient absorption, maintenance of barriers, and secretions of enzymes/mucus.
# The "unknown" cells likely high a high percentage of mitochondrial reads because they likely are a subset of cells with high mitochondrial activity. (e.g. immune cells)

# Create a vector indicating epithelial cells
coi <- colData(gut)$broad_annotation == "epithelial cell"

# Subset gut to create a new SingleCellExperiment object
epi <- gut[, coi]

# Plot UMAP of epithelial cells
umap_epithelial_cells <- plotReducedDim(epi, dimred = "X_umap", colour_by = "annotation")
ggsave("~/qbb2024-answers/Week8/umap_epithelial_cells.png", plot = umap_epithelial_cells, width = 6, height = 4, dpi = 300)

# Calculate pairwise comparisons between annotation categories
marker.info <- scoreMarkers(epi, colData(epi)$annotation)

# Get marker info for anterior midgut
chosen <- marker.info[["enterocyte of anterior adult midgut epithelium"]]

# Order by mean AUC to find top markers 
ordered <- chosen[order(chosen$mean.AUC, decreasing = TRUE), ]

# Display the top genes
head(ordered[, 1:4]) # The six top genes in the anterior midgut are Mal-A6, Men-b, vnd, betaTry, Mal-A1, and Nhe2
# This area of the gut seems to be involved in metabolizing carbohydrates 

# Plot expression of the top marker gene
top_gene <- rownames(ordered)[1]
plotExpression(epi, features = top_gene, x = "annotation") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("~/qbb2024-answers/Week8/top_genes.png")

# Subset somatic precursor cells
coi_precursor <- colData(gut)$broad_annotation == "somatic precursor cell"
precursor <- gut[, coi_precursor]

# Run scoreMarkers for somatic precursor cells
marker.info_precursor <- scoreMarkers(precursor, colData(precursor)$annotation)

# Extract and order marker genes for intestinal stem cells
chosen_precursor <- marker.info_precursor[["intestinal stem cell"]]
ordered_precursor <- chosen_precursor[order(chosen_precursor$mean.AUC, decreasing = TRUE), ]

# Top six marker genes
goi <- rownames(ordered_precursor)[1:6]

# Plot expression across cell types
expression_across_cell_types <- plotExpression(precursor, features = goi, x = "annotation")
ggsave("~/qbb2024-answers/Week8/expression_across_cell_types.png")
# Enteroblasts and intestinal stem cells seem to have the most similar expression based on these markers
# DI looks specific for intestinal stem cells 