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
# Code of function replace_with_na referenced from https://tidyr.tidyverse.org/reference/replace_na.html

# Clean from the raw dataset
raw_police_arrests_strip_data <- read_csv("inputs/data/raw_police_arrests_strip_data.csv")

cleaned_arrests_strip_data <-
  raw_police_arrests_strip_data |>
  janitor::clean_names() |> #clean and simplify variable names 
  select(-c(x_id, arrest_id, person_id, object_id, booked)) |> # Get rid of unnecessary variables
  rename(action_concealed = actions_at_arrest_concealed_i, # Shorten variable names to make them readable
         action_combative = actions_at_arrest_combative,
         action_resisted = actions_at_arrest_resisted_d,
         action_mental_inst = actions_at_arrest_mental_inst,
         action_assaulted = actions_at_arrest_assaulted_o,
         action_cooperative = actions_at_arrest_cooperative,
         reason_injury = search_reason_cause_injury,
         reason_escape = search_reason_assist_escape,
         reason_weapons = search_reason_possess_weapons,
         reason_possess_evidence = search_reason_possess_evidence,
         race = perceived_race,
         age_group = age_group_at_arrest,
         gender = sex
         ) |> 
  relocate(event_id) |> # Put the event_id column to be the first one in the dataset
  naniar::replace_with_na(replace = list(reason_injury = c("None"), # Replace the string 'None' with NA to make it easier to manipulate data later on
                                 reason_escape = c("None"),
                                 reason_weapons = c("None"),
                                 reason_has_evidence = c("None")))

# Replace all "XX" and "None" from the columns arrest_loc_div and items_found with NA and NA respectively to make the data processing more efficient later on
# Code referenced from https://www.youtube.com/watch?v=g1eppE60J5g
cleaned_arrests_strip_data$items_found[cleaned_arrests_strip_data$items_found == "None"] <- NA
cleaned_arrests_strip_data$arrest_loc_div[cleaned_arrests_strip_data$arrest_loc_div == "XX"] <- NA

# Clean from the cleaned dataset, to keep the a dataset of variables like event_id, race, gender, age_group, strip search and items_found

cleaned_race_gender_data = 
  cleaned_arrests_strip_data |>
  select(event_id, race, gender, strip_search, items_found)

# Clean from the cleaned dataset, to keep a dataset of variables like reasons for strip searching

cleaned_search_reasons_data = 
  cleaned_arrests_strip_data |>
  select(event_id, reason_injury,	reason_escape, reason_weapons, reason_possess_evidence) |>
  filter(!is.na(reason_injury))


  cleaned_arrests_strip_data |>
  select(event_id, reason_injury,	reason_escape, reason_weapons, reason_possess_evidence, items_found) |>
  filter(reason_injury == 0 & reason_escape == 0 & reason_weapons == 0 & reason_possess_evidence == 0)

#### Save data ####
write_csv(cleaned_arrests_strip_data,"inputs/data/cleaned_arrests_strip_data.csv")
write_csv(cleaned_race_gender_data,"inputs/data/cleaned_race_gender_data.csv")
write_csv(cleaned_search_reasons_data,"inputs/data/cleaned_search_reasons_data.csv")