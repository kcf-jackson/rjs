# Uniform transition
time_dilate <- function(data0) {
  data0 <- as.data.frame(data0)
  l2_dist <- function(x, y) {sqrt(sum((x - y)^2))}
  x <- purrr::map_dbl(1:(nrow(data0) - 1), ~l2_dist(data0[.x, ], data0[.x+1, ]))
  x / max(x)
}

# Get quantile records 
quantile_records <- function(data0, attr0, q_vec) {
  quantile_id <- function(x, q) {
    which(x == quantile(x, q))
  }
  ind <- purrr::map_dbl(q_vec, ~min(quantile_id(data0[[attr0]], .x)))
  data0[ind, ]
}

# Scale record time by the best time
scale_time <- function(x) {
  x <- as.numeric(x)
  x / min(x)
}

# Make all paths have equal length
match_length <- function(x) {
  extend_vec <- function(x, n) {
    if (length(x) >= n) return(x)
    c(x, rep(tail(x, 1), n - length(x)))
  }
  max_len <- max(purrr::map_dbl(x, length))
  map(x, extend_vec, n = max_len)
}
