#Q1
- (base) cmdb@QuantBio-16 day2-morning % cut -f 7 hg38-gene-metadata-feature.tsv |sort | uniq -c
    - 19618 protein_coding genes
    - I would love to learn more about scaRNA because I have never heard of that type of RNA and I would love to know why we have non-coding RNAs

#Q2
-  (base) cmdb@QuantBio-16 day2-morning % cut -f 1 hg38-gene-metadata-go.tsv | uniq -c | sort -n
    - ENSG00000168036 has the most go_ids at 273
- (base) cmdb@QuantBio-16 day2-morning % grep "ENSG00000168036" hg38-gene-metadata-go.tsv | sort -k 3 > gene_ENSG00000168036.tsv
    - This gene is implicated in hundreds of different processes, so I would assume that this gene might be involved in development of an organism

#Q3
