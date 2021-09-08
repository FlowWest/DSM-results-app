server <- function(input, output) {
  # Filter based on run and metric
  selected_results <- reactive({
      dsm_results %>% 
        filter(run == input$Run, 
               metric == input$Metric)
  })
  
  output$results_plot <- renderPlotly({
    p_template <- function (data) {
      data %>%
        plot_ly(y = ~strategy, x = ~value, type = "bar",
                          orientation = 'h', 
                          hoverinfo = 'text') %>% 
      layout(yaxis = list(title = list(text ='')),
             xaxis = list(title = list(text ='Utility Score')),
             barmode = 'stack',
             legend = list(orientation = 'h')) %>% 
      config(displayModeBar = FALSE)
    }
    
    plot_2019 <- p_template(selected_results() %>%
      filter(version == 2019))
    plot_2021 <- p_template(selected_results() %>%
      filter(version == 2021))
    
    if (input$results_2019 == T) {
      subplot(plot_2019, plot_2021) %>%
        layout(title = input$Metric)
      
    } else {
      plot_2021 %>%
        layout(title = input$Metric)
    }
  })
  
  # output$text <- renderUI({
  #   return(HTML(paste("<strong>", scenario_names[[input$Scenario]], "</strong>", ":", descriptions[[input$Scenario]])))
  # })
} 