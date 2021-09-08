shinyUI(fluidPage(
  theme = shinythemes::shinytheme("readable"),
  titlePanel("SIT Decision Support Model Results"),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      selectInput(
        "Run",
        label = "Run",
        choices = c(
          "Fall Run" = "Fall",
          "Spring Run" = "Spring",
          "Winter Run" = "Winter"
        )
      ),
      selectInput(
        "Metric",
        label = "Metric",
        choices = c(
          "Natural Production Utility Score",
          "Juvenile Biomass Utility Score"
        )
      ),
      checkboxInput("results_2019",
                    "Show 2019 Results")
    ),
    mainPanel(plotlyOutput('results_plot'))
  )
))

