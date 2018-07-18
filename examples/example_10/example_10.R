rm(list = ls())
library(rjs)
load("r_data", verbose = T)

# Layout
w <- 600
h <- 400

my_html <- create_html() %>% 
  add_title(size = 1, "Berlin Marathon 2016", class = 'title') %>% 
  add_title(size = 2, class = 'subtitle', 
            "Tracking the 43rd Berlin Marathon: the best, the average and the worst.") %>% 
  add_js_library("d3") %>% 
  add_script_from_file("helper.js") %>% 
  add_style_from_file("assets//nice_font.css") %>% 
  add_svg(width = w, height = h, id = "svg_canvas") %>% 
  add_image(width = w, height = h, into = "svg_canvas", 
            href = "https://interaktiv.morgenpost.de/berlin-marathon-2016/images/track2.svg") %>% 
  add_script_from_file(into = "body", "example_10.js") %>% 
  add_row(id = "row_1", style = "display:flex") %>% 
    add_div("00:00:00", id = "label_time", class = "label", into = "row_1") %>% 
    add_div("Play", id = "play_pause", class = "label", into = "row_1", 
            style = "cursor: pointer;", onclick = "button_toggle()") %>% 
    add_div("0.5x", class = "label", into = "row_1", 
          style = "cursor: pointer;", onclick = "set_half_x()") %>% 
    add_div("Reset", class = "label2", into = "row_1", 
          style = "cursor: pointer;", onclick = "set_x()") %>% 
    add_div("2x", class = "label2", into = "row_1", 
          style = "cursor: pointer;", onclick = "set_double_x()") %>% 
  add_slider(id = "slider_1", 
             min = 1, max = length(x[[1]]), step = 1, value = 1, 
             oninput = "slider_update()", 
             style = "margin-left: 50px; width: 550px;")

my_r_fun <- function(msg) {
  i <- ifelse(is.null(msg$i), 1, as.numeric(msg$i))
  list(
    x = purrr::map_dbl(x, ~.x[i]), 
    y = purrr::map_dbl(y, ~.x[i])
  )  
}

start_app(my_html, my_r_fun, T, browser = "browser")
