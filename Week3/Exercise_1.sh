#!/usr/bin/env bash

### Question 1.1 ###

#Determining the length of the reads within A01_09.fastq
cat A01_09.fastq | head -n 2 | tail -n 1 | wc -c
# The length of the sequencing reads is 77 bp.

### Question 1.2 ###

# Determining the number of reads
cat A01_09.fastq | wc -l | awk '{print $1/4}'
# The number of reads within the file is 669548

### Question 1.3 ###
# Determine depth of coverage
# Depth of coverage = (number of reads x read length)/(genome size)
# Genome size of S. cerevisiae is ~ 12,157,105 bp
echo "scale=2; (669548 * 77) / 12157105" | bc
# The expected depth of coverage is about 4.24

### Question 1.4 ###

# Look at the sizes of all the FASTQ files
du -sh *.fastq.gz
# The largest file size is 149 M from A01_62.fastq
# The smallest file size is 110 M and is from A01_27.fastq

### Question 1.5 ###

# FastQC analysis
fastqc A01_09.fastq
# Look at HTML file
# Median quality score is 36
# Can calculate phred score to determine confidence in the base call
# P = 10^(-Q/10) = 10^(-36/10) = 0.0002512
# So the probability of error is ~0.0251%, which indicates a very high confidence in the accuracy of the base call
# Most positions have consistent median scores and narrow IQRs, so there's little variation in quality