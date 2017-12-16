library(data.table)
library(dplyr)
library(purrr)
library(purrrlyr)
library(stringr)

blocks <- fread("./data/1215.csv") %>% as.data.frame() %>% 
  dplyr::select(TIMESTAMP, TOTALFEE)

blocks$TIMESTAMP <- as.numeric(blocks$TIMESTAMP)
blocks$TOTALFEE <- as.numeric(blocks$TOTALFEE) / 1000000
blocks$GMT_TIME <- as.POSIXct("2015-03-29 00:06:25", "GMT") + blocks$TIMESTAMP

blocks$YYMM <- year(blocks$GMT_TIME) * 100 + month(blocks$GMT_TIME)
blocks$YYMM_Week <- year(blocks$GMT_TIME) * 100 + week(blocks$GMT_TIME)
blocks$Date <- as.Date(blocks$GMT_TIME)

monthly <- blocks %>% dplyr::group_by(YYMM) %>% 
  purrrlyr::by_slice(~ mean(.x$TOTALFEE)) %>% 
  dplyr::rename(Mean = .out)
monthly$Date <- seq(as.Date("2015-03-29"), length.out = nrow(monthly), by = "1 month")

monthly_m <- blocks %>% dplyr::group_by(YYMM) %>% 
  purrrlyr::by_slice(~ max(.x$TOTALFEE)) %>% 
  dplyr::rename(Max = .out)
monthly_m$Max <- as.numeric(monthly_m$Max)

monthly_null <- blocks %>% dplyr::group_by(YYMM) %>% 
  purrrlyr::by_slice(function(x){
    return(x %>% dplyr::filter(TOTALFEE == 0) %>% nrow() / nrow(x))
  })

monthly$Mean <- as.numeric(monthly$Mean)
monthly$Max <- as.numeric(monthly_m$Max)
monthly$Null <- as.numeric(monthly_null$.out)

# Weekly --------------

weekly <- blocks %>% dplyr::group_by(YYMM_Week) %>% 
  purrrlyr::by_slice(~ mean(.x$TOTALFEE)) %>% 
  dplyr::rename(Mean = .out)
weekly$Fee <- as.numeric(weekly$Mean)
weekly$Date <- seq(as.Date("2015-03-29"), length.out = nrow(weekly), by = "1 week")

weekly_m <- blocks %>% dplyr::group_by(YYMM_Week) %>% 
  purrrlyr::by_slice(~ max(.x$TOTALFEE)) %>% 
  dplyr::rename(Max = .out)
weekly_m$Max <- as.numeric(weekly_m$Max)

weekly_null <- blocks %>% dplyr::group_by(YYMM_Week) %>% 
  purrrlyr::by_slice(function(x){
    return(x %>% dplyr::filter(TOTALFEE == 0) %>% nrow() / nrow(x))
  })

weekly$Mean <- as.numeric(weekly$Mean)
weekly$Max <- as.numeric(weekly_m$Max)
weekly$Null <- as.numeric(weekly_null$.out)

# Daily --------------

daily <- blocks %>% dplyr::group_by(Date) %>% 
  purrrlyr::by_slice(~ mean(.x$TOTALFEE)) %>% 
  dplyr::rename(Mean = .out)

daily_m <- blocks %>% dplyr::group_by(Date) %>% 
  purrrlyr::by_slice(~ max(.x$TOTALFEE)) %>% 
  dplyr::rename(Max = .out)
daily_m$Max <- as.numeric(daily_m$Max)

daily_null <- blocks %>% dplyr::group_by(Date) %>% 
  purrrlyr::by_slice(function(x){
    return(x %>% dplyr::filter(TOTALFEE == 0) %>% nrow() / nrow(x))
  })

daily$Mean <- as.numeric(daily$Mean)
daily$Max <- as.numeric(daily_m$Max)
daily$Null <- as.numeric(daily_null$.out)

daily_p <- plot_ly(x = ~daily$Date, y = ~daily$Mean, type = 'bar') %>% 
  layout(xaxis = list(title = "aaaaa"))
daily_p <- plot_ly(x = ~daily$Date, y = ~daily$Max, mode = 'lines', type = 'bar')
daily_p <- plot_ly(x = ~daily_null$Date, y = ~daily_null$.out, mode ="lines", type = "scatter")
