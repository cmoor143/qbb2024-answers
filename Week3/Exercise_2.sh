#!/usr/bin/env bash

wget https://hgdownload.cse.ucsc.edu/goldenPath/sacCer3/bigZips/sacCer3.fa.gz
gunzip sacCer3.fa.gz

# Index genome
bwa index sacCer3.fa


# Step 2.1: Index the sacCer3 genome

# Determine the number of yeast chromosomes
grep ">" sacCer3.fa
# There are 17 chromosomes in this yeast genome

# Step 2.2
for sample in *.fastq
do
    bwa mem -t 4 -R "@RG\tID:${sample%.fastq}\tSM:${sample%.fastq}" sacCer3.fa $sample > ${sample%.fastq}.sam
done

# Question 2.3

grep -v "^@" A01_09.sam | wc -l # Count how many lines in the SAM file contain an alignment

# There are 669548 read alignments in the SAM file

grep "^chrIII" A01_09.sam | wc -l # Count only the alignments on chromosome III, filter headings

# 18196 alignments are to loci on chromosome III 

# Step 2.4 

# Sort and convert each SAM file to BAM in a loop
for sample in *.sam
do
    samtools sort -O bam -o ${sample%.sam}.sorted.bam $sample
done

# Index the sorted BAM files
for sample in *.sorted.bam
do
    samtools index $sample
done

# Step 2.5

# Depth of coverage is variable, but consistent with Step 1.3 where we calculated expected depth of coverage to be around 4.24, most positions have around 4-5x coverage

# I observed 3 steps in this window
# Uncertain of the 3rd SNP because it only has 2x coverage, which is low.

# Its position is chrIV:825,834 and it doesn't fall into a gene.
