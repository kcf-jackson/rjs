# Collapse lines into a string
JS_ <- function(...) {
  x <- c(...)
  paste(x, collapse = "\n")
}


if_else <- function(bool, yes, no) {
  if (bool)
    return(yes)
  no
}


# Add 'pipes' to convert from and to JSON
add_pipe <- function(user_fun) {
  return (function(msg) {
    in_msg <- jsonlite::fromJSON(msg)
    out_msg <- user_fun(in_msg)
    jsonlite::toJSON(out_msg)
  })
}


#' A help function to make multiple ids.
#' @description This function is basically an alias of \code{paste}.
#' @param ... Arguments to pass to \code{paste} and joined by '_'.
#' @examples 
#' make_id("item", 1:5)
#' # [1] "item_1" "item_2" "item_3" "item_4" "item_5"
#' @export
make_id <- function(...) {
  paste(..., sep = "_") 
}


car <- . %>% .[[1]]
cdr <- . %>% .[-1]


preduce <- function(.l, .f, ..., .init) {
  if (purrr::is_empty(.l[[1]])) return(.init)
  preduce(
    .l = Map(cdr, .l), .f = .f, ..., 
    .init = do.call(.f, args = append(list(.init, ...), Map(car, .l)))
  )
}


# Reimplement magrittr::freduce with optional arguments
freduce <- function(value, function_list, ...) {
  if (length(function_list) == 1L)
    function_list[[1L]](value, ...)
  else 
    Recall(function_list[[1L]](value, ...), function_list[-1L])
}
