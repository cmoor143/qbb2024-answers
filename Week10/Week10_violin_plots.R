# Load necessary libraries
library(ggplot2)
library(dplyr)

# Load the CSV data saved in the previous step
data <- read.csv("~/qbb2024-answers/Week10/nucleus_signals.csv")

# 1. Violin Plot for PCNA Signal
pcna_plot <- ggplot(data, aes(x = Gene, y = PCNA, fill = Gene)) +
  geom_violin(trim = FALSE, alpha = 0.7) +
  geom_boxplot(width = 0.2, outlier.size = 0.5, alpha = 0.8) +
  labs(
    title = "Distribution of PCNA Signal by Gene Knockdown",
    x = "Gene Knockdown",
    y = "Mean PCNA Signal"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# 2. Violin Plot for Nascent RNA Signal
rna_plot <- ggplot(data, aes(x = Gene, y = NascentRNA, fill = Gene)) +
  geom_violin(trim = FALSE, alpha = 0.7) +
  geom_boxplot(width = 0.2, outlier.size = 0.5, alpha = 0.8) +
  labs(
    title = "Distribution of Nascent RNA Signal by Gene Knockdown",
    x = "Gene Knockdown",
    y = "Mean Nascent RNA Signal"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# 3. Violin Plot for Log2 Ratios
ratio_plot <- ggplot(data, aes(x = Gene, y = Log2Ratio, fill = Gene)) +
  geom_violin(trim = FALSE, alpha = 0.7) +
  geom_boxplot(width = 0.2, outlier.size = 0.5, alpha = 0.8) +
  labs(
    title = "Log2 Ratio of Nascent RNA to PCNA Signal by Gene Knockdown",
    x = "Gene Knockdown",
    y = "Log2 Ratio (Nascent RNA / PCNA)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Save and display the plots
print(pcna_plot)
print(rna_plot)
print(ratio_plot)

# Optionally save the plots to files
ggsave("PCNA_violin_plot.png", plot = pcna_plot, width = 8, height = 6)
ggsave("RNA_violin_plot.png", plot = rna_plot, width = 8, height = 6)
ggsave("Log2Ratio_violin_plot.png", plot = ratio_plot, width = 8, height = 6)
