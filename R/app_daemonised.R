#' Start daemonized app
#' @param filename filepath to the app R file.
#' @export
start_daemon_app <- function(filename) {
  R_binary <- function () {
    R_exe <- ifelse(tolower(.Platform$OS.type) == "windows", "R.exe", "R")
    return(file.path(R.home("bin"), R_exe))
  }
  get_filepath <- function(str0) {
    p <- str0 %>% strsplit("/") %>% unlist()
    list(filepath = p %>% head(-1) %>% paste(collapse = "/"),
         filename = p %>% tail(1))
  }  
  fpath <- get_filepath(filename)

  cat("Starting server...\n")
  handle <- subprocess::spawn_process(R_binary(), c('--no-save'))
  Sys.sleep(1)
  subprocess::process_write(handle, sprintf("setwd('%s')\n", fpath$filepath))
  Sys.sleep(0.4)
  subprocess::process_write(handle, sprintf("source('%s')\n", fpath$filename))
  print(handle)
  invisible(handle)
}


#' Stop daemonized app
#' @param handle A handle returned by `subprocess::spawn_process`.
#' @export
stop_daemon_app <- function(handle) {
  cat("Stopping server...\n")
  subprocess::process_terminate(handle)
  Sys.sleep(1)
  print(handle)
  invisible(handle)
}
