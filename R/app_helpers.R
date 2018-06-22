# Insert a websocket connection and convert html to string.
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


#' Copy assets to target directory
#' @description This is needed when one needs to serve local file to RStudio viewer.
#' @param path character_string; path to the source file / folder.
#' @param target_dir character_string; path to the target folder.
#' @keywords internal
copy_assets <- function(path, target_dir) {
  if (!file.exists(path) || !file.exists(target_dir))
    stop("File / folder doesn't exist.")
  
  if (file.info(path)$isdir) {
    success <- file.copy(path, target_dir, recursive = T)
  } else {
    success <- file.copy(path, target_dir)
  }
  
  if (success) print("Folder copied successfully")
  target_dir
}
