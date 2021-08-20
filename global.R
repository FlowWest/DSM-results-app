library(shiny)
library(shinycssloaders)
library(shinythemes)
library(tidyverse)
library(plotly)
library(stringr)
library(DT)
library(DSMscenario)

source('modules/fall_run_server.R')
source('modules/spring_run_server.R')
# Load scenario dataframe
scenario_data <- read_rds('data/scenario_data.rds')
colors <- c("#85D4E3", "#F4B5BD", "#9C964A", "#CDC08C", "#FAD77B")

# TODO fix these to reflect new names/descriptions (Need 13)
descriptions <- c(
  "Restoration limited to in-channel Upper Sacramento, Butte, Lower Mid Sac, Feather, American, Deer, Battle. and Stanislaus",
  "Restoration limited to in-channel Upper Sacramento, Butte, Lower Mid Sac, Feather, American, Deer, Clear, and Stanislaus",
  "Restoration limited to in-channel Upper Sacramento, Butte, Lower Mid Sac, Feather, American, Mokelumne, Clear, and Stanislaus",
  "Restoration limited to in-channel in Mainstem Sacramento only",
  "Restoration limited to in-channel Upper Sac, Lower Mid Sac, Cow Creek and Clear",
  "Restoration limited to in-channel Upper Sac, Lower Mid, and American with some maintenance in Clear and Butte",
  "Restoration limited to floodplain Upper Sac, Upper Mid, Lower Mid, Lower Sac, and San Joaquin",
  "Restoration optimized to increase Winter-run population every year (limited to locations where WR occur)",
  "Restoration optimized to increase Spring-run population every year (limited to locations where SR occur)",
  "Restoration limited to in-channel equally distributed between Upper Mid, Deer, Butte, Clear, Mill, Battle, Antelope",
  "Restoration optimized to increase Fall-run population every year (one action in each diversity group)",
  "Restoration optimized to increase Fall-run population every year (one action in each diversity group)",
  "Restoration optimized to increase Fall-run population every year (actions limited to Upper Sac, Lower Sac, American, Stanislaus, and Mokelumne)"
)

scenario_names <- c('In-Channel Only - Urkov', 'In-Channel Only - Brown', 'In-Channel Only - Bilski', 
           'In-Channel Only - Mainstem Sac', 'In-Channel Only - Berry', 'In-Channel Only - Peterson', 
           'Floodplain Only - Mainstem Sac', 'Winter-run Optimized',
           'Spring-run Optimized', 'Spring-run In-Channel - Philips',
           'Fall-run Diversity Group Optimized', 'Fall-run Optimized - Beakes',
           'Fall-run Optimized - Bilski')

percent_change <- tibble(
  `Scenario Name` = rep(scenario_names, 3), 
  `Description` = rep(descriptions, 3),
  `Natural Spawners` = paste0(round(runif(39) * 100), "%"),
  `Juvenile Biomass` = paste0(round(runif(39) * 100), "%"),
  `Run` = c(rep("Fall Run", 13), rep("Spring Run", 13), rep("Winter Run", 13))
)
# spring_percent_change <- tibble(
#   # `Scenario Number ` = 1:13,
#   `Scenario Name` = rep("Scenario X", 13), 
#   `Natural Spawners` = paste0(round(runif(13) * 100), "%"),
#   `Juvenile Biomass` = paste0(round(runif(13) * 100), "%")
# )
# winter_percent_change <- tibble(
#   # `Scenario Number ` = 1:13,
#   `Scenario Name` = rep("Scenario X", 13), 
#   `Natural Spawners` = paste0(round(runif(13) * 100), "%"),
#   `Juvenile Biomass` = paste0(round(runif(13) * 100), "%")
# )
# 
scenario_numbers <- c('One', 'Two', 'Three',
                      'Four', 'Five', 'Six',
                      'Seven', 'Eight', 'Nine',
                      'Ten', 'Eleven', 'Twelve',
                      'Thirteen')
names(scenario_names) <- scenario_numbers
names(descriptions) <- scenario_numbers
