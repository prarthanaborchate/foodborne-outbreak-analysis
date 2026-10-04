library(tidyverse)
library(skimr)
library(janitor)
library(corrplot)

foodborne <- read.csv(file.choose())
head(foodborne)
summary(foodborne)
skim(foodborne)
# Here I check what % of my values are missing
sapply(foodborne, function(x) sum(is.na(x)) / length(x) * 100)
#IdentificationtoManagerInterview..days.=14.379085% This has highest missing data
#Now checking how many duplicate rows I have
nrow(foodborne) - nrow(distinct(foodborne))
#To preserve our original data set I will dupilicate it to a raw set. 
foodborne_raw <- foodborne 
# Recreate clean copy from raw data so recoding starts from original values
foodborne_clean <- foodborne_raw %>%
  clean_names() %>%
  mutate(
    food_identified = if_else(food_identified == "true", "Yes", "No"),
    agent_identified = if_else(agent_identified == "true", "Yes", "No"),
    contributing_factor_identified =
      if_else(contributing_factor_identified == "true", "Yes", "No"),
    
    identificationto_first_contact_days = case_when(
      identificationto_first_contact_days == 1 ~ "Same day",
      identificationto_first_contact_days == 2 ~ "1-2 days",
      identificationto_first_contact_days == 3 ~ "3+ days"
    ),
    
    identificationto_manager_interview_days = case_when(
      identificationto_manager_interview_days == 1 ~ "Same day",
      identificationto_manager_interview_days == 2 ~ "1-2 days",
      identificationto_manager_interview_days == 3 ~ "3+ days"
    ),
    
    identificationto_observation_days = case_when(
      identificationto_observation_days == 1 ~ "Same day",
      identificationto_observation_days == 2 ~ "1-2 days",
      identificationto_observation_days == 3 ~ "3+ days"
    ),
    
    onsetto_identification_days = case_when(
      onsetto_identification_days == 1 ~ "Same day",
      onsetto_identification_days == 2 ~ "1-2 days",
      onsetto_identification_days == 3 ~ "3+ days"
    )
  )
# Now I look at the categorical data 
unique(foodborne_clean$food_identified)
unique(foodborne_clean$agent_identified)
unique(foodborne_clean$contributing_factor_identified)

unique(foodborne_clean$establishment_type)
unique(foodborne_clean$sample_type)
unique(foodborne_clean$epidemiology_investigation_method)
summary(foodborne_clean$visitsfor_environmental_assessment)
#Check frequency of categorical variables
table(foodborne_clean$food_identified, useNA = "ifany")
table(foodborne_clean$agent_identified, useNA = "ifany")
table(foodborne_clean$contributing_factor_identified, useNA = "ifany")

table(foodborne_clean$establishment_type, useNA = "ifany")
table(foodborne_clean$sample_type, useNA = "ifany")
table(foodborne_clean$epidemiology_investigation_method, useNA = "ifany")
# Check recoded timing variables
table(foodborne_clean$identificationto_first_contact_days, useNA = "ifany")
table(foodborne_clean$identificationto_manager_interview_days, useNA = "ifany")
table(foodborne_clean$identificationto_observation_days, useNA = "ifany")
table(foodborne_clean$onsetto_identification_days, useNA = "ifany")
table(foodborne_clean$food_identified)
table(foodborne_clean$agent_identified)
table(foodborne_clean$contributing_factor_identified)
#Now I get the Yes/no in percentages. 
prop.table(table(foodborne_clean$food_identified)) * 100
prop.table(table(foodborne_clean$agent_identified)) * 100
prop.table(table(foodborne_clean$contributing_factor_identified)) * 100

#Begin Analysis

# Food identification by sample type
table(
  foodborne_clean$sample_type,
  foodborne_clean$food_identified
)
# Agent identification by sample type
table(
  foodborne_clean$sample_type,
  foodborne_clean$agent_identified
)
# Contributing factor identification by sample type
table(
  foodborne_clean$sample_type,
  foodborne_clean$contributing_factor_identified
)
# Now convert counts to row percentages
prop.table(
  table(
    foodborne_clean$sample_type,
    foodborne_clean$food_identified
  ),
  margin = 1
) * 100
# Agent identification by sample type
prop.table(
  table(
    foodborne_clean$sample_type,
    foodborne_clean$agent_identified
  ),
  margin = 1
) * 100
# Contributing factor identification by sample type
prop.table(
  table(
    foodborne_clean$sample_type,
    foodborne_clean$contributing_factor_identified
  ),
  margin = 1
) * 100

#Now working on epidemiological questions
# Food identification by epidemiology investigation method
#Comparing type of epi investigation to whether the investigation successfully identified each oitcome. 
# Here I am trying to see rying to see whether some methods appear to be associated with better identification success than others.
table(
  foodborne_clean$epidemiology_investigation_method,
  foodborne_clean$food_identified
)
prop.table(
  table(
    foodborne_clean$epidemiology_investigation_method,
    foodborne_clean$food_identified
  ),
  margin = 1
) * 100
# Agent identification by epidemiology investigation method
table(
  foodborne_clean$epidemiology_investigation_method,
  foodborne_clean$agent_identified
)

prop.table(
  table(
    foodborne_clean$epidemiology_investigation_method,
    foodborne_clean$agent_identified
  ),
  margin = 1
) * 100
# Contributing factor identification by epidemiology investigation method
table(
  foodborne_clean$epidemiology_investigation_method,
  foodborne_clean$contributing_factor_identified
)

