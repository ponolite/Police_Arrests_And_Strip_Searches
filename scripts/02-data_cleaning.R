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
  select(-c(event_id, arrest_id, person_id, object_id, youth_at_arrest_under_18_years, arrest_loc_div, booked, actions_at_arrest_concealed_i, actions_at_arrest_combative, actions_at_arrest_resisted_d, actions_at_arrest_mental_inst, actions_at_arrest_assaulted_o, actions_at_arrest_cooperative)) |> # Get rid of unnecessary variables
  rename(
         reason_injury = search_reason_cause_injury, # Shorten variable names to make them readable
         reason_escape = search_reason_assist_escape,
         reason_weapons = search_reason_possess_weapons,
         reason_possess_evidence = search_reason_possess_evidence,
         race = perceived_race,
         gender = sex,
         id=x_id
         ) |> 
  naniar::replace_with_na(replace = list(reason_injury = c("None"), # Replace the string 'None' with NA to make it easier to manipulate data later on
                                 reason_escape = c("None"),
                                 reason_weapons = c("None"),
                                 reason_possess_evidence = c("None")))

# Replace all "None" from the column items_found with "NA" to make the data processing more efficient later on
# Code referenced from https://www.youtube.com/watch?v=g1eppE60J5g
cleaned_arrests_strip_data$items_found[cleaned_arrests_strip_data$items_found == "None"] <- NA

# Replace all "NA" and "1" from the column strip_search with "No" and "Yes" respectively to make the data clearer later on
cleaned_arrests_strip_data$strip_search[cleaned_arrests_strip_data$strip_search == 1] <- "Yes"
cleaned_arrests_strip_data$strip_search[is.na(cleaned_arrests_strip_data$strip_search)] <- "No"

# Clean from the cleaned dataset, to keep the a dataset of variables like event_id, race, gender, age_group, strip search and items_found

cleaned_race_gender_data = 
  cleaned_arrests_strip_data |>
  select(id, race, gender, strip_search, items_found)

# Clean from the cleaned dataset, to keep a dataset of variables like reasons for strip searching
# Code for as.numeric() referenced from https://stackoverflow.com/questions/31415344/using-as-numeric-with-functions-and-pipes-in-r
cleaned_search_reasons_data = 
  cleaned_arrests_strip_data |>
  select(id, race, gender, reason_injury,	reason_escape, reason_weapons, reason_possess_evidence, items_found) |>
  filter(!is.na(reason_injury)) |> # Filter out all instances of arrests without strip searches
  mutate(
    reason_injury = as.numeric(reason_injury), # Turn '1' and '0' into numerica data type
    reason_escape = as.numeric(reason_escape),
    reason_weapons = as.numeric(reason_weapons),
    reason_possess_evidence = as.numeric(reason_possess_evidence),
    total_reasons = reason_injury + reason_escape + reason_weapons + reason_possess_evidence) # Tally up the total number of reasons for each strip search


#### Save data ####
write_csv(cleaned_arrests_strip_data,"inputs/data/cleaned_arrests_strip_data.csv")
write_csv(cleaned_race_gender_data,"inputs/data/cleaned_race_gender_data.csv")
write_csv(cleaned_search_reasons_data,"inputs/data/cleaned_search_reasons_data.csv")