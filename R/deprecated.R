#' Preview app (Deprecated)
#' @description This function is deprecated. Use \link{start_app} instead.
#' @param ... Arguments to pass to `start_app'. See help("start_app").
#' @export
preview_app <- function(...) {
  .Deprecated("start_app")
  start_app(...)
}
