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
dsm_results_2019 <- read_excel('data-raw/NTRS utilities.xlsx', sheet = "Utilities") %>% 
  mutate(strategy = paste0("Strategy 0", `Strategy...1`),
         strategy = case_when(strategy == "Strategy 00" ~ "Baseline",
                              strategy == "Strategy 010" ~ "Strategy 10",
                              strategy == "Strategy 011" ~ "Strategy 11",
                              strategy == "Strategy 012" ~ "Strategy 12",
                              strategy == "Strategy 013" ~ "Strategy 13",
                              T ~ strategy)) %>%
  select(-c(`Strategy...1`,`Strategy...5`)) %>%
  pivot_longer(Fall:`U(Spring)`,
               names_to = "run") %>%
  mutate(metric = case_when(grepl("U", run) ~ "Natural Production Utility Score",
                            T ~ "Total Natural Production"),
         run = case_when(run == "U(fall)" ~ "Fall",
                         run == "U(Winter)" ~ "Winter",
                         run == "U(Spring)" ~ "Spring",
                         T ~ run),
         version = 2019)
  
# dsm_results_2019 <- bind_rows(fall_run_results, spring_run_results, winter_run_results) %>%
#   mutate(version = 2019)

# Combine 2021 data
dsm_results_2021 <- bind_rows(fall_run_results, spring_run_results, winter_run_results) 

order <- rev(c(
  "Baseline",
  "Strategy 01",
  "Strategy 02",
  "Strategy 03",
  "Strategy 04",
  "Strategy 05",
  "Strategy 06",
  "Strategy 07",
  "Strategy 08",
  "Strategy 09",
  "Strategy 10",
  "Strategy 11",
  "Strategy 12",
  "Strategy 13" 
))
# Combine 2019 and 2021 data
dsm_results <- bind_rows(dsm_results_2019, dsm_results_2021) %>%
  mutate(strategy = factor(strategy, levels = order))

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
