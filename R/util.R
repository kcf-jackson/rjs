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
