
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title ="NEM Dashboard v0.01"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Harvesting Historical Data", tabName = "Harvesting", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "Harvesting",
              fluidRow(
                h2("NEM Mainet: Historical HARVESTED FEE"),
                box(dateRangeInput("daterange", "Date range:",
                                   start  = Sys.Date() - 90,
                                   end    = Sys.Date(),
                                   min    = "2015-03-29",
                                   max    = Sys.Date(),
                                   format = "yyyy/mm/dd",
                                   separator = " - "),
                    actionButton("reload", "load/reload")
                ),
                box(radioButtons("moving", "Moving Interval:", list("1 hour", "1 day", "3 days", "7 days", "14 days", "28 days"),
                                 selected = "1 day")
                )
                
              ),
              fluidRow(
                h2("Summary"),
                tableOutput("summary_table"),
                h2("Smoothed Line & NULL Block%"),
                plotOutput("HarvestPlot"),
                h2("Raw Data"),
                plotOutput("rawdataPlot")
              )
        )
    )

  )
  
)