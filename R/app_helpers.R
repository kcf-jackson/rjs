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
  
  # if (success) print("Folder copied successfully")
  target_dir
}
