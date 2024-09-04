#!/usr/bin/env python3

# grep.py target fileName.txt

# grep.py       target        fileName.txt
# sys.argv[0]   sys.argv[1]   sys.argv[2]
import sys

my_file = open( sys.argv[2] )

for line in my_file:
    line = line.rstrip("\n")
    if sys.argv[1] in line: 
        print(line)

my_file.close()