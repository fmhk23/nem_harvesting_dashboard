
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(data.table)
library(dplyr)
library(ggplot2)
library(plotly)
library(stringr)
library(zoo)

daily <- readRDS("./daily171215")
weekly <- readRDS("./weekly171215")
monthly <- readRDS("./monthly171215")

shinyServer(function(input, output) {
  
  Date <- daily$Date
  
  observeEvent(input$reload,{
    begin <- as.Date(input$daterange[1])
    end <- as.Date(input$daterange[2] + 1)
    
    # Switches depending on inputs
    tmp_data <- switch(input$span,
                       "Daily" = daily,
                       "Weekly" = weekly,
                       "Monthly" = monthly,
                       daily)
    
    Ycol <- switch(input$index,
                   "Average" = "Mean",
                   "Max" = "Max",
                   "% of 0 blocks" = "Null",
                   "Mean")
    
    tmp_data <- tmp_data %>% dplyr::filter(between(Date, begin, end)) %>% 
      dplyr::select(Date, Ycol)
    
    colnames(tmp_data) <- c("Date", "Y")
    Ylab <- input$index
    
    output$daily_plot <- renderPlotly({
      plot_ly(x = ~tmp_data$Date, y = ~tmp_data$Y, type = 'bar') %>% 
        layout(
          xaxis = list(title = 'Date'),
          yaxis = list(title = Ylab)
        )
    })
    
    
  })
  
  # Default
  output$daily_plot <- renderPlotly({
    plot_ly(x = ~daily$Date, y = ~daily$Mean, type = 'bar') %>% 
      layout(
        xaxis = list(title = 'Date'),
        yaxis = list(title = 'Average')
      )
  })

})
