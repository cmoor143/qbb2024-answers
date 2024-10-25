# Load necessary libraries
library(DESeq2)
library(vsn)
library(matrixStats)
library(readr)
library(dplyr)
library(tibble)
library(hexbin)
library(ggfortify)
library(ggplot2)  # Ensure ggplot2 is loaded

# Load file and parse
data = readr::read_tsv('salmon.merged.gene_counts.tsv') %>%
  column_to_rownames(var = "gene_name") %>%
  select(-gene_id) %>%
  mutate_if(is.numeric, as.integer) %>%
  filter(rowSums(across()) > 100) # Filter out low counts

# Pull out narrow region samples (21 columns)
narrow = data %>% select("A1_Rep1":"P2-4_Rep3")

# Create metadata tibble
narrow_metadata = tibble(
  tissue = as.factor(c("A1", "A1", "A1", 
                       "A2-3", "A2-3", "A2-3", 
                       "Cu", "Cu", "Cu", 
                       "LFC-Fe", "LFC-Fe", "LFC-Fe", 
                       "Fe", "Fe", "Fe",
                       "P1", "P1", "P1", 
                       "P2-4", "P2-4", "P2-4")),
  rep = as.factor(c(1, 2, 3, 1, 2, 3, 1, 2, 3, 
                    1, 2, 3, 1, 2, 3, 1, 2, 3, 
                    1, 2, 3))
)

# Create DESeq2 object
narrowdata = DESeqDataSetFromMatrix(countData = as.matrix(narrow), 
                                    colData = narrow_metadata, 
                                    design = ~ tissue)

# Plot variance by average (before VST)
meanSdPlot(assay(narrowdata))

# Perform variance stabilization transformation
narrowVstdata = vst(narrowdata)

# Ensure narrowVstdata is a DESeqDataSet object (not converted to matrix yet)
# No need for conversion before PCA

# Calculate mean across replicates
combined = (assay(narrowVstdata)[, seq(1, 21, 3)] + 
              assay(narrowVstdata)[, seq(2, 21, 3)] + 
              assay(narrowVstdata)[, seq(3, 21, 3)]) / 3

# Filter out low variance genes
sds = rowSds(combined) > 1 # Where row STDEV > 1
narrowVstdata = narrowVstdata[sds,]

# Set seed for reproducibility
set.seed(42)

# Cluster genes
k = kmeans(assay(narrowVstdata), centers = 12)$cluster

# Find ordering of samples
ordering = order(k)

# Reorder genes
k = k[ordering]

# Plot heatmap of expressions and clusters
heatmap(assay(narrowVstdata)[ordering,], Rowv = NA, Colv = NA, 
        RowSideColors = RColorBrewer::brewer.pal(12, "Paired")[k], 
        main = "Heatmap of Gene Clusters")

# Save heatmap as image
png("heatmap.jpg")
dev.off()

# Pull out gene names from cluster 1
genes = rownames(assay(narrowVstdata)[k == 1, ])

# Write gene names to a text file
write.table(genes, "cluster_genes.txt", sep = "\n", quote = FALSE, 
            row.names = FALSE, col.names = FALSE)

# PCA analysis and plot
narrowPcaData = plotPCA(narrowVstdata, intgroup = c("rep", "tissue"), returnData = TRUE)

# Create PCA plot
pca_plot <- ggplot(narrowPcaData, aes(x = PC1, y = PC2, color = tissue, shape = rep)) +
  geom_point(size = 5) +
  theme_minimal() +  # Added a theme for better aesthetics
  labs(title = "PCA of Narrow Region Samples",
       x = "Principal Component 1",
       y = "Principal Component 2")

# Save the plot
ggsave("PCA.png", plot = pca_plot)