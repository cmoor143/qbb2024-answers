# Step 1.1
# How many 100bp reads are needed to sequence a 1Mbp genome to 3x coverage?

# Number of reads = (Total bases needed for 3x coverage/Length of each read) = (3 x 1,000,000)/100 
# Number of reads = 30,000 reads 
# 30,000 reads of 100bp each are required for 3x coverage

# Step 1.4
# The frequency count was ~60,000 meaning about 6% of the genome is not sequenced
# The Poisson distribution predicts a frequency of 0x of the gemone covered to be around 50,000, which is less than we actually observed
# I think the normal distribution fits the data nicely, it predicts the distribution better than the Poisson distribution

# Step 1.5
# Very little, if at all of the genome has not been sequenced with 10x coverage
# From what I can tell, it seems to match the Poisson distribution very well. It perfectly matched with the coverage at 10, but in some cases the Poisson distribution vastly underestimates how much of the genome is actually sequenced.
# The normal data seems to fit the data even better than the Poisson, however it underestimated how high the peak of the graph would be. 

# Step 1.6
# I would guess that there is an incredibly small amount of the genome or none of the genome that has 0x coverage.
# Both the Poisson and normal distributions match incredibly well, very much more so than the 3x and 10x coverage. 

# Step 2.4
# dot -Tpng de_bruijn_graph.dot -o ex2_digraph.png

# Step 2.5
# ATTGATTCTTATTCATTGATTT

# Step 2.6
# There are a couple of things to accurately reconstruct the sequence of the genome. There needs to be sufficient overlap between reads, meaning that you need good coverage of the genome. You also need to avoid any repeating sequences because they can cause confusion. Additionally, it's important to ensure your data is free of sequencing errors as to avoid introducing incorrect edges into your graph.                                                                                                                                        
~                                                                                                       



