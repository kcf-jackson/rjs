#' Start and Stop daemonized app
#' @usage \preformatted{
#' p <- daemon_app$new()
#' 
#' p$start_daemon_app(filename)
#' 
#' p$stop_daemon_app()
#' }
#'
#' @export
#' 
#' @details
#' \code{$new()} starts a new process.
#' 
#' \code{$start_daemon_app(filename)} takes a rjs app filepath argument.
#' 
#' \code{$stop_daemon_app()} stops the process.
daemon_app <- R6::R6Class(
  "daemon_app",
  public = list(
    #' A handle returned by `subprocess::spawn_process`.
    handle = list(),

    #' Start daemonized app
    #' @param filename filepath to the app R file.
    start_daemon_app = function(filename) {
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
      self$handle <- subprocess::spawn_process(R_binary(), c('--no-save'))
      Sys.sleep(1)
      subprocess::process_write(self$handle, sprintf("setwd('%s')\n", fpath$filepath))
      Sys.sleep(0.4)
      subprocess::process_write(self$handle, sprintf("source('%s')\n", fpath$filename))
      print(self$handle)
      invisible(self$handle)
    },

    #' Stop daemonized app
    stop_daemon_app = function() {
      cat("Stopping server...\n")
      subprocess::process_terminate(self$handle)
      Sys.sleep(1)
      print(self$handle)
      invisible(self$handle)
    }
  )
)
