#### Preamble ####
# Purpose: Clean 'Police Race and Identity Based Data - Arrests and Strip Searches' Dataset
# Author: Quang Mai
# Data: 21 January 2024
# Contact: q.mai@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # 01-download_data.R


#### Workspace setup ####

library(tidyverse)
library(dplyr)
library(janitor)
library(naniar)


#### Clean data ####
raw_police_arrests_strip_data <- read_csv("inputs/data/raw_police_arrests_strip_data.csv")

cleaned_arrests_strip_data <-
  raw_police_arrests_strip_data |>
  janitor::clean_names() |>
  select(-c(eventid, arrestid, personid, objectid, booked)) |>
  rename(action_concealed = actions_at_arest_concealed_i,
         action_combative = actions_at_arrest_combative,
         action_resisted = actions_at_arrest_resisted_d,
         action_mental_inst = actions_at_arrest_mental_inst,
         action_assaulted = actions_at_arrest_assaulted_o,
         action_cooperative = actions_at_arrest_cooperative,
         reason_injury = searchreason_causeinjury,
         reason_escape = searchreason_assistescape,
         reason_weapons = searchreason_possessweapons,
         reason_has_evidence = searchreason_possessevidence
         items_found = itemsfound
         ) |> 
  replace_with_na(replace = list(reason_injury = c("None"),
                                 reason_escape = c("None"),
                                 reason_weapons = c("None"),
                                 reason_has_evidence = c("None")))
#### Save data ####
write_csv(cleaned_arrests_strip_data,"inputs/data/cleaned_arrests_strip_data.csv")
