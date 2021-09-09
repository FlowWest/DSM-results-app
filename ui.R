shinyUI(fluidPage(
  theme = shinythemes::shinytheme("lumen"),
  navbarPage("SIT DSM Results", id = "main_navbar",
             tabPanel(
               "Results",
               tags$h2("Decision Support Model Results for SIT Canidate Restoration Strategies"),
               tags$br(),
               sidebarLayout(
                 sidebarPanel(
                   width = 3,
                   # tags$p("Select a species and a metric to view 2021 DSM results. Click the checkbox to display the 2019 DSM result."),
                   selectInput(
                     "Run",
                     label = "Select Species",
                     choices = c(
                       "Fall Run" = "Fall",
                       "Spring Run" = "Spring",
                       "Winter Run" = "Winter"
                     )
                   ),
                   selectInput(
                     "Metric",
                     label = "Select Metric",
                     choices = c(
                       "Natural Production Utility Score",
                       "Juvenile Biomass Utility Score"
                     )
                   ),
                   checkboxInput("results_2019",
                                 "Show 2019 Results"),
                   # TODO fix formating
                   tags$br(),
                   tags$hr(),
                   tags$p("All results are shown as a utility score:"),
                   withMathJax(),
                   helpText(
                     '$$Utility = \\frac{Strategy Value - Min Value}{Max Value - Min Value}$$'
                   ),
                 ),
                 
                 mainPanel(plotlyOutput('results_plot'),
                           tags$br(),
                           tableOutput("clicked"),
                           tags$br(),
                           plotlyOutput("plot_2019"))
               )
             ),
             tabPanel(
               "Strategies", 
               fluidPage(
                 theme = shinythemes::shinytheme("lumen"), 
                 tags$h1("SIT Candidate Restoration Strategies"),
                 tags$br(),
                 tags$p('The SIT developed 13 candidate restoration strategies to evaluate in the Chinook salmon decision support models. The model output based on these candidate restoration strategies informed the development of the priorities in the CVPIA Near-term Restoration Strategy.'),
                 style = "padding: 2rem;",
                 fluidRow(
                   column(
                     width = 12, 
                     tags$h2("Cumulative Units of Effort"),
                     selectInput("Scenario", 
                                 label = "Select Strategy", 
                                 choices = c('One', 'Two', 'Three', 
                                             'Four', 'Five', 'Six', 
                                             'Seven', 'Eight', 'Nine', 
                                             'Ten', 'Eleven', 'Twelve', 
                                             'Thirteen')),
                     plotlyOutput("cumulative_acres_plot"), 
                     tags$br(),
                     htmlOutput("text"),
                     tags$hr()),
                   tags$br(),
                 ),
                 fluidRow(
                   column(
                     width = 12,
                     tags$h2("Watershed Action Details"),
                     uiOutput('watershed_input_ui'),
                     plotlyOutput('Watershed_graph'))
                 ))
             ))
))

