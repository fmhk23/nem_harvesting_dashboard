library(data.table)
library(dplyr)
library(purrr)
library(purrrlyr)
library(stringr)

blocks <- fread("./data/test_data.csv") %>% as.data.frame()

blocks$TIMESTAMP <- as.numeric(blocks$TIMESTAMP)
blocks$TOTALFEE <- as.numeric(blocks$TOTALFEE) / 1000000
blocks$GMT_TIME <- as.POSIXct("2015-03-29 00:06:25", "GMT") + blocks$TIMESTAMP

blocks$YYMM <- year(blocks$GMT_TIME) * 100 + month(blocks$GMT_TIME)
blocks$YYMM_Week <- year(blocks$GMT_TIME) * 100 + week(blocks$GMT_TIME)
blocks$Date <- as.Date(blocks$GMT_TIME)
#blocks$YYMMDD <- blocks$YYMM * 100 + mday(blocks$GMT_TIME)

monthly <- blocks %>% dplyr::group_by(YYMM) %>% 
  purrrlyr::by_slice(~ mean(.x$TOTALFEE)) %>% 
  dplyr::rename(Fee = .out)
monthly$Fee <- as.numeric(monthly$Fee)
monthly$Date <- seq(as.Date("2015-03-29"), length.out = nrow(monthly), by = "1 month")

monthly_p <- plot_ly(x = ~monthly$Date, y = ~monthly$Fee, mode = 'lines', type = 'scatter')


weekly <- blocks %>% dplyr::group_by(YYMM_Week) %>% 
  purrrlyr::by_slice(~ mean(.x$TOTALFEE)) %>% 
  dplyr::rename(Fee = .out)
weekly$Fee <- as.numeric(weekly$Fee)
weekly$Date <- seq(as.Date("2015-03-29"), length.out = nrow(weekly), by = "1 week")

weekly_p <- plot_ly(x = ~weekly$Date, y = ~weekly$Fee, mode = 'lines', type = 'scatter')


daily <- blocks %>% dplyr::group_by(Date) %>% 
  purrrlyr::by_slice(~ mean(.x$TOTALFEE)) %>% 
  dplyr::rename(Mean = .out)
daily$Mean <- as.numeric(daily$Mean)

daily_m <- blocks %>% dplyr::group_by(Date) %>% 
  purrrlyr::by_slice(~ max(.x$TOTALFEE)) %>% 
  dplyr::rename(Max = .out)
daily_m$Max <- as.numeric(daily_m$Max)

daily_null <- blocks %>% dplyr::group_by(Date) %>% 
  purrrlyr::by_slice(function(x){
    return(x %>% dplyr::filter(TOTALFEE == 0) %>% nrow() / nrow(x))
  })

daily_p <- plot_ly(x = ~daily$Date, y = ~daily$Mean, type = 'bar')
daily_p <- plot_ly(x = ~daily$Date, y = ~daily$Max, mode = 'lines', type = 'bar')
daily_p <- plot_ly(x = ~daily_null$Date, y = ~daily_null$.out, mode ="lines", type = "scatter")
