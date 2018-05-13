#' A family of functions to add HTML 5 elements.
#' @export
add <- purrr::map(
  .x = htmltools::tags,
  .f = ~{ function(html, into, ...) { add_elements(html, into, .x(...)) } }
)


# Derived functions
# Set default of a function
set_default <- function(FUN, ...) {
  list_union <- function(list1, list2) {
    list_diff <- !(names(list1) %in% names(list2))
    c(list1[list_diff], list2)
  }
  
  orig_list = list(...)
  function(...) {
    do.call(FUN, list_union(orig_list, list(...)))
  }
}


# Containers
add$row <- set_default(add$div, into = "body", class = "row")
add$column <- set_default(add$div, into = "body", class = "column")
add$item <- set_default(add$div, into = "body", class = "item")
add$container <- set_default(add$div, into = "body", class = "container")


# Text and titles
add$text <- set_default(add$span, into = "body")
add$title <- function(html, into = "body", size, ...) {
  fun <- paste0("h", size)
  add[[fun]](html, into, ...)
}


# Input widgets
add$button <- set_default(add$input, into = "body", type = "button")
add$slider <- set_default(add$input, into = "body", type = "range")
add$dropdown_list <- function(html, into = "body", options, labels, ...) {
  if (missing(labels)) labels <- options
  assertthat::assert_that(length(options) == length(labels))
  add$select(html, into,
             purrr::map(
               seq_along(labels),
               ~htmltools::tags$option(value = options[.x], labels[.x])
             ), ...)
}


# Style
add$style_from_link <- set_default(add$link, into = "head", rel = "stylesheet")
add$style_from_file <- function(html, into = "head", href, inline = F, ...) {
  if (inline) return(add$style(html, into, JS_(readLines(href)), ...))
  add$style_from_link(html, into, href = href, ...)
}
add$google_style <- set_default(
  add$style_from_link,
  link = "https://fonts.googleapis.com/icon?family=Material+Icons"
)
add$bootstrap_style <- set_default(
  add$style_from_link,
  link = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css",
  integrity = "sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u",
  crossorigin = "anonymous"
)


# Script
add$script_from_link <- set_default(add$script, into = "head")
add$script_from_file <- function(html, into = "head", src, inline = F, ...) {
  if (inline) return(add$script(html, into, JS_(readLines(src)), ...))
  add$script_from_link(html, into, src = src, ...)
}
js_src <- function() {
  # JS libraries source links
  list(
    p5 = "https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.5.16/p5.js",
    plotly = "https://cdn.plot.ly/plotly-latest.min.js",
    vega = "https://vega.github.io/vega/vega.min.js",
    d3 = "https://d3js.org/d3.v4.min.js"
  )
}
add$lib_plotly <- set_default(add$script_from_link, link = js_src()$plotly)
add$lib_p5 <- set_default(add$script_from_link, link = js_src()$p5)
add$lib_vega <- set_default(add$script_from_link, link = js_src()$vega)
add$lib_d3 <- set_default(add$script_from_link, link = js_src()$d3)
