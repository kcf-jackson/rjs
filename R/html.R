#' Create an empty HTML document
#' @export
#' @examples 
#' create_html()
create_html <- function() {
  htmltools::tags$html(htmltools::tags$head(), htmltools::tags$body()) 
}


#' Generic function to insert an element into a HTML document
#' @param html An HTML object, e.g. output from create_html().
#' @param into characters; an identifier. It could be a tag name, an element id or a class name.
#' @param el An HTML tag object, see htmltools::tag for details. 
#' @note One should use the \link{add} family of functions for valid HTML5 tags.
#' @examples 
#' create_html() %>% 
#'   add_elements(into = "body", htmltools::tags$div("I am a div"))
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


#' A family of functions for adding HTML 5 elements.
#' @description The \code{add} environment wraps around the \code{htmltools::tags} environments, 
#' and it contains functions for all valid HTML5 tags. 
#' @param ... Element contents and attributes; attrbutes must be named. See references for 
#' HTML5-tags guides. 
#' @details Every html-tag function in \code{add} takes two named arguments \code{html} and \code{into}.  
#' 
#' \code{html} is an HTML object, e.g. output from create_html().  
#' 
#' \code{into} is a character string representing an identifier; it could be a tag name, an element id or a class name.
#' 
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
#' @format \code{add} is a list / family of functions for inserting html tags into a html document.
#' @examples 
#' \dontrun{
#' create_html() %>% 
#'   add$h2(into = "body", "A demo webpage") %>% 
#'   add$div(into = "body", "I am a DIV") %>% 
#'   start_app()
#' }
#' @export
add <- purrr::map(
  .x = htmltools::tags,
  .f = ~{ function(html, into, ...) { add_elements(html, into, .x(...)) } }
)
