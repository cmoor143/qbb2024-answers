library(tidyverse)
library(ggthemes)

#Open file
genome_coverage <- read.delim("/Users/cmdb/qbb2024-answers/Week 1/coverages.txt", comment.char = "#")

#Create histogram
histogram_plot <- ggplot(mapping = aes(x = X0)) +
  geom_histogram(data = genome_coverage, aes(y = ..count..), binwidth = 1, color = "black", fill = "gray") +
  labs(title = "3x Genome Coverage", x = "Coverage", y = "Frequency") +
  theme_classic()

mean_val <- 3
std_dev <- sqrt(3)
max_coverage = max(genome_coverage)
lambda <- mean_val

poisson_values <- dpois(0:max_coverage, lambda) * 1000000
normal_values <- dnorm(0:max_coverage, mean_val, std_dev) * 1000000

histogram_plot <- histogram_plot +
  geom_line(aes(x = 0:13, y = poisson_values, linetype = "solid", color = "Poisson")) +
  geom_line(aes(x = 0:13, y = normal_values, linetype = "solid", color = "Normal")) +
  scale_color_manual(values = c("Poisson" = "navyblue", "Normal" = "red4"))

histogram_plot

# 10x Coverage

coverages10 <- readr::read_tsv("/Users/cmdb/qbb2024-answers/Week 1/coverages10.txt")

coverages10 <- coverages10 %>%
  group_by(`# Coverage`) %>%
  summarize(Frequency = n()) 

poisson_pmf_10 <- dpois(0:26, 10) * 1000000

normal_pdf_10 <- dnorm(0:26, mean = 10, sd = 3.16) * 1000000

ggplot() +
  geom_bar(data = coverages10, 
           mapping = aes(x = `# Coverage`, y = Frequency, color = "Coverage across genome"), stat = "identity", fill = "orange") +
  geom_line(mapping = aes(x = 0:26, y = poisson_pmf_10, color = "Poisson Distribution")) +
  geom_line(mapping = aes(x = 0:26, y = normal_pdf_10, color = "Normal Distribution")) +
  labs(title = "10x Coverage", color = "Legend", x = "Coverage", y = "Frequency") 

# 30x Coverage

coverages30 <- readr::read_tsv("/Users/cmdb/qbb2024-answers/Week 1/coverages_30x.txt")

coverages30 <- coverages30 %>%
  group_by(`# Coverage`) %>%
  summarize(Frequency = n())

max_frequency <- max(coverages30$Frequency)

poisson_pmf_30 <- dpois(0:55, 30) * max_frequency / max(dpois(0:55, 30))
normal_pdf_30 <- dnorm(0:55, mean = 30, sd = 5.47) * max_frequency / max(dnorm(0:55, mean = 30, sd = 5.47))

ggplot() +
  geom_bar(data = coverages30, 
           mapping = aes(x = `# Coverage`, y = Frequency, color = "Coverage across genome"), stat = "identity", fill = "pink") +
  geom_line(mapping = aes(x = 0:55, y = poisson_pmf_30, color = "Poisson Distribution"), size = 1) +
  geom_line(mapping = aes(x = 0:55, y = normal_pdf_30, color = "Normal Distribution"), size = 1) +
  labs(title = "30x Coverage", color = "Legend", x = "Coverage", y = "Frequency") +
  theme_minimal()