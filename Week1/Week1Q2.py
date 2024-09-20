#!/usr/bin/env python3

import sys

reads = ['ATTCA', 'ATTGA', 'CATTG', 'CTTAT', 'GATTG', 'TATTT', 'TCATT', 'TCTTA', 
         'TGATT', 'TTATT', 'TTCAT', 'TTCTT', 'TTGAT']

k = 3

edges = set()

for read in reads:
    for i in range(len(read) - k):
        kmer1 = read[i:i+k]    # Extract the k-mer starting at index i
        kmer2 = read[i+1:i+1+k]  # Extract the k-mer starting at index i+1
        edge = f"{kmer1} -> {kmer2}"  # Format the edge
        edges.add(edge)  # Add edge to the set 

with open("de_bruijn_edges.txt", "w") as file:
    for edge in sorted(edges):  # Sort for consistent output
        file.write(edge + "\n")

for edge in sorted(edges):
    print(edge)

with open("de_bruijn_graph.dot", "w") as dot_file:
    dot_file.write("digraph deBruijnGraph {\n")
    for edge in sorted(edges):
        nodes = edge.split(" -> ")
        dot_file.write(f'  "{nodes[0]}" -> "{nodes[1]}";\n')
    dot_file.write("}\n")