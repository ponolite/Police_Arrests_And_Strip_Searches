#### Preamble ####
# Purpose: Tests cleaned data sets 
# Author: Thomas Fox 
# Date: 25 January 2024
# Contact: thomas.fox@mail.utoronto.ca
# License: MIT
# Pre-requisites: run 01-download_data.R and 02-data_cleaning.R
# Any other information needed? If nothing is printed, all tests have passed


#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(janitor)

#### Load Cleaned Data Sets ####

# read cleaned child care data
test_child_care = read_csv(
  file = "outputs/data/child_care_data.csv",
  show_col_types = FALSE
)

# read cleaned census data
test_census_data = read_csv(
  file = "outputs/data/census_data.csv",
  show_col_types = FALSE
)

# read cleaned merged child care/census data
test_census_childcare_data = read_csv(
  file = "outputs/data/merged_ward_data.csv",
  show_col_types = FALSE
)

# read ward names
test_ward_names = read_csv(
  file = "outputs/data/ward_names.csv",
  show_col_types = FALSE
)


#### Test data ####

# Test cleaned child care data 

if (nrow(test_child_care) != 1063) {
  print("Size of child care data is incorrect ")
}

if (min(test_child_care$totspace) < 0) {
  print("Negative number in child care data total space column")
}

if (min(test_child_care$ward) <= 0) {
  print("A ward number is below the limits ward number limit (1-25)")
}

if (max(test_child_care$ward) > 25) {
  print("A ward number is above the ward number limit (1-25)")
}

# Test cleaned child care data 

if (nrow(test_census_data) != 25) {
  print("Number of ward entries is incorrect")
}

if (min(test_census_data$avg_hh_income) < 0) {
  print("Negative number in average house hold income column")
}

if (min(test_census_data$pop_0_to_4) < 0) {
  print("Negative number in population 0 to 4 column")
}

if (min(test_census_data$ward) <= 0) {
  print("A ward number is below the limits ward number limit (1-25)")
}

if (max(test_census_data$ward) > 25) {
  print("A ward number is above the ward number limit (1-25)")
}


# Test merged cleaned child care and census data 

if (nrow(test_census_childcare_data) != 25) {
  print("Number of ward entries is incorrect")
}

if (min(test_census_childcare_data$ward) <= 0) {
  print("A ward number is below the limits ward number limit (1-25)")
}

if (max(test_census_childcare_data$ward) > 25) {
  print("A ward number is above the ward number limit (1-25)")
}

if (min(test_census_childcare_data$avg_hh_income) < 0) {
  print("Negative number in average house hold income column")
}

if (min(test_census_childcare_data$pop_0_to_4) < 0) {
  print("Negative number in population 0 to 4 column")
}

# Test ward names 

if (nrow(test_ward_names) != 25) {
  print("Number of ward entries is incorrect")
}

if (class(test_ward_names$ward_name) != "character") {
  print("Ward names is not a character")
}

if (class(test_ward_names$ward_number) != "numeric") {
  print("Ward numbers are not numeric")
}



