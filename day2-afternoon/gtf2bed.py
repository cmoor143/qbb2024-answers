#!/usr/bin/env python3

import sys

my_file = open(sys.argv[1])

for my_line in my_file:
    if "##" in my_line:
        continue
    fields = my_line.split("\t")
    s = fields[8]
    s = s.split(";")
    s = s[2]
    s = s.strip('"')
    s = s.lstrip(' gene_name "')

    print(fields[0], fields[3], fields[4], s)

my_file.close()