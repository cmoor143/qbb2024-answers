library(tidyverse)
library(ggthemes)

df <- read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

#Q1
read_delim("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

#Q2
glimpse(df)

#Q3
RNA_seq <- df %>%
  filter(SMGEBTCHT == "TruSeq.v1")

#Q4
ggplot(data = RNA_seq, mapping = aes(x = SMTSD)) +
  geom_bar() +
  xlab("Tissue Type") +
  ylab("Number of Samples") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

#Q5
ggplot(data = RNA_seq, mapping = aes(x = SMRIN)) +
  geom_histogram(bins = 10) +
  xlab("RNA Integrity Number") +
  ylab("Cell Frequency") +
# The distribution is unimodal, but is slightly skewed to the right
# A histogram is typically the best way of representing continuous distribution 

#Q6
ggplot(data = RNA_seq, mapping = aes(x = SMTSD, y = SMRIN)) +
  geom_violin() +
  xlab("Tissue Type") +
  ylab("RNA Integrity Number") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
# In this instance, a violin is best for contrasting continuous distributions across multiple groups because we can see the RIN distribution across several different tissue types without confusion
# Distribution of RIN seems to be very similar across tissue samples, except for EBV-transformed lympocytes, CML, and kidney-medulla tissue types
# In terms of this data, the CML and kidney-medulla distributions seem to be outliers, since their RIN distributions are so high and low (respectively) as compared to other tissue samples
# The RNA extraction process from tissues can compromise the RIN, so RIN retrieved from cell culture are higher

#Q7
ggplot(data = RNA_seq, mapping = aes(x = SMTSD, y = SMGNSDTC)) +
  geom_violin() +
  xlab("Tissue Type") +
  ylab("Number of Genes") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
# Violin plot is also the best to visualize the distribution in this instance
# Distribution is somewhat similar across tissue types, however interestingly, the testes seem to have a much higher number of genes across multiple samples
# Testes are an outlier, which might be explained by the fact that "testis expresses the largest number of genes of any mammalian organ" (Xia et al., 2021) 

#Q8
ggplot(data = RNA_seq, mapping = aes(x = SMTSISCH, y = SMRIN)) +
  geom_point(size = 0.5, alpha = 0.5) +
  xlab("Ischemic Time ") +
  ylab("RNA Integrity Number") +
  facet_wrap("SMTSD") +
  geom_smooth(method = "lm")
# Most tissue types do not seem to be affected, however some tissue types see a decrease in RIN with greater ischemic time. This is likely because tissues in cadavers are degrading
  
#Q9
ggplot(data = RNA_seq, mapping = aes(x = SMTSISCH, y = SMRIN)) +
  geom_point(size = 0.5, alpha = 0.5, aes(color = SMATSSCR)) +
  xlab("Ischemic Time ") +
  ylab("RNA Integrity Number") +
  facet_wrap("SMTSD") +
  geom_smooth(method = "lm")
# With greater ischemic time, we see SMARTSSCR scores become higher, and RIN decreases. This makes sense as degrading tissue would have less blood flow and would mean autolysis is also greater, hence the higher SMATSSCR score.
