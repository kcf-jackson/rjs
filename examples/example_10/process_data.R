source("process_data_helper.R")

library(magrittr)
library(jsonlite)
library(tweenr)
data0 <- fromJSON("assets/path_data.json")

library(readr)
data1 <- read_csv("assets/berlin_marathon_times_dirty.csv") # not included in github
data1 %<>% dplyr::filter(year == "2016")
q_records <- quantile_records(data1, 'net_time', seq(0, 1, 0.1))
q_net_time <- q_records$net_time
q_factor <- scale_time(q_net_time)
q_label <- paste(seq(1,0,-0.1) * 100, "%", sep = "")
q_table <- data.frame(quantile = q_label, time = q_net_time)


library(purrr)
steps <- 100   #steps between two landmark points
x <- q_factor %>% 
  map(~ceiling(time_dilate(data0) * steps * .x)) %>% 
  map(~tween(as.list(data0$x), .x)[[1]]) %>% 
  match_length()

y <- q_factor %>% 
  map(~ceiling(time_dilate(data0) * steps * .x)) %>% 
  map(~tween(as.list(data0$y), .x)[[1]]) %>% 
  match_length()

save(x, y, file = "r_data")
