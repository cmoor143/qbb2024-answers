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

df_filtered <- df %>%
  filter( !is.na(SMATSSCR) )
mean_scores <- df_filtered %>%
  group_by(SUBJECT) %>%
  summarize(mean_SMATSSCR = mean(SMATSSCR, na.rm = TRUE))
zero_score_subjects <- mean_scores %>%
  filter(mean_SMATSSCR == 0)
# 15 subjects have a mean SMATSSCR score of 0

ggplot(mean_scores, aes(x = mean_SMATSSCR)) +
  geom_histogram(binwidth = 0.1, fill = "blue", color = "black") +
  labs(title = "Distribution of Mean SMATSSCR Scores", x = "Mean SMATSSCR", y = "Count")

# The distribution of mean SMATSSCR scores looks slightly skewed the the right
# However, the distribution is unimodal, with a peak around the score of 1
# The best way to present this information is in a histogram

