#!/bin/bash

snp_files=("chr1_snps_0.1.bed" "chr1_snps_0.2.bed" "chr1_snps_0.3.bed" "chr1_snps_0.4.bed" "chr1_snps_0.5.bed")
feat_files=("cCREs_chr1.bed" "exons_chr1.bed" "introns_chr1.bed" "other_chr1.bed")
full_genome="genome_chr1.bed"

echo -e "MAF\tFeature\tEnrichment" > snp_counts.txt

for SNP in "${snp_files[@]}"; do
    maf_value=$(basename "$SNP" .bed)  # Extracts the MAF value from the filename

    genome_coverage=$(bedtools coverage -a "$full_genome" -b "$SNP")

    total_snps=$(echo "$genome_coverage" | awk '{s+=$4}END{print s}')
    genome_size=$(echo "$genome_coverage" | awk '{s+=$3-$2}END{print s}')

    background=$(echo "scale=10; $total_snps / $genome_size" | bc -l)

    for feature in "${feat_files[@]}"; do
        feature_name=$(basename "$feature" .bed)

        feature_coverage=$(bedtools coverage -a "$feature" -b "$SNP")

        feature_snps=$(echo "$feature_coverage" | awk '{s+=$4}END{print s}')
        feature_size=$(echo "$feature_coverage" | awk '{s+=$3-$2}END{print s}')

        feature_density=$(echo "scale=10; $feature_snps / $feature_size" | bc -l)
        enrichment=$(echo "scale=10; $feature_density / $background" | bc -l)

        # Append result to output file
        echo -e "$maf_value\t$feature_name\t$enrichment" >> snp_counts.txt
    done
done

