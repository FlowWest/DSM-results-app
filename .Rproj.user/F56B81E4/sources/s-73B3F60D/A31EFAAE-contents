# Create scenarios 
library(DSMscenario)

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
