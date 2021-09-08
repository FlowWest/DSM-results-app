server <- function(input, output) {
  # Filter based on run and metric
  selected_results <- reactive({
      dsm_results %>% 
        filter(run == input$Run, 
               metric == input$Metric)
  })
  
  output$results_plot <- renderPlotly({
    p_template <- function (data, pick_col) {
      data %>%
        plot_ly(y = ~strategy, x = ~value, marker = list(color = pick_col), type = "bar",
                          orientation = 'h', 
                          hoverinfo = 'text', source = "subset") %>% 
      layout(yaxis = list(title = list(text ='')),
             xaxis = list(title = list(text ='Utility Score')),
             barmode = 'stack',
             legend = list(orientation = 'h')) %>% 
      config(displayModeBar = FALSE)
    }
    
    annotations <- list( 
      list( 
        x = 0.2,  
        y = 1.0,  
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
      filter(version == 2019), "green")
    plot_2021 <- p_template(selected_results() %>%
      filter(version == 2021), "blue")
    
    if (input$results_2019 == T) {
      subplot(plot_2019, plot_2021, 
              margin = 0.07) %>%
        layout(title = input$Metric,
               showlegend = F,
               annotations = annotations)
      
    } else {
      plot_2021 %>%
        layout(title = paste0("2021 ", input$Metric))
      
    }
  })
  
  # output$text <- renderUI({
  #   return(HTML(paste("<strong>", scenario_names[[input$Scenario]], "</strong>", ":", descriptions[[input$Scenario]])))
  # })
} 