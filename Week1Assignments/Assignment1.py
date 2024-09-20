#!/usr/bin/env python3

import sys

import numpy
import scipy

genome_size = 1000000
read_length = 100
coverage_target = 3

num_reads = int(coverage_target*genome_size/read_length)

# print(num_reads)

genome_coverage = numpy.zeros(genome_size, int)

for i in range (num_reads):
    start_position = numpy.random.randint(0, 990000)
    genome_coverage[start_position:start_position + read_length] += 1 


numpy.savetxt('coverages.txt', genome_coverage, delimiter = ',', fmt = '%d', header = "Coverage")

# 10x coverage

genomesize = 1000000
readlength = 100
coverage = 10

num_reads = ((genomesize*coverage)/readlength)

genome_coverage = numpy.zeros(1000000, int)

numberReads = int(num_reads)

for i in range(numberReads):
  startpos = numpy.random.randint(0, genomesize - readlength + 1) 
  endpos = startpos + readlength 
  genome_coverage[startpos:endpos] += 1

numpy.savetxt('coverages10.txt', genome_coverage, delimiter = ',', fmt = '%d', header = "Coverage")

#30x coverage

genome_size30 = 1000000
read_size30 = 100
coverage30 = 30           

# Calculate the number of reads
num_reads30 = int(coverage30 * genome_size30 / read_size30)

# Initialize coverage array
genome_coverage30 = numpy.zeros(genome_size30, int)

# Randomly place reads
for i in range(num_reads30):
    start_position = numpy.random.randint(0, genome_size30 - read_size30)
    genome_coverage30[start_position:start_position + read_size30] += 1 

# Save the data
numpy.savetxt('coverages_30x.txt', genome_coverage30, delimiter=',', fmt='%d', header="Coverage")