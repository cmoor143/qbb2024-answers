library(tidyverse)
library(ggthemes)

# Read in gene expression data
expression <- read_tsv("dicts_expr.tsv")

# Glimpse data
glimpse(expression)

# Add new identifiers w/ tissue and gene
# Log-transform expression data
expression <- expression %>%
  mutate(Tissue_Data = paste0(Tissue, " ", GeneID)) %>%
  mutate(Log2_Expr = log2(Expr + 1))

# Violin plot of expression data, by category
ggplot(data = expression, mapping = aes(x = Tissue_Data, y = Log2_Expr)) +
  geom_violin() +
  labs(y = "Log 2 Gene Expression", x = "Tissue Type + Genes") +
  coord_flip() 

# I was surprised to see that even with tissue and gene specificity, the gene expression of some samples is widely distributed across different samples
# Some examples of these samples are the pituitary, stomach, prostate, lung, minor salivary gland, and small intestine tissue
# Other samples have very little variability, such as samples from the pancreas
# I think that this difference may be due to the function of some of these tissues/genes
# Potentially, the pancreas has a very specific, set type of function that it rarely strays from, meaning gene expression variability will be very little
# While other samples, such as the pituitary, small intestine, and stomach may have several different functions and tissue types, and thus have gene expression variability depending on their needs at the time
# Some tissues might show greater variability due to their responsiveness to different physiological conditions or stressors. For example, the lung and intestines are frequently exposed to external environments
