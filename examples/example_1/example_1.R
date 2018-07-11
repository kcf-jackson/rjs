# Example 1. This file explores the basic mechanism for R and JS to interact.
rm(list = ls())
library(rjs)

my_html <- create_html() %>%
  add_title("Send message", size = 3) %>%
  add_slider(min = "0", max = "100", oninput = "show_value(value)") %>%
  add_title("Receive message", size = 3) %>%
  add_row(id = "output")

my_html %<>% add_script("
  function show_value(value) {
    ws.send(value);    // send value to R
  }
  ws.onmessage = function(msg) {
    // get value from R
    document.getElementById('output').innerHTML = msg.data;
  }
")

r_fun <- function(msg) {
  print(msg)
}

start_app(my_html, r_fun, T)
