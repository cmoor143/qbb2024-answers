#!/usr/bin/env python3

#Import packages
import sys


import numpy

# Get first file from user imput (should be gene_tissue.tsv)
filename = sys.argv[1]
# open file
fs = open(filename, mode='r')
# create dict to hold samples for gene-tissue pairs
relevant_samples = {}
# step through file
for line in fs:
    # Split line in file on tabs
    fields = line.rstrip("\n").split("\t")
    # Create key from gene and tissue names
    key = (fields[0], fields[2])
    # Initialize dictionary with key
    # Value is list to hold samples
    relevant_samples[key] = []
# Close file
fs.close()


# get metadata file name 
filename = sys.argv[2]
# open file
fs = open(filename, mode='r')
# Skip line
fs.readline()
# create dict to hold samples for tissue name
tissue_samples = {}
# step through file
for line in fs:
    # Split line into fields
    fields = line.rstrip("\n").split("\t")
    # Create key from gene and tissue
    key = fields[6]
    value = fields[0]
    # Initialize dict from key with list to hold samples
    tissue_samples.setdefault(key, [])
    tissue_samples[key].append(value)
fs.close()

# get metadata file name (GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct)
filename = sys.argv[3]
# open file
fs = open(filename, mode='r')
# Skip line
fs.readline()
fs.readline()

# Get sample IDs
header = fs.readline().rstrip("\n").split("\t")
header = header[2:]

# Initialize dictionary to hold indices of samples associated with tissues
tissue_columns = {}

# Retrieve keys and values from tissue_samples dictionary 
for tissue, samples in tissue_samples.items():
    # Make a new entry in the dictionary for new tissues
    tissue_columns.setdefault(tissue, [])
    
    # Iterate through relevant samples from tissue_samples dictionary 
    for sample in samples:
        # If sample present in gene expression data,
        # keep track column index
        if sample in header:
            position = header.index(sample)
            tissue_columns[tissue].append(position)
print(tissue_columns)

#Q5
#Find tissue with min number of samples
maxValue = 0
maxValueKey = ""
for tissue, samples in tissue_columns.items(): # pulling out key,value pairs 
    if len(samples) > maxValue: #
        maxValue = len(samples)
        maxValueKey = tissue
print(maxValueKey) # Muscle - Skeletal (Most samples)
minValue = 20000000
minValueKey = ""
for tissue, samples in tissue_columns.items():
    if len(samples) < minValue:
        minValue = len(samples)
        minValueKey = tissue
print(minValueKey) # Cells - Leukemia cell line (CML) (Least samples)

