tar xzf chr1_snps.tar.gz

sortBed -i genes.bed > sorted_genes.bed
mergeBed -i sorted_genes.bed > genes_chr1.bed

sortBed -i exons.bed > sorted_exons.bed
mergeBed -i sorted_exons.bed > exons_chr1.bed

sortBed -i cCREs.bed > sorted_cCREs.bed
mergeBed -i sorted_cCREs.bed > cCREs_chr1.bed

subtractBed -a genes_chr1.bed -b exons_chr1.bed > introns_chr1.bed 

subtractBed -a genome_chr1.bed -b exons_chr1.bed introns_chr1.bed cCREs_chr1.bed > other_chr1.bed