#!/usr/bin/env python3

# open file
#skip 2 lines
#split column header by tabs and skip first two entries
#create way to hold gene names
#create way to hold expression values
#for each line
#    split line
 #   save field 1 into gene names
  #  save 2+ into expression values

import sys

import numpy

#Q1

fs = open( sys.argv[1], mode = 'r' )
fs.readline()
fs.readline()
line = fs.readline()
fields = line.split("\t")
tissues = fields[2:]

gene_names = []
gene_IDs = []
expression = []

for line in fs:
    fields = line.strip("\n").split("\t")
    gene_IDs.append(fields[0])
    gene_names.append(fields[1])
    expression.append(fields[2:])
fs.close()

#Q2

gene_IDs = numpy.array(gene_IDs)
gene_names = numpy.array (gene_names)
expression = numpy.array(expression, dtype = float)
tissues = numpy.array (tissues)

print = (gene_IDs)
print = (gene_names)
print = (expression)
print = (tissues)

# You need to tell numpy that you are using floats because it will initially recognize it as a string, so we must specify that we have floats within the data set

#Q4

mean_expression = numpy.mean(expression[:10], axis=1)
print(mean_expression)

#Q5

dataset_mean = numpy.mean(expression)
dataset_median = numpy.median(expression)
print(dataset_mean)
print(dataset_median)

#We can infer that this data set is positively skewed because the mean is much larger than the median

#Q6

expression = expression + 1
transformed_expression = numpy.log2(expression)
transformed_mean = numpy.mean(transformed_expression)
transformed_median = numpy.median(transformed_expression)
print(transformed_mean)
print(transformed_median)

#The transformed median and mean are much closer in value in comparison to the original mean and median that we took

#Q7

expression_array_copy = numpy.copy(transformed_expression)
sorted_transformed_expression = numpy.sort(expression_array_copy, axis = 1)
diff_array = sorted_transformed_expression[:,-1] - sorted_transformed_expression[:,-2]
print(diff_array)

#Q8

print(numpy.sum(diff_array >= 10))