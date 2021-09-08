library(DSMscenario)
library(tidyverse)
library(readxl)
# DSM Results Data -------------------------------------------------------------
# Fall Run
fall_run_results <- read_excel('data-raw/2021_fall-run-simulation-results.xlsx', sheet = "Fall-run_Summary", skip = 1) %>% 
  gather(Metric, Value, -Strategy) %>% 
  transmute(strategy = Strategy, 
            metric = Metric, 
            value = Value,
            run = "Fall",
            version = 2021)
# Spring Run 
spring_run_results <- read_excel('data-raw/2021_spring-run-simulation-results.xlsx', sheet = "Spring-run_Summary", skip = 1) %>% 
  gather(Metric, Value, -Strategy) %>% 
  transmute(strategy = Strategy, 
            metric = Metric, 
            value = Value,
            run = "Spring",
            version = 2021)
# Winter Run 
winter_run_results <- read_excel('data-raw/2021_winter-run-simulation-results.xlsx', sheet = "Winter-run_Summary", skip = 1) %>% 
  gather(Metric, Value, -Strategy) %>% 
  transmute(strategy = Strategy, 
            metric = Metric, 
            value = Value,
            run = "Winter",
            version = 2021)
# TODO add Late Fall Run Results 

# TODO add in real 2019 
dsm_results_2019 <- bind_rows(fall_run_results, spring_run_results, winter_run_results) %>%
  mutate(version = 2019)

# Combine 2021 data
dsm_results_2021 <- bind_rows(fall_run_results, spring_run_results, winter_run_results)

# Combine 2019 and 2021 data
dsm_results <- bind_rows(dsm_results_2019, dsm_results_2021)
write_rds(dsm_results, "data/dsm_results.rds")

# Strategies -------------------------------------------------------------------
# Create strategies 
create_scenario_df <- function(number) {
  scenario <- bind_rows(
    as_tibble(scenarios[[number]]$spawn) %>% 
      mutate(watershed = factor(DSMscenario::watershed_labels, levels = DSMscenario::watershed_labels),
             action_type = "spawn"),
    as_tibble(scenarios[[number]]$inchannel) %>% 
      mutate(watershed = factor(DSMscenario::watershed_labels, levels = DSMscenario::watershed_labels),
             action_type = "inchannel"),
    as_tibble(scenarios[[number]]$floodplain) %>% 
      mutate(watershed = factor(DSMscenario::watershed_labels, levels = DSMscenario::watershed_labels),
             action_type = "floodplain"),
    as_tibble(scenarios[[number]]$survival) %>% 
      mutate(watershed = factor(DSMscenario::watershed_labels, levels = DSMscenario::watershed_labels),
             action_type = "survival")
  ) %>% 
    gather(year, units_of_effort, -action_type, -watershed)  %>% 
    mutate(units_of_effort = ifelse(is.na(units_of_effort), 0, units_of_effort),
           scenario = number)  
}
nums = c("ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", 
         "TEN", "ELEVEN", "TWELVE", "THIRTEEN")
scenario_data <- purrr::map_df(nums, create_scenario_df)

write_rds(scenario_data, "data/scenario_data.rds")
