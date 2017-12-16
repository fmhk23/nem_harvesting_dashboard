library(plotly)
library(shiny)

ui <- navbarPage("NEM Harvesting Visualizer",
                 tabPanel("Histroical Harvested Fee",
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
                                   radioButtons("span", "Span", list("Daily", "Weekly", "Monthly"),
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
                          
                          )
                 )

