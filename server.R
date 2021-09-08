server <- function(input, output) {
  # Filter based on run and 
  selected_results <- reactive({
    dsm_results %>% filter(run == input$Run, 
                           metric == input$Metric)
  })
  
  output$results_plot <- renderPlotly({
    selected_results() %>% 
      plot_ly(y = ~strategy, x = ~value, type = "bar",
              orientation = 'h', 
              hoverinfo = 'text') %>% 
      layout(title = "Metric", 
             yaxis = list(title = list(text ='')),
             xaxis = list(title = list(text ='Utility Score')),
             barmode = 'stack',
             legend = list(orientation = 'h')) %>% 
      config(displayModeBar = FALSE)
  })
  
  # output$text <- renderUI({
  #   return(HTML(paste("<strong>", scenario_names[[input$Scenario]], "</strong>", ":", descriptions[[input$Scenario]])))
  # })
} 