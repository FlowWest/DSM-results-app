server <- function(input, output) {
  # Filter based on run and metric
  selected_results <- reactive({
      dsm_results %>% 
        filter(run == input$Run, 
               metric == input$Metric) 
  })
  # For side by side results plots 
  output$results_plot <- renderPlotly({
    p_template <- function (data, pick_col) {
      data %>%
        plot_ly(y = ~strategy, x = ~value, marker = list(color = pick_col),
                type = "bar",
                orientation = 'h',
                hoverinfo = 'text',
                source = "subset") %>%
      layout(yaxis = list(title = list(text ='')),
             xaxis = list(title = list(text ='Utility Score')),
             barmode = 'stack',
             legend = list(orientation = 'h')) %>%
      config(displayModeBar = FALSE)
    }

    annotations <- list(
      list(
        x = 0.2,
        y = 1,
        text = "2019",
        xref = "paper",
        yref = "paper",
        xanchor = "center",
        yanchor = "bottom",
        showarrow = FALSE
      ),
      list(
        x = 0.8,
        y = 1,
        text = "2021",
        xref = "paper",
        yref = "paper",
        xanchor = "center",
        yanchor = "bottom",
        showarrow = FALSE
      ))

    plot_2019 <- p_template(selected_results() %>%
      filter(version == 2019), pal[1])
    plot_2021 <- p_template(selected_results() %>%
      filter(version == 2021), pal[2])

    if (input$results_2019 == T) {
      subplot(plot_2019, plot_2021,
              margin = 0.05) %>%
        layout(title = input$Metric,
               margin(t = 0.5, b = 0),
               showlegend = F,
               annotations = annotations)
    } else {
      plot_2021 %>%
        layout(title = paste0("2021 ", input$Metric))
    }

  })
  # For stacked plots ----------------------------------------------------------
  # 2021 Plot
  # output$results_plot <- renderPlotly({
  #   selected_results() %>%
  #     filter(version == 2021) %>%
  #         plot_ly(y = ~strategy, x = ~value, marker = list(color = "blue"),
  #                 type = "bar",
  #                 orientation = 'h',
  #                 hoverinfo = 'text',
  #                 source = "subset") %>%
  #         layout(yaxis = list(title = list(text =''), xform = xform),
  #                xaxis = list(title = list(text ='Utility Score')),
  #                barmode = 'stack',
  #                legend = list(orientation = 'h'),
  #                title = paste0("2021 ", input$Metric)) %>%
  #         config(displayModeBar = FALSE)
  #   })
  # 
  # # 2019 plot
  # output$plot_2019 <- renderPlotly({
  #   if (input$results_2019 == T) {
  #     selected_results() %>%
  #       filter(version == 2019) %>%
  #       plot_ly(y = ~strategy, x = ~value, marker = list(color = "green"),
  #               type = "bar",
  #               orientation = 'h',
  #               hoverinfo = 'text',
  #               source = "subset") %>%
  #       layout(yaxis = list(title = list(text =''), xform = xform),
  #              xaxis = list(title = list(text ='Utility Score')),
  #              barmode = 'stack',
  #              legend = list(orientation = 'h'),
  #              title = paste0("2019 ", input$Metric)) %>%
  #       config(displayModeBar = FALSE)
  #   }})
  
  # Plotly Click Event 
  click_data <- reactive({
    event_data("plotly_click", source = "subset")
  })
    
  descriptions_text <- reactive({
    strategy_desc %>%
      filter(strategy_numbers %in% click_data()$y)
  })
  ## display clicked points
  output$clicked <- renderText(
    paste0("<strong>", descriptions_text()$strategy_numbers," </strong>", descriptions_text()$descriptions)
  )
  
## Strategies Server ----------------------------------------------------------- 
  selected_scenario <- reactive({
    strategies_data %>% filter(scenario == toupper(input$Scenario)) 
  })
  
  output$cumulative_acres_plot <- renderPlotly({
    watersheds_with_actions <- selected_scenario() %>%
      filter(units_of_effort > 0) %>% 
      pull(watershed) %>% 
      unique() %>% droplevels()
    
    # print(watersheds_with_actions)
    
    plot_data <- selected_scenario() %>%
      mutate(
        action_amount = case_when(
          action_type == "survival" ~ .05 * units_of_effort,
          action_type == "spawn" ~ units_of_effort,
          action_type == "inchannel" ~ 2 * units_of_effort,
          action_type == "floodplain" ~ 3 * units_of_effort)) %>% 
      group_by(watershed, action_type) %>% 
      summarise(total_action_amount = sum(action_amount),
                total_effort = sum(units_of_effort)) %>% 
      ungroup() %>% 
      filter(total_action_amount > 0) %>%
      mutate(watershed = as.character(watershed),
             action_type = factor(action_type, 
                                  levels = c("floodplain", "inchannel", "spawn", "survival")),
             total_action_amount = ifelse(action_type == "survival", 
                                          round(total_action_amount * 100, 2), 
                                          total_action_amount),
             label = ifelse(action_type == "survival", 
                            paste0(total_action_amount, "% increase"), 
                            paste(total_action_amount, "acres")))
    
    watershed_order <- which(DSMscenario::watershed_labels %in% plot_data$watershed)
    
    plot_data %>% 
      mutate(watershed = factor(watershed, 
                                levels = rev(DSMscenario::watershed_labels[watershed_order]))) %>% 
      plot_ly(y = ~watershed, x = ~total_effort, color = ~action_type, type = "bar",
              legendgroup = ~action_type, orientation = 'h', 
              hoverinfo = 'text',
              text = ~paste("Units of Effort:",total_effort,
                            "</br></br>Total Added:", label)) %>% 
      layout(yaxis = list(title = list(text ='')),
             xaxis = list(title = list(text ='')),
             showlegend = TRUE, barmode = 'stack',
             legend = list(orientation = 'h')) %>% 
      config(displayModeBar = FALSE)
  })
  
  output$watershed_input_ui <- renderUI({
    option <- selected_scenario() %>%
      filter(units_of_effort > 0) %>% 
      pull(watershed) %>% 
      unique()
    
    selectInput('watershed', 
                label = 'Select Watershed', 
                choices = option)
  })
  
  output$Watershed_graph <- renderPlotly({
    validate(need(!is.null(input$watershed), ''))
    
    d <- selected_scenario() %>% 
      filter(watershed == input$watershed) %>% 
      mutate(
        action_amount = case_when(
          action_type == "survival" ~ .05 * units_of_effort,
          action_type == "spawn" ~ units_of_effort,
          action_type == "inchannel" ~ 2 * units_of_effort,
          action_type == "floodplain" ~ 3 * units_of_effort),
        label = ifelse(action_type == "survival", 
                       paste0(action_amount, "% increase"), 
                       paste(action_amount, "acres")))  
    
    d %>% 
      plot_ly(x = ~year, y = ~units_of_effort, color = ~action_type, 
              type = "bar",
              hoverinfo = 'text',
              text = ~paste("Units of Effort:",units_of_effort,
                            "</br></br>Total Added:", label)) %>% 
      layout(yaxis = list(title = list(text ='Units of Effort')),
             xaxis = list(title = list(text ='')),
             barmode = 'stack',
             legend = list(orientation = 'h')) %>% 
      config(displayModeBar = FALSE)
    
  })
  
  output$text_2 <- renderUI({
    return(HTML(paste("<strong>", strategy_popup_labels[[input$Scenario]], "</strong>", ":", descriptions[[input$Scenario]])))
  })
} 
