rm(list = ls())
library(rjs)

my_html <- create_html() %>%
  # Header
  add_script_from_link(src = "https://rawgit.com/karpathy/tsnejs/master/tsne.js") %>% 
  add_script_from_file("example_9.js") %>% 
  add_js_library("plotly") %>% 
  add_google_style() %>% 
  add_style("
      .column { float:left; }
      .column#column_left { padding-top: 30px; padding-left:20px;padding-right:30px; }
      .row{ padding-top: 5px; padding-left: 5px; padding-bottom: 8px;}
      #c1_row_1{ display: flex }
      h3{ margin-bottom: 10px }
      .slider{ display:block; margin-top: 8pt }
  ") %>% 
  # Body - Title and Containers
  add_title("Interactive t-SNE in R") %>%
  add_column(id = "column_left") %>%
  add_column(id = "column_right") %>%
  map_add(add_row, args_list = list(id = make_id("c1_row", 1:4)), into = "column_left") %>% 
  # Body - Content
  add_google_style_button(into = "c1_row_1", material_id = "fast_rewind", onclick = "fast_rewind()") %>%
  add_google_toggle_button(into = "c1_row_1", widget_id = "play_pause", onclick = "start_pause()") %>%
  add_google_style_button(into = "c1_row_1", material_id = "replay", onclick = "restart()") %>%
  add_google_style_button(into = "c1_row_1", material_id = "fast_forward", onclick = "fast_forward()") %>% 
  add_counter(into = "c1_row_2", widget_id = "counter_1", 
    label = "Step ", counter = "0", counter_id = "my_counter") %>%
  add_slider_with_text(into = "c1_row_3", widget_id = "slider_1", class = "slider",
    label = "Perplexity ", min = "2", max = "100", step = "1", value = "10",
    onchange = "update_perp(this.value)") %>%
  add_slider_with_text(into = "c1_row_4", widget_id = "slider_2", class = "slider",
    label = "Epsilon ", min = "1", max = "20", step = "1", value = "5",
    onchange = "update_eps(this.value)") %>%
  add_div(id = "plotly_plot", into = "column_right")
  

start_tsne_app <- function(my_data, app_html = "tsne.html") {
  send_r_data <- function(msg) {
    list(r_dist_matrix = as.matrix(dist(my_data)))
  }
  
  my_app <- start_app(my_html, send_r_data, T)
}


# Run apps
x <- rnorm(100)
my_data <- data.frame(x1 = x, x2 = x^2, x3 = x^3, x4 = sin(x))
start_tsne_app(my_data)

# x <- rnorm(100)
# y <- rnorm(100)
# my_data <- data.frame(x1 = x, x2 = y, x3 = sin(x + y), x4 = 2 * x * y^2)
# start_tsne_app(my_data)
# 
# x <- rnorm(100)
# y <- rnorm(100)
# z <- rnorm(100)
# my_data <- data.frame(x1 = x, x2 = y, x3 = sin(x + y) - z, x4 = 2 * x * y^2 + z)
# start_tsne_app(my_data)
