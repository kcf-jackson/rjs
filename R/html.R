#' Create an empty HTML document
#' @export
create_html <- function() {
  htmltools::tags$html(htmltools::tags$head(), htmltools::tags$body()) 
}


#' Generic function to insert an element into a HTML document
#' @param html An HTML object, e.g. output from create_html().
#' @param into characters; an identifier. It could be a tag name, an element id or a class name.
#' @param el An HTML tag object, see htmltools::tag for details. 
#' @note One should use the add-* family of functions for valid HTML5 tags.
#' @export
add_elements <- function(html, into, el) {
  found <- F
  iter <- function(html) {
    if (is.null(html) || (class(html) != "shiny.tag")) return(html)
    
    if (!purrr::is_empty(html$children)) {
      html$children %<>% purrr::map(iter)
    }
    
    if (has_identifier(html, into)) {
      html %<>% htmltools::tagAppendChild(el)
      found <<- T
    }
    html
  }
  
  res <- iter(html)
  if (!found) {
    warning(sprintf("I couldn't find the identifier '%s' you suggested.", into))
  }
  res
}


has_identifier <- function(el, identifier) {
  id <- htmltools::tagGetAttribute(el, "id")
  cls <- htmltools::tagGetAttribute(el, "class")
  equal_identifier <-  . %>% {(!is.null(.) && (. == identifier))}
  (el$name == identifier) || equal_identifier(id) || equal_identifier(cls)
}
