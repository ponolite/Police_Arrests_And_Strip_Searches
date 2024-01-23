#### Preamble ####
# Purpose: Simulates dataset of police arrests and strip searches throughout Toronto 
# Author: Quang Mai
# Date: 21 January 2024 
# Contact: q.mai@mail.utoronto.ca
# License: MIT

#### Data Expectations ####
# Number of arrest events divided by gender and race
# Expect different types of clinics, like city-run, hospital, pharmacy, pop-ups
# Opening date should be a valid date before today
# columns: clinic_id, district, type, opening_date

#### Workspace setup ####
library(tidyverse)
library(janitor)


#### Simulate the victim's gender, racial identity and the strip-search nature of each police arrest event ####
# Code referenced from from: https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html#simulate

set.seed(56) #ensure simulated data's reproducibility

simulated_data <-
  tibble(
    #use 1 through 65276 to represent each event
    "event" = 1:65276,
    #randomly pick a race identified from the dataset, with replacement, 65276 times
    "race" = sample(
      x = c("White", "Unknown or Legacy", "Black", "South Asian", "Indigenous", "Middle-Eastern", "Latino", "East/Southeast Asian", "None"),
      size = 65276,
      replace = TRUE
    ),
    #randomly pick one gender identity identified from the dataset, with replacement, 65276 times
    "sex" = sample(
      x = c("Male", "Female", "Unidentified"),
      size = 65276,
      replace = TRUE
    ),
    #randomly pick whether the event includes strip search, with replacement, 65276 times
    "strip_search" = sample(
      x = c("Yes", "No"),
      size = 65276,
      replace = TRUE
    )
)

simulated_data

#add a new items_found column to those events with strip search, with replacement, 32717 times (32717 is based on the set.seed() number)

set.seed(56)

simulated_data_items <-
  simulated_data |>
  filter(strip_search == "Yes") |>
  mutate(
    "items_found" = sample(
      x = c("Yes", "No"),
      size = 32717,
      replace = TRUE
    )
  )

#### Summarize the victim's gender identity of each police arrest event ####

set.seed(56)

gender_per_event = 
  simulated_data |>
  group_by(sex, strip_search) |>
  count() |>
  rename(number_of_arrests = n)

gender_per_event
  
#### Summarize the victim's racial identity of each police arrest event ####

set.seed(56)

race_per_event = 
  simulated_data |>
  group_by(race, strip_search) |>
  count() |>
  rename(number_of_arrests = n)

race_per_event
  
#### Summarize whether each police arrest event contains strip search ####

set.seed(56)

strip_search_per_event = 
  simulated_data |>
  group_by(strip_search) |>
  count() |>
  rename(number_of_arrests = n)

strip_search_per_event


#### Create histograms and graphs ####

# Barplot of racial identity
ggplot(race_per_event, aes(x=race, y=number_of_arrests)) + 
  geom_bar(stat = "identity") 

# Barplot of gender identity
ggplot(gender_per_event, aes(x=sex, y=number_of_arrests)) + 
  geom_bar(stat = "identity") 

# Barplot of strip search against racial identity, where each racial identity of each arrest is divided into including strip search or not
# Code referenced from https://github.com/TDonofrio62/Shooting-Occurrences-in-Toronto/blob/main/Shooting_Occurrences/outputs/paper/Shooting_Occurrences.Rmd
race_per_event |>
  ggplot(aes(x = race, y = number_of_arrests, fill = strip_search)) + 
  geom_bar(stat="identity") + 
  theme_bw() +
  theme(legend.key.size = unit(0.5, 'cm')) +
  labs(x = "Sex",
       y = "Number of Arrests",
       fill = "Strip Search"
  ) +
  scale_fill_viridis_d(option="turbo") 

# Barplot of strip search against gender identity, where each gender identity of each arrest is divided into including strip search or not
# Code referenced from https://github.com/TDonofrio62/Shooting-Occurrences-in-Toronto/blob/main/Shooting_Occurrences/outputs/paper/Shooting_Occurrences.Rmd
gender_per_event |>
  ggplot(aes(x = sex, y = number_of_arrests, fill = strip_search)) + 
  geom_bar(stat="identity") + 
  theme_minimal() +
  theme(legend.key.size = unit(0.5, 'cm')) +
  labs(x = "Sex",
       y = "Number of Arrests",
      fill = "Strip Search"
    ) +
    scale_fill_viridis_d(option="turbo") 



#### Data Validation ####

# Code referenced from: https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html

# Check that there are between 1 and 65276 events of police arrests and strip searches #
simulated_data$event |> min() == 1
simulated_data$event |> max() == 65276

# Check that there are no more than 65276 events #
simulated_data |>
  group_by(event) |>
  count() |>
  filter(n > event) |>
  sum() == 0


# Check that there are exactly 9 races identified #
simulated_data$race |> unique() |> length() == 9

# Check that there are exactly 3 gender identities identified #
simulated_data$sex |> unique() |> length() == 3

# Check that there are exactly 2 options for strip searches #
simulated_data$strip_search |> unique() |> length() == 2