prop.table(
  table(
    foodborne_clean$epidemiology_investigation_method,
    foodborne_clean$contributing_factor_identified
  ),
  margin = 1
) * 100

# Test whether sample type is associated with food identification
chisq.test(
  table(
    foodborne_clean$sample_type,
    foodborne_clean$food_identified
  )
)
# Test whether sample type is associated with agent identification
chisq.test(
  table(
    foodborne_clean$sample_type,
    foodborne_clean$agent_identified
  )
)
# Test whether sample type is associated with contributing factor identification
chisq.test(
  table(
    foodborne_clean$sample_type,
    foodborne_clean$contributing_factor_identified
  )
)
#Fisher's exact test to confirm statistically significant
# Fisher's exact test used: because the chi-square test
# reported small expected cell counts
fisher.test(
  table(
    foodborne_clean$sample_type,
    foodborne_clean$agent_identified
  )
)
# Test whether epidemiology investigation method is associated
# with food identification
chisq.test(
  table(
    foodborne_clean$epidemiology_investigation_method,
    foodborne_clean$food_identified
  )
)
# Test whether epidemiology investigation method is associated
# with agent identification
chisq.test(
  table(
    foodborne_clean$epidemiology_investigation_method,
    foodborne_clean$agent_identified
  )
)
# Test whether epidemiology investigation method is associated
# with contributing factor identification
chisq.test(
  table(
    foodborne_clean$epidemiology_investigation_method,
    foodborne_clean$contributing_factor_identified
  )
)
# Fisher's exact test used because the chi-square test
# reported small expected cell counts
fisher.test(
  table(
    foodborne_clean$epidemiology_investigation_method,
    foodborne_clean$agent_identified
  )
)
# Agent identification by timing of first contact
table(
  foodborne_clean$identificationto_first_contact_days,
  foodborne_clean$agent_identified
)

prop.table(
  table(
    foodborne_clean$identificationto_first_contact_days,
    foodborne_clean$agent_identified
  ),
  margin = 1
) * 100

#my research question: Which investigation characteristics are associated with successful 
#identification of the agent in foodborne outbreak investigations reported to CDC NEARS from 2014–2016?

# Agent identification by timing of first contact
table(
  foodborne_clean$identificationto_first_contact_days,
  foodborne_clean$agent_identified
)

prop.table(
  table(
    foodborne_clean$identificationto_first_contact_days,
    foodborne_clean$agent_identified
  ),
  margin = 1
) * 100


# Agent identification by number of environmental assessment visits
table(
  foodborne_clean$visitsfor_environmental_assessment,
  foodborne_clean$agent_identified
)

prop.table(
  table(
    foodborne_clean$visitsfor_environmental_assessment,
    foodborne_clean$agent_identified
  ),
  margin = 1
) * 100

foodborne_clean <- foodborne_clean %>%
  mutate(
    environmental_assessment_visit = if_else(
      visitsfor_environmental_assessment == 0,
      "No visits",
      "1+ visits"
    )
  )
table(
  foodborne_clean$environmental_assessment_visit,
  foodborne_clean$agent_identified
)

prop.table(
  table(
    foodborne_clean$environmental_assessment_visit,
    foodborne_clean$agent_identified
  ),
  margin = 1
) * 100
chisq.test(
  table(
    foodborne_clean$environmental_assessment_visit,
    foodborne_clean$agent_identified
  )
)
# Visualization 1: Agent identification by sample type

sample_plot <- foodborne_clean %>%
  group_by(sample_type) %>%
  summarise(
    agent_identification_rate = mean(agent_identified == "Yes") * 100
  )

sample_colors <- c(
  "Both" = "#0072B2",
  "Clinical" = "#009E73",
  "Environmental" = "#E69F00",
  "None" = "#D55E00"
)

ggplot(
  sample_plot,
  aes(
    x = sample_type,
    y = agent_identification_rate,
    fill = sample_type
  )
) +
  geom_col() +
  geom_text(
    aes(label = paste0(round(agent_identification_rate, 1), "%")),
    vjust = -0.5
  ) +
  scale_fill_manual(values = sample_colors) +
  labs(
    title = "Agent Identification by Sample Type",
    x = "Sample Type",
    y = "Agent Identification (%)"
  ) +
  ylim(0, 105) +
  theme_minimal() +
  guides(fill = "none")
ggsave(
  "agent_identification_by_sample_type.png",
  width = 8,
  height = 5,
  dpi = 300
)


# Visualization 2: Agent identification by environmental assessment visit

visit_plot <- foodborne_clean %>%
  group_by(environmental_assessment_visit) %>%
  summarise(
    agent_identification_rate = mean(agent_identified == "Yes") * 100
  )

visit_colors <- c(
  "No visits" = "#D55E00",
  "1+ visits" = "#0072B2"
)
ggplot(
  visit_plot,
  aes(
    x = environmental_assessment_visit,
    y = agent_identification_rate,
    fill = environmental_assessment_visit
  )
) +
  geom_col() +
  geom_text(
    aes(label = paste0(round(agent_identification_rate, 1), "%")),
    vjust = -0.5
  ) +
  scale_fill_manual(values = visit_colors) +
  labs(
    title = "Agent Identification by Environmental Assessment Visit",
    x = "Environmental Assessment Visit",
    y = "Agent Identification (%)"
  ) +
  ylim(0, 105) +
  theme_minimal() +
  guides(fill = "none")
ggsave(
  "agent_identification_by_environmental_visit.png",
  width = 8,
  height = 5,
  dpi = 300
)
