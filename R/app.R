#' Run an interactive app
#' @param my_html html in a vector of strings; output from 'create_html'.
#' @param user_function R function; the function to process the data from the web interface.
#' @param server T or F; whether to enable interaction between JS and R.
#' @param assets_folder path of the assets.
#' @param host character string; Address to host the app.
#' @param port integer; Port to host the app.
#' @param browser "browser" (web) or "viewer" (R).
#' @export
start_app <- function(my_html, user_function = identity, server = F, assets_folder, 
                      host = "localhost", port = 9454, browser = "viewer") {
  temp_dir <- tempfile()
  dir.create(temp_dir)
  file_path <- file.path(temp_dir, "index.html")
  htmltools::save_html(my_html, file_path)
  if (!missing(assets_folder)) {
    copy_assets(assets_folder, temp_dir)
  }
    
  if (server == F) {
    getOption("viewer")(file_path)
  } else {
    my_app <- create_app(file_path, user_function, server)
    address <- paste0("http://", host, ":", port)
    browseURL(address, browser = getOption(browser))
    host <- ifelse(host == "localhost", "0.0.0.0", host)
    httpuv::runServer(host, port, my_app, 250)
  }
}


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
