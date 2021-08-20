library(shinydashboard)
shinyUI(
dashboardPage(
  skin = 'black', 
  dashboardHeader(title = "Chinook DSM Results 2021"),
  dashboardSidebar(
    sidebarMenu(
    menuItem("Fall Run", tabName = "fall_run", icon = icon("fish")),
    menuItem("Spring Run", tabName = "spring_run", icon = icon("fish")),
    menuItem("Winter Run", tabName = "winter_run", icon = icon("fish"))
  )),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "fall_run",
              fluidRow(
                column(width = 5,
                       tags$h4("Percent Change from No Action Baseline"),
                       selectInput("Run", label = "Run", 
                                   choices = c("Fall Run", "Spring Run", "Winter Run"),
                                   multiple = TRUE, selected = "Fall Run"),
                       DT::dataTableOutput("percent_change_table")), 
                column(width = 5, 
                       tags$h4("Action Type and Units of Effort"),
                       fluidRow(column( width = 3, selectInput("Scenario", 
                                                               label = "Scenarios", 
                                                               choices = c('One', 'Two', 'Three', 
                                                                           'Four', 'Five', 'Six', 
                                                                           'Seven', 'Eight', 'Nine', 
                                                                           'Ten', 'Eleven', 'Twelve', 
                                                                           'Thirteen'))),
                                column(width = 5, selectInput("plot_type", 
                                                              label = "Plot Type", 
                                                              choices = c("Actions Applied Over Time", 
                                                                          "Cummulative Acres of Actions")))),
                       htmlOutput("text"),
                       tags$br(),
                       plotlyOutput("actions_plot"), 
                       
                       
                )
                )
              )
      )
    
    )
  )
)
