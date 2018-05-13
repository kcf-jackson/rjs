# Insert a websocket connection and convert html to string.
insert_websockets <- function(filepath, wsUrl) {
  tag_index <- . %>% purrr::map_lgl(., ~grepl("<script>", .x)) %>% which()
  has_script <- . %>% tag_index() %>% any()
  
  my_html <- readLines(filepath)
  if (!has_script(my_html)) {
    stop("Your file doesn't contain a <script> tag that occupies a single line.")
  }
  
  wsUrl_line <- sprintf("var ws = new WebSocket(%s);", wsUrl)
  JS_(append(my_html, wsUrl_line, after = min(tag_index(my_html))))
}
