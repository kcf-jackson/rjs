# Collapse lines into a string
JS_ <- function(...) { paste(c(...), collapse = "\n") }

if_else <- function(bool, yes, no) {
  if (bool) return(yes) 
  no
}
