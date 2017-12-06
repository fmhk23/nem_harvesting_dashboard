library(data.table)
library(dplyr)
library(purrr)
library(purrlyr)
library(stringr)

blocks <- fread("./data/test_data.csv") %>% as.data.frame()

blocks$TIMESTAMP <- as.numeric(blocks$TIMESTAMP)
blocks$TOTALFEE <- as.numeric(blocks$TOTALFEE) / 1000000
blocks$GMT_TIME <- as.POSIXct("2015-03-29 00:06:25", "GMT") + blocks$TIMESTAMP

# month <- as.character(month(blocks$GMT_TIME)) %>%
#   map(~ ifelse(length(.x) < 2, str_c("0", .x), .x)) %>% as.character()

blocks$YYMM <- year(blocks$GMT_TIME) * 100 + month(blocks$GMT_TIME)
blocks$YYMM_Week <- blocks$YYMM*100 + week(blocks$GMT_TIME)
blocks$YYMMDD <- blocks$YYMM * 100 + mday(blocks$GMT_TIME)

monthly <- blocks %>% dplyr::group_by(YYMM) %>% 
  purrrlyr::by_slice(~ mean(.x$TOTALFEE)) %>% 
  dplyr::rename(Fee = .out)
monthly$Fee <- as.numeric(monthly$Fee)

weekly <- blocks %>% dplyr::group_by(YYMM_Week) %>% 
  purrrlyr::by_slice(~ mean(.x$TOTALFEE)) %>% 
  dplyr::rename(Fee = .out)
weekly$Fee <- as.numeric(weekly$Fee)
