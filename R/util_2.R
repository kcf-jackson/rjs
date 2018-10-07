car <- function(x) { x[[1]] }

cdr <- function(x) { x[-1] } 


# Functionals
preduce <- function(.l, .f, ..., .init) {
  if (purrr::is_empty(.l[[1]])) return(.init)
  preduce(
    .l = Map(cdr, .l), .f = .f, ..., 
    .init = do.call(.f, args = append(list(.init, ...), Map(car, .l)))
  )
}


# Extend magrittr::freduce with optional arguments
freduce <- function(value, function_list, ...) {
  if (length(function_list) == 1L)
    function_list[[1L]](value, ...)
  else 
    Recall(function_list[[1L]](value, ...), function_list[-1L])
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
