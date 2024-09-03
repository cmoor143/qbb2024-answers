library("tidyverse")
df <- read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")
df <- df %>%
  mutate( SUBJECT=str_extract( SAMPID, "[^-]+-[^-]+" ), .before=1 )
view(df)
df %>%
  group_by(SUBJECT) %>%
  summarize(n_of_samples=n()) %>%
  arrange(desc(n_of_samples))
# K-562 is the subject with the most samples of 217 and GTEX-NPJ8 has the second most number of samples at 72

df %>%
  group_by(SUBJECT) %>%
  summarize(n_of_samples=n()) %>%
  arrange(n_of_samples)
#GTEX-1JMI6 and GTEX-1PAR6 both have the least number of samples, each with a value of 1

df %>%
  group_by(SMTSD) %>%
  summarize(n_tissue_types=n()) %>%
  arrange(n_tissue_types)
# Kidney - Medulla and Cervix - Ectocervix have the smallest number of samples with 4 and 9 respectively
# Potentially the medulla of the kidney and the ectocervix of the cervix are difficult to harvest, and this is why we see such low values

df %>%
  group_by(SMTSD) %>%
  summarize(n_tissue_types=n()) %>%
  arrange(desc(n_tissue_types))
# Whole Blood and Muscle - Skeletal have the highest number of samples with 3288 and 1132 respectively
# Blood and skeletal muscle are in excess in the body, which could mean that they are easier to obtain samples of

subset(df, SUBJECT == "GTEX-NPJ8")
df_npj8 <- subset(df, SUBJECT == "GTEX-NPJ8")

df_npj8 %>%
  group_by(SMTSD) %>%
  summarize(n_of_samples=n()) %>%
  arrange(desc(n_of_samples))
# Most samples = whole blood
view(df_npj8)
# Tissues have different sequencing techniques

df %>%
  filter( !is.na(SMATSSCR) ) %>%
  group_by(SMATSSCR) %>%
  summarize(n())
  
# 3554 subjects have a smatsscr score of 0
# the majority of subjects have a mean score of 1
# Histogram or bar graph

