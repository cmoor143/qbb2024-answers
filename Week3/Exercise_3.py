#!/usr/bin/env python3

import os

# Step 3.1

vcf_file_name = "biallelic.vcf"  # Replace with the correct path if needed

# Check if the VCF file exists
if not os.path.isfile(vcf_file_name):
    raise FileNotFoundError(f"The file {vcf_file_name} does not exist in the current directory.")

# Open the VCF file for reading
allele_frequencies = []
read_depths = []

# Parse the VCF file
for line in open(vcf_file_name):
    if line.startswith('#'):
        continue  # Skip header lines
    fields = line.rstrip('\n').split('\t')
    
    # Extract allele frequency from INFO field
    info_fields = fields[7].split(';')
    for info in info_fields:
        if info.startswith('AF='):
            af_value = float(info.split('=')[1])
            allele_frequencies.append(af_value)

    # Extract read depth for each sample
    format_fields = fields[8].split(':')
    sample_data = fields[9:]  # Sample fields start from index 9
    for sample in sample_data:
        sample_fields = sample.split(':')
        dp_index = format_fields.index('DP')  # Find index of DP in FORMAT
        read_depth = int(sample_fields[dp_index])
        read_depths.append(read_depth)

# Write allele frequencies to AF.txt
with open("AF.txt", "w") as af_file:
    af_file.write("Allele Frequency\n")
    for af in allele_frequencies:
        af_file.write(f"{af}\n")

# Write read depths to DP.txt
with open("DP.txt", "w") as dp_file:
    dp_file.write("Read Depth\n")
    for dp in read_depths:
        dp_file.write(f"{dp}\n")

