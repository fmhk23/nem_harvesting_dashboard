library(plotly)
library(shiny)

ui <- navbarPage("NEM Harvesting Visualizer",
                 tabPanel("Historical",
                          fluidRow(
                            h2("Histroical Harvested Fee"),
                            column(4,
                                   dateRangeInput("daterange", "Date range:",
                                                  start  = Sys.Date() - 90,
                                                  end    = Sys.Date(),
                                                  min    = "2015-03-29",
                                                  max    = Sys.Date(),
                                                  format = "yyyy/mm/dd",
                                                  separator = " - ")
                                       
                                   ),
                            column(2,
                                   radioButtons("moving", "Span", list("Daily", "Weekly", "Monthly"),
                                                selected = "Daily")
                                   ),
                            column(2,
                                   radioButtons("index", "Show", list("Average", "Max", "% of 0 blocks")),
                                                selected = "Average"
                                   )
                            
 
                            
                          ),
                          
                          fluidRow(
                            column(12,actionButton("reload", "load/reload"))
                          ),
                          
                          fluidRow(
                            plotlyOutput("daily_plot")
                            )
                          
                          ),
                 tabPanel("Component 2"))


# ui <- dashboardPage(
#   dashboardHeader(title ="NEM Dashboard v0.02"),
#   dashboardSidebar(
#     sidebarMenu(
#       menuItem("Summary", tabName = "Summary", icon = icon("dashboard")),
#       menuItem("Harvesting Historical Data", tabName = "Harvesting", icon = icon("dashboard"))
#     )
#   ),
#   dashboardBody(
#     tabItems(
#       tabItem(tabName = "Summary",
#               fluidRow(
#                 h2("Daily Average Harvested Fee"),
#                 
#                 box(dateRangeInput("daterange", "Date range:",
#                                    start  = Sys.Date() - 90,
#                                    end    = Sys.Date(),
#                                    min    = "2015-03-29",
#                                    max    = Sys.Date(),
#                                    format = "yyyy/mm/dd",
#                                    separator = " - "),
#                     actionButton("reload", "load/reload")
#                 )
#               ),
# 
#               
#               plotlyOutput("daily_plot")
#               ),
#       
#       tabItem(tabName = "Harvesting",
#               fluidRow(
#                 h2("NEM Mainet: Historical HARVESTED FEE"),
#                 box(dateRangeInput("daterange", "Date range:",
#                                    start  = Sys.Date() - 90,
#                                    end    = Sys.Date(),
#                                    min    = "2015-03-29",
#                                    max    = Sys.Date(),
#                                    format = "yyyy/mm/dd",
#                                    separator = " - "),
#                     actionButton("reload", "load/reload")
#                 ),
#                 box(radioButtons("moving", "Moving Interval:", list("1 hour", "1 day", "3 days", "7 days", "14 days", "28 days"),
#                                  selected = "1 day")
#                 )
#                 
#               ),
#               fluidRow(
#                 h2("Summary"),
#                 tableOutput("summary_table"),
#                 h2("Smoothed Line & NULL Block%"),
#                 plotOutput("HarvestPlot"),
#                 h2("Raw Data"),
#                 plotOutput("rawdataPlot")
#               )
#         )
#     )
# 
#   )
#   
# )