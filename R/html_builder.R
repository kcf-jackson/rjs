#' A family of functions for adding HTML 5 elements.
#' @description The \code{add} environment wraps around the \code{htmltools::tags} environments, and it contains 
#' functions for all valid HTML5 tags. 
# #' @param html An HTML object, e.g. output from create_html().
# #' @param into Characters; an identifier. It could be a tag name, an element id or a class name.
#' @param ... Element contents and attributes; attrbutes must be named. See references for 
#' HTML5-tags guides. 
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
#' @name builder
#' @examples 
#' \dontrun{
#' library(jsvis)
#' create_html() %>% 
#'   add_title("A demo webpage", size = 2) %>% 
#'   add$div("body", "I am a DIV") %>% 
#'   add_row("I am a DIV") %>% 
#'   start_app()
#' }
#' @format NULL
#' @docType NULL
#' @keywords NULL
#' @export
add <- purrr::map(
  .x = htmltools::tags,
  .f = ~{ function(html, into, ...) { add_elements(html, into, .x(...)) } }
)


# Derived functions
#' Set default of a function
#' @description Sets default parameter of a function.
#' @param FUN A function.
#' @param ... Named arguments.
#' @export
#' @examples 
#' test_fun <- function(a, b) { paste(a, b) }
#' test_fun_2 <- set_default(test_fun, a = "Hello")
#' 
#' test_fun("Hello", "World")
#' # "Hello World"
#' test_fun_2("World")
#' # "Hello World"
#' test_fun_2("World", a = "The")  # Can still override default if needed.
#' # "The World"
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
add_svg <- function(my_html, ..., into = "body") {
  content <- if_else(missing(...), "", list(...))
  add_elements(my_html, into, htmltools::tag("svg", content))
}
add_image <- function(my_html, ..., into = "body") {
  content <- if_else(missing(...), "", list(...))
  add_elements(my_html, into, htmltools::tag("image", content))
}
add_span <- set_default(add$span, into = "body")
add_div <- set_default(add$div, into = "body")
add_row <- set_default(add$div, into = "body", class = "row")
add_column <- set_default(add$div, into = "body", class = "column")
add_item <- set_default(add$div, into = "body", class = "item")
add_container <- set_default(add$div, into = "body", class = "container")


# Text and titles
add_text <- set_default(add$span, into = "body")
add_title <- function(html, ..., size = 3) {
  fun <- paste0("h", size)
  set_default(add[[fun]], into = "body")(html, ...)
}


# Input widgets
add_button <- set_default(add$input, into = "body", type = "button")
add_slider <- set_default(add$input, into = "body", type = "range")
add_dropdown_list <- function(html, options, labels, ..., into = "body") {
  if (missing(labels)) labels <- options
  assertthat::assert_that(length(options) == length(labels))
  add$select(html, into,
             purrr::map(
               seq_along(labels),
               ~htmltools::tags$option(value = options[.x], labels[.x])
             ), ...)
}


# Style
add_style <- set_default(add$style, into = "head")
add_style_from_link <- set_default(add$link, into = "head", rel = "stylesheet")
add_style_from_file <- function(html, href, ...) {
  inline = T
  if (inline) return(add_style(html, JS_(readLines(href)), ...))
  add_style_from_link(html, href = href, ...)
}


add_google_style <- set_default(
  add_style_from_link,
  href = "https://fonts.googleapis.com/icon?family=Material+Icons"
)


add_bootstrap_style <- set_default(
  add_style_from_link,
  href = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css",
  integrity = "sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u",
  crossorigin = "anonymous"
)


# Script
add_script <- add_script_from_link <- set_default(add$script, into = "head")
add_script_from_file <- function(html, src, ...) {
  inline = T
  if (inline) return(add_script(html, JS_(readLines(src)), ...))
  add_script_from_link(html, src = src, ...)
}


#' Add JavaScript libraries to a HTML file
#' @description Add JS libraries links to html header
#' @param my_html An HTML object, e.g. output from create_html().
#' @param js_libs A character vector. The JavaScript libraries to use. Currently support 'plotly', 'p5', 'd3' and 'vega'.
#' @export
add_js_library <- function(my_html, js_libs) {
  list_links <- js_src()
  if (!any(js_libs %in% names(list_links))) {
    return(my_html)
  }
  
  cat("Note: When the html file is served, it'll download JavaScript libraries from:\n")
  for (lib0 in js_libs) {
    if (lib0 %in% names(list_links)) {
      link <- list_links[[lib0]]
      my_html %<>% add_script_from_link(src = link)
      cat("  ", link, "\n")
    }
  }
  my_html
}

js_src <- function() {
  # JS libraries source links
  list(
    jquery = "https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js", 
    p5 = "https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.5.16/p5.js",
    plotly = "https://cdn.plot.ly/plotly-latest.min.js",
    vega = "https://vega.github.io/vega/vega.min.js",
    d3 = "https://d3js.org/d3.v4.min.js"
  )
}


#' Add a list of div's to the HTML
#' @param my_html An HTML object; output from 'create_html'.
#' @param n integer; number of elements to add.
#' @param id_prefix character; prefix to be added to 
#' @param add_fun function; the add function to be called 
#' @param into characters; an identifier. It could be a tag name, an element id or a class name.
#' @export
#' @examples
#' create_html() %>% map_add(add_row, 5, id_prefix = "row_")
map_add <- function(my_html, add_fun, n, id_prefix = "item_", into = "body") {
  add_array(my_html, ids = paste0(id_prefix, seq(n)), into, add_fun)
}


# Use `add_fun` to add an array of elements with `ids` into a specific tag `into`.
add_array <- function(my_html, ids, into, add_fun) {
  .f <- function(my_html, id, into) { 
    # Wrap function sicne `add_fun` doesn't have named arguments
    add_fun(my_html, id = id, into = into) 
  }
  purrr::reduce(ids, .f, .init = my_html, into = into)
}
