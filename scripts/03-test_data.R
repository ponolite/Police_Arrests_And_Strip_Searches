#### Preamble ####
# Purpose: Tests cleaned datasets 
# Author: Quang Mai
# Date: 24 January 2024
# Contact: q.mai@mail.utoronto.ca
# License: MIT
# Pre-requisites: reload 01-download_data.R and 02-data_cleaning.R

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(janitor)


#### Read in cleaned data ####


# read cleaned data on race and gender and strip searches
cleaned_race_gender_data = read_csv(
  file = here("inputs/data/cleaned_race_gender_data.csv"),
  show_col_types = FALSE
)

# read cleaned data on reasons for strip search
cleaned_search_reasons_data = read_csv(
  file = here("inputs/data/cleaned_search_reasons_data.csv"),
  show_col_types = FALSE
)


#### Test data ####

test1

# Check that there are between 1 and 65276 events of police arrests and strip searches in the cleaned dataset on gender and race 
cleaned_race_gender_data$event |> min() == 1
cleaned_race_gender_data$event |> max() == 65276

test2

# Check that the dataset on race and gender of strip searches prolongs from 2020 to 2021 
cleaned_race_gender_data$arrest_year |> min() == 2020
cleaned_race_gender_data$arrest_year |> max() == 2021

test3

# Check that there are 9 races identified in the cleaned dataset on gender, race and strip search
cleaned_race_gender_data$race |> unique() |> length() == 9

test4

# Check that there are 3 gender identities identified in the cleaned dataset on gender, race and strip search
cleaned_race_gender_data$gender |> unique() |> length() == 3

test5

# Check that there are exactly 2 options of "Yes" and "No" for strip searches #
cleaned_race_gender_data$strip_search |> unique() |> length() == 2

tes6

# Check that there are 7801 observations in the cleaned dataset on reasons for strip search
cleaned_search_reasons_data$id |> unique() |> length() == 7801

test7
# Check that there are maximum 4 total reasons and minimum 0 total reasons in the cleaned dataset on reasons for strip search
cleaned_search_reasons_data$total_reasons |> min() == 0
cleaned_search_reasons_data$total_reasons |> max() == 4


test8
# Check that there are only arrests with strip searches in the cleaned dataset on reasons for strip search
cleaned_search_reasons_data$total_reasons |> unique |> length() >= 0


