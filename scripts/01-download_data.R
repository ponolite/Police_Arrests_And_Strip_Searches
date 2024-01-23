#### Preamble ####
# Purpose: Downloads dataset of police arrests and strip searches throughout Toronto 
# Author: Quang Mai
# Date: 21 January 2024 
# Contact: q.mai@mail.utoronto.ca
# License: MIT
# Pre-requisites: none


#### Workspace setup ####
library(opendatatoronto)
library(dplyr)
library(tidyverse)


#### Download data ####
#From https://open.toronto.ca/dataset/police-race-and-identity-based-data-collection-arrests-strip-searches/

# download data package 

package <- show_package("police-race-and-identity-based-data-collection-arrests-strip-searches")
package

resources <- list_package_resources("police-race-and-identity-based-data-collection-arrests-strip-searches")
resources

# this package has only one dataset within it and must be selected by default

raw_police_arrests_strip_data <- get_resource(resource ="78ef6b68-7a88-47f9-9dab-a0f00f5d8b0d")
raw_police_arrests_strip_data 


#### Save Data ####

write_csv (
         x = raw_police_arrests_strip_data, 
         file = "inputs/data/raw_police_arrests_strip_data.csv"
)
         
