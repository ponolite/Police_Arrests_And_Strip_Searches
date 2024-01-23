#### Preamble ####
# Purpose: Clean 'Police Race and Identity Based Data - Arrests and Strip Searches' Dataset
# Author: Quang Mai
# Data: 21 January 2024
# Contact: q.mai@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # 01-download_data.R

#### Workspace setup ####

install.packages("tidyverse")
install.packages("dplyr")
install.packages("janitor")
install.packages("naniar")

library(tidyverse)
library(dplyr)
library(janitor)
library(naniar)


#### Clean data ####
raw_police_arrests_strip_data <- read_csv("inputs/data/raw_police_arrests_strip_data.csv")

cleaned_arrests_strip_data <-
  raw_police_arrests_strip_data |>
  janitor::clean_names() |>
  select(-c(event_id, arrest_id, person_id, object_id, booked)) |>
  rename(action_concealed = actions_at_arrest_concealed_i,
         action_combative = actions_at_arrest_combative,
         action_resisted = actions_at_arrest_resisted_d,
         action_mental_inst = actions_at_arrest_mental_inst,
         action_assaulted = actions_at_arrest_assaulted_o,
         action_cooperative = actions_at_arrest_cooperative,
         reason_injury = search_reason_cause_injury,
         reason_escape = search_reason_assist_escape,
         reason_weapons = search_reason_possess_weapons,
         reason_has_evidence = search_reason_possess_evidence,
         items_found = items_found
         ) |> 
  naniar::replace_with_na(replace = list(reason_injury = c("None"),
                                 reason_escape = c("None"),
                                 reason_weapons = c("None"),
                                 reason_has_evidence = c("None")))
#### Save data ####
write_csv(cleaned_arrests_strip_data,"inputs/data/cleaned_arrests_strip_data.csv")
