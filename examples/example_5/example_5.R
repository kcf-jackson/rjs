# Example 5. Classification. (Get familiar with the common visual tasks in JS (p5.js))
# This app is inspired by: 
#     http://cs.stanford.edu/people/karpathy/convnetjs/demo/classify2d.html

# Make sure to set the right working directory before running!
rm(list = ls())
library(rjs)
source("example_5_helper.R")

# Html
my_html <- create_html() %>%
  add_js_library("p5") %>%
  add_column(id = "column_1", align = 'center') %>%
    add_column(id = "column_2", align = 'center', into = "column_1") %>%
      add_text("<b>Classification visualisation</b><br>", into = "column_2") %>%
      add_text("Click to create red dots. <br> Click with key pressed to create green dots.",
           into = "column_2") %>%
  add_script_from_file("example_5.js")

# Helper
make_uniform_grid <- function(min0, max0, resolution = 100) {
  one_side_grid <- seq(min0, max0, length.out = resolution)
  grid_data <- expand.grid(one_side_grid, one_side_grid)
  grid_data <- data.frame(grid_data, 0)
  names(grid_data) <- c('x1', 'x2', 'y')
  grid_data
}

# R
grid_data <- make_uniform_grid(0, 400, 20)

# Use one of 'knn_fun', 'logit_fun', 'SVM_linear', 'SVM_radial' as implemented in
# 'example_5_helper.R'.
start_app(my_html, knn_fun, T, browser = "browser")
