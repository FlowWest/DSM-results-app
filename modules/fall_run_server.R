fall_run_server <- function(input, output) {
  selected_scenario <- reactive({
    scenario_data %>% filter(scenario == toupper(input$Scenario)) 
  })
  output$percent_change_table <- DT::renderDataTable(
    fall_percent_change,
    selection = "none",
    options = list(dom = "t", pageLength = 15))
  
  output$actions_plot <- renderPlotly({
    if (input$plot_type == "Actions Applied Over Time") {
      gg <- selected_scenario() %>% 
        filter(units_of_effort > 0) %>%
        ggplot(aes(year, units_of_effort, fill = action_type)) +
        geom_col() +
        labs(x = "Year", 
             y = "Units of Effort", 
             title = paste0("Scenario ", input$Scenario)) +
        scale_y_continuous(breaks = c(0, 1, 2, 3, 4, 5)) +
        scale_fill_manual(values =  c("#00A08A", "#5BBCD6","#F2AD00", "#FF0000")) +
        facet_wrap(~watershed, ncol = 1) +
        theme_minimal()  
      height <- ifelse(input$Scenario %in% c("Eleven", "Nine"), 900, 600) # TODO figure out height of plot 9 and 11
    } else {
      plot_data <- selected_scenario() %>% 
        filter(units_of_effort > 0) %>%
        mutate(acres = ifelse(action_type == "survival", .5 * units_of_effort, 2 * units_of_effort))
      gg <- plot_data %>% 
        ggplot(aes(x = watershed, y = acres)) + 
        geom_col(aes(fill = action_type)) + 
        labs(x = "Watershed",
             y = "Total Acres",
             title = paste0("Scenario ", input$Scenario)) +
        coord_flip() +
        scale_fill_manual(values =  c("#00A08A", "#5BBCD6","#F2AD00", "#FF0000")) +
        theme_minimal()
      height <- 600
    }
    
    ggplotly(gg) %>% layout(height = height, width = 900)
  })
} 