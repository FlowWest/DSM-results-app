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
pal <-  c("#00A08A", "#5BBCD6","#F2AD00", "#FF0000")

# 2021 descriptions form Megan Cook
descriptions <- c("Baseline strategy",
                  'Juvenile perennial habitat restoration focused in upper and lower-mid Sac River; Butte, Deer and Battle Creeks; and the Stanislaus and Feather Rivers',
                  'Juvenile perennial habitat restoration focused in upper and lower-mid Sac River; Butte, Deer and Clear Creeks; and the Stanislaus and Feather Rivers',
                  'Juvenile perennial habitat restoration focused in upper and lower-mid Sac River; Butte and Clear Creeks;  and the Stanislaus, Mokelumne, and Feather Rivers',
                  'Juvenile perennial habitat restoration focused in the mainstem Sac and San Joaquin Rivers',
                  'Juvenile perennial habitat restoration focused in upper, upper-mid, and lower-mid Sac River and Cow and Clear Creeks',
                  'Juvenile perennial habitat restoration focused in the upper and lower-mid Sac River; American River; and Clear Creeks with maintaining existing habitat in Clear and Butte Creeks and the Upper Sac River.',
                  'Juvenile seasonally-inundated habitat restoration focused in the mainstem Sacramento and San Joaquin Rivers',
                  'Optimal habitat restoration actions for winter run in the mainstem Sac with an emphasis on the Sac River below Red Bluff',
                  'Optimal habitat restoration actions for spring run in the upper-mid and lower Sac River; Battle, Butte,  Clear, Deer, Mill, and Antelope Creeks;  and the Feather River with an emphasis on the Sac River and Battle, Butte, and  Clear Creeks',
                  'Optimal habitat restoration actions for spring run in the upper-mid Sac River and Battle, Butte,  Clear, Deer, Mill, and Antelope Creeks;  and the Feather River equally allocated across tributaries',
                  'Optimal habitat restoration actions for fall run with at least one action per year in a tributary in each diversity group',
                  'Optimal habitat restoration actions for fall run in the upper and lower Sac River and the American, Stanislaus, and Calaveras Rivers equally allocated across tributaries',
                  'Optimal habitat restoration actions for fall run in the upper and lower Sac River and the American, Stanislaus, and Mokelumne Rivers equally allocated across tributaries'
                  )


## ---- Place holder description df -------####
strategy_numbers <- c("Baseline", "Strategy 01", "Strategy 02", "Strategy 03",
                        "Strategy 04", "Strategy 05", "Strategy 06", "Strategy 07",
                        "Strategy 08", "Strategy 09", "Strategy 10", "Strategy 11",
                        "Strategy 12", "Strategy 13")
strategy_desc <- as.data.frame(descriptions) %>%
  cbind(strategy_numbers_b)



