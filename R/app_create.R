# Create app from internal html format
create_app <- function(html_file, user_function = identity, insert_socket = T) {
  html_to_string <- . %>% readLines() %>% JS_()
  create_ws_url <- . %>% {paste('"', "ws://", ., '"', sep = "")}
  
  pipe_fun <- add_pipe(user_function)
  parse_fun <- if_else(insert_socket, insert_websockets, html_to_string)
  
  list(
    call = function(req) {
      address <- ifelse(is.null(req$HTTP_HOST), req$SERVER_NAME, req$HTTP_HOST)
      ws_url <- create_ws_url(address)
      body <- parse_fun(html_file, ws_url)
      list(status = 200L, headers = list("Content-Type" = "text/html"), body = body)
    },
    onWSOpen = function(ws) {
      ws$onMessage(function(binary, input) {
        output <- pipe_fun(input)
        ws$send(output)
      })
    }
  )
}


# Insert a websocket connection and convert html to string.
# The implementation accounts for cases where user provides their own html file.
insert_websockets <- function(filepath, wsUrl) {
  htag_index <- . %>% purrr::map_lgl(., ~grepl("<head>", .x)) %>% which()
  stag_index <- . %>% purrr::map_lgl(., ~grepl("<script>", .x)) %>% which()
  has_script <- . %>% stag_index() %>% any()
  
  my_html <- readLines(filepath)
  wsUrl_line <- sprintf("var ws = new WebSocket(%s);", wsUrl)
  
  if (!has_script(my_html)) {
    r_ind <- min(htag_index(my_html))
    insert_tag <- "<head>"
    replacement <- paste("<head>", "<script>", wsUrl_line, "</script>\n", sep = "\n ")
  } else {
    r_ind <- min(stag_index(my_html))
    insert_tag <- "<script>"
    replacement <- paste("<script>", wsUrl_line, "", sep = "\n ")
  }
  my_html[r_ind] <- gsub(insert_tag, replacement, my_html[r_ind])
  JS_(my_html)
}


# Add 'pipes' to convert from and to JSON
add_pipe <- function(user_fun) {
  return (function(msg) {
    msg %>% 
      jsonlite::fromJSON() %>% 
      user_fun() %>% 
      jsonlite::toJSON()
  })
}
