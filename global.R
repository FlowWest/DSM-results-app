library(shiny)
library(shinycssloaders)
library(shinythemes)
library(tidyverse)
library(plotly)
library(stringr)
library(DT)
library(DSMscenario)
## DSM Results -----------------------------------------------------------------
dsm_results <- read_rds("data/dsm_results.rds")

## Strategies Data -------------------------------------------------------------
# Load strategy dataframe
strategies_data <- read_rds('data/scenario_data.rds')
colors <- c("#85D4E3", "#F4B5BD", "#9C964A", "#CDC08C", "#FAD77B")

# TODO fix these to reflect new names/descriptions (Need 13)
descriptions <- c(
  "Baseline",
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

strategy_names <- c('In-Channel Only - Urkov', 'In-Channel Only - Brown', 'In-Channel Only - Bilski', 
           'In-Channel Only - Mainstem Sac', 'In-Channel Only - Berry', 'In-Channel Only - Peterson', 
           'Floodplain Only - Mainstem Sac', 'Winter-run Optimized',
           'Spring-run Optimized', 'Spring-run In-Channel - Philips',
           'Fall-run Diversity Group Optimized', 'Fall-run Optimized - Beakes',
           'Fall-run Optimized - Bilski')

strategy_numbers <- c('One', 'Two', 'Three',
                      'Four', 'Five', 'Six',
                      'Seven', 'Eight', 'Nine',
                      'Ten', 'Eleven', 'Twelve',
                      'Thirteen')

names(strategy_names) <- strategy_numbers
# names(descriptions) <- strategy_numbers

## ---- Place holder description df -------####
strategy_numbers_b <- c("Baseline", "Strategy 01", "Strategy 02", "Strategy 03",
                        "Strategy 04", "Strategy 05", "Strategy 06", "Strategy 07",
                        "Strategy 08", "Strategy 09", "Strategy 10", "Strategy 11",
                        "Strategy 12", "Strategy 13")
strategy_desc <- as.data.frame(descriptions) %>%
  cbind(strategy_numbers_b)
