library(ggplot2)

# Step 3.2

# Load allele frequencies from AF.txt
af_file <- "~/qbb2024-answers/Week3/AF.txt"

lines <- readLines(af_file)[-1]  # Skip the first line (header)

# Convert the lines to numeric values
af_values <- as.numeric(lines)

# Check for any NA values that might indicate conversion issues
if (any(is.na(af_values))) {
  warning("Some allele frequencies could not be converted to numeric values.")
}

# Step 2: Plot histogram of allele frequencies
ggplot(data.frame(AfValues = af_values), aes(x = AfValues)) +
  geom_histogram(bins = 11, color = 'black', fill = 'lightblue') +
  labs(x = "Allele Frequency", y = "Count", title = "Allele Frequency Spectrum") +
  theme_minimal() +
  theme(panel.grid.major.y = element_line(color = "gray", size = 0.5))  # Add gridlines

# Save the plot
ggsave("allele_frequency_spectrum.png", width = 10, height = 6)

# The distribution of allele frequencies seems like a normal distribution, which is pretty much expected.
# We expect a normal distribution of allele frequencies in populations due to genetic drift, stabilizing selection favoring intermediate frequencies, and the balance between mutation and selection, which collectively stabilize allele frequencies around a mean value.

# Step 3.3

dp_file <- "~/qbb2024-answers/Week3/DP.txt"

# Read all lines from the file
dp_lines <- readLines(dp_file)

# Skip the header line and convert the remaining lines to numeric
dp_values <- as.numeric(dp_lines[-1])  # Exclude the first line (header)

# Step 2: Plot histogram of read depths
ggplot(data.frame(DPValues = dp_values), aes(x = DPValues)) +
  geom_histogram(bins = 21, color = 'black', fill = 'lightblue') +
  labs(x = "Read Depth", y = "Count", title = "Read Depth Distribution") +
  xlim(0, 20)  # Limit x-axis for better visibility

# Save the plot
ggsave("read_depth_distribution.png", width = 10, height = 6)

# This plot looks like a Poisson distribution, centering around 4x read depth. This makes sense, since we originally estimated that there would be around 4x coverage depth. 