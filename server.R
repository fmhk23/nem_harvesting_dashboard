
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

daily <- readRDS("./daily2")
#weekly <- readRDS("./weekly")
#monthly <- readRDS("./monthly")

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
          yaxis = list(title = Ylab)
        )
    })
    
    
  })
  
  # Default
  output$daily_plot <- renderPlotly({
    plot_ly(x = ~daily$Date, y = ~daily$Mean, type = 'bar')
  })
  
  # observeEvent(input$reload,{
  #   begin <- as.POSIXct(as.Date(input$daterange[1]))
  #   end <- as.POSIXct(as.Date(input$daterange[2]))
  #   
  #   tmp_blocks <- blocks %>% dplyr::filter(between(GMT_TIME, begin, end))
  #   
  #   
  #   interval <- switch(input$moving,
  #                      "1 hour" = 60,
  #                      "1 day" = 1440,
  #                      "3 days" = 1440 * 3,
  #                      "7 days" = 1440 * 7,
  #                      "14 days" = 1440 * 14,
  #                      "28 days" = 1440 * 28,
  #                      60
  #                      )
  #   
  #   # Summarise
  #   average_fee <- mean(tmp_blocks$TOTALFEE)
  #   median_fee  <- median(tmp_blocks$TOTALFEE)
  #   max_fee     <- max(tmp_blocks$TOTALFEE)
  #   null_percent <- tmp_blocks %>% dplyr::filter(TOTALFEE == 0) %>% nrow() / nrow(tmp_blocks)
  #   
  #   summary_table <- data.frame(
  #     AVERAGE = average_fee,
  #     MEDIAN  = median_fee,
  #     MAX = max_fee,
  #     NULLBLOCK = str_c(str_sub(as.character(null_percent * 100), 1,2), "%")
  #   )
  #   
  #   output$summary_table <- renderTable({summary_table}, width = 170, align = "c")
  #   
  #   # Generate Plot
  #   tmp_blocks$smoothed <- c(rep(average_fee, interval - 1),
  #                            rollmean(tmp_blocks$TOTALFEE, interval))
  #   
  #   output$HarvestPlot <- renderPlot({
  #     ggplot() +
  #       theme_bw() +
  #       xlab("Time") + 
  #       ylab("HARVESTED FEE") +
  #       layer(data = tmp_blocks,
  #             mapping = aes(x = GMT_TIME, y = smoothed),
  #             geom = "line",
  #             params = list(color = "red"),
  #             stat = "identity",
  #             position = "identity"
  #             )
  #   })
  #   
  #     
  #   output$rawdataPlot <- renderPlot({
  #     ggplot() +
  #       theme_bw() +
  #       xlab("Time") + 
  #       ylab("HARVESTED FEE") +
  #       coord_cartesian(ylim = 0:1000) +
  #       layer(data = tmp_blocks, 
  #             mapping = aes(x = GMT_TIME, TOTALFEE),
  #             geom = "line",
  #             stat = "identity",
  #             position = "identity")
  #   })
  # })

})
