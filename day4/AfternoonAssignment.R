library (tidyverse)
library(broom)

#Q1

dnm <- read_csv(file = "~/qbb2024-answers/day4/aau1043_dnm.csv")

ages <- read_csv(file = "~/qbb2024-answers/day4/aau1043_parental_age.csv")

dnm_summary <- dnm %>%
  group_by(Proband_id) %>%
  summarize(n_paternal_dnm = sum(Phase_combined == "father", na.rm = TRUE),
            n_maternal_dnm = sum(Phase_combined == "mother", na.rm = TRUE))

dnm_by_parental_age <- left_join(dnm_summary, ages, by = "Proband_id")

#Q2

ggplot(data = dnm_by_parental_age,
       mapping = aes(x = Mother_age,
                     y = n_maternal_dnm)) +
  geom_point() +
  stat_smooth(method = "lm") +
  xlab("Age of Mother") +
  ylab("Count of Maternal de Novo Mutations")

ggplot(data = dnm_by_parental_age,
       mapping = aes(x = Father_age,
                     y = n_paternal_dnm)) +
  geom_point() +
  stat_smooth(method = "lm") +
  xlab("Age of Father") +
  ylab("Count of Paternal de Novo Mutations")

maternal_stat <- lm(data = dnm_by_parental_age,
   formula = n_maternal_dnm ~ 1 + Mother_age)

# The size of the relationship between maternal age and count of maternal dnm is 0.37757
# This means that as a mother ages, the chance of maternal dnm mutations increases
# This is the same relationship that was represented in my graph
# The relationship is significant because the p value is <2e-16
# The small p value indicates that there is likely a relationship between maternal age and the count of maternal dnm

paternal_stat <- lm(data = dnm_by_parental_age,
                    formula = n_paternal_dnm ~ 1 + Father_age)

# The size of the relationship between paternal age and count of paternal dnm is  1.35384
# This means that there is a strong positive correlation between age of the father and count of paternal dnms
# Meaning, that as a father ages, the instances of paternal dnms is likely to increase
# This matches with the graph I made previously
# The relationship is significant because the p value is < 2e-16
# Because the p value is so small, it indicates that there is likely a relationship between age of the father and paternal dnms


