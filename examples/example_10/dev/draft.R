# Animated path on a map
# Draft
library(jsonlite)
data0 <- fromJSON("assets/path_data.json")  # data
plot(data0$x, -data0$y, type = 'l')

library(tweenr)
x <- tween(as.list(data0$x), 20)[[1]]  # transition
y <- tween(as.list(data0$y), 20)[[1]]  # transition
for (i in seq_along(x)) {
  points(x[i], -y[i])
  Sys.sleep(0.2)
}

# ================================
# How does tween work?
tween(list(0, 10), 3)
# [[1]]
# [1]  0  5 10

tween(list(c(0,0), c(10,5)), 5)
# [[1]]
# [1]  0.0  2.5  5.0  7.5 10.0
# 
# [[2]]
# [1] 0.00 1.25 2.50 3.75 5.00
# ================================


# Draft 2 - Uniform movement
source("../process_data_helper.R")
time_partition <- ceiling(time_dilate(data0) * 40)
x <- tween(as.list(data0$x), time_partition)[[1]]
y <- tween(as.list(data0$y), time_partition)[[1]]
plot(data0$x, -data0$y, type = 'l')
for (i in seq_along(x)) {
  points(x[i], -y[i])
  Sys.sleep(0.2)
}
