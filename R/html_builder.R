# ===========================================================================================
# This file contains functions derived from the `add` family of functions
# ===========================================================================================
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

# ======================================== SVG ==============================================

#' Add svg element to the HTML object.
#' @name add_svgs
#' @export
add_svg <- function(my_html, ..., into = "body") {
  content <- if_else(missing(...), "", list(...))
  add_elements(my_html, into, htmltools::tag("svg", content))
}

#' Add image SVG element to the HTML object.
#' @name add_svgs
#' @export
add_image <- function(my_html, ..., into = "body") {
  content <- if_else(missing(...), "", list(...))
  add_elements(my_html, into, htmltools::tag("image", content))
}

# ===================================== Containers ===========================================
#' @rdname add_containers
#' @export
add_span <- set_default(add$span, into = "body")

#' @rdname add_containers
#' @export
add_div <- set_default(add$div, into = "body")

#' @rdname add_containers
#' @export
add_row <- set_default(add$div, into = "body", class = "row")

#' @rdname add_containers
#' @export
add_column <- set_default(add$div, into = "body", class = "column")

#' @rdname add_containers
#' @export
add_item <- set_default(add$div, into = "body", class = "item")

#' @rdname add_containers
#' @export
add_container <- set_default(add$div, into = "body", class = "container")

# ================================== Text and titles ========================================
#' @rdname add_texts
#' @export
add_text <- set_default(add$span, into = "body")

#' @rdname add_texts
#' @param size integer from 1 to 6; size of the title. 1 is the largest.
#' @export
add_title <- function(my_html, ..., size = 3, into = "body") {
  fun <- paste0("h", size)
  set_default(add[[fun]], into = into)(my_html, ...)
}

# =================================== Input widgets =========================================
#' @rdname add_widgets
#' @export
add_button <- set_default(add$input, into = "body", type = "button")

#' @rdname add_widgets
#' @export
add_slider <- set_default(add$input, into = "body", type = "range")

#' @rdname add_widgets
#' @export
add_radio_button <- set_default(add$input, into = "body", type = "radio")

# add_dropdown_list <- function(my_html, options, labels, ..., into = "body") {
#   if (missing(labels)) labels <- options
#   assertthat::assert_that(length(options) == length(labels))
#   add$select(my_html, into,
#              purrr::map(
#                seq_along(labels),
#                ~htmltools::tags$option(value = options[.x], labels[.x])
#              ), ...)
# }

# ====================================== Style =============================================
#' @rdname add_styles
#' @description Adds inline style to the HTML object.
#' @export
add_style <- set_default(add$style, into = "head")

#' @rdname add_styles
#' @description Adds style from external links.
#' @export
add_style_from_link <- set_default(add$link, into = "head", rel = "stylesheet")

#' @rdname add_styles
#' @description Adds a style script from local file; currently this is done inline.
#' @param my_html An HTML object, e.g. output from create_html().
#' @param href character; path to the local css file.
#' @export
add_style_from_file <- function(my_html, href, ...) {
  inline = T
  if (inline) return(add_style(my_html, JS_(readLines(href)), ...))
  add_style_from_link(my_html, href = href, ...)
}

#' @rdname add_styles
#' @export
add_google_style <- set_default(
  add_style_from_link,
  href = "https://fonts.googleapis.com/icon?family=Material+Icons"
)

#' @rdname add_styles
#' @export
add_bootstrap_style <- set_default(
  add_style_from_link,
  href = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css",
  integrity = "sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u",
  crossorigin = "anonymous"
)


# ====================================== Script =============================================
#' @rdname add_scripts
#' @description Adds inline script to HTML.
#' @export
add_script <- set_default(add$script, into = "body")

#' @rdname add_scripts
#' @description Adds a script from an external link.
#' @export
add_script_from_link <- set_default(add$script, into = "head")

#' @rdname add_scripts
#' @description Adds a script from local file; this is done inline or via data UCI.
#' @param my_html An HTML object, e.g. output from create_html().
#' @param src character; path to the local JS file.
#' @param inline T or F; if T, the entire content of the file is copied to the HTML.
#' @param mime Used if inline = F. The mime type of the UCI data. See reference for more detail.
#' @references MIME types \url{https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types}
#' @export
add_script_from_file <- function(my_html, src, inline = T, mime = "application/javascript", ...) {
  if (inline) return(add_script(my_html, JS_(readLines(src)), ...))
  src <- base64enc::dataURI(mime = mime, file = src)
  add_script_from_link(my_html, src = src, ...)
}

#' @rdname add_scripts
#' @description Adds commonly used javascript liberaries via external links. 
#' A note would be made when this function is called.
#' @param js_libs A character vector. The JavaScript libraries to use. Currently support 'plotly', 'p5', 'd3' and 'vega'.
#' @param offline T or F; if T, a local version of the file would be used.
#' @export
add_js_library <- function(my_html, js_libs, offline = F) {
  list_links <- js_src(offline)
  if (!any(js_libs %in% names(list_links))) {
    return(my_html)
  }
  
  if (!offline)
    cat("Note: When the html file is served, it'll download JavaScript libraries from:\n")
    
  for (lib0 in js_libs) {
    if (lib0 %in% names(list_links)) {
      link <- list_links[[lib0]]
      if (offline) {
        my_html %<>% add_script_from_file(src = link, inline = F)
      } else {
        my_html %<>% add_script_from_link(src = link)  
      }
      cat("  ", link, "\n")
    }
  }
  my_html
}


js_src <- function(offline = F) {
  # JS libraries source links
  if (!offline) {
    lib_link <- list(
      jquery = "https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js", 
      p5 = "https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.5.16/p5.js",
      plotly = "https://cdn.plot.ly/plotly-latest.min.js",
      vega = "https://vega.github.io/vega/vega.min.js",
      d3 = "https://d3js.org/d3.v4.min.js"
    )
  } else {
    filenames <- c("jquery.min.js", "p5.js", "plotly-latest.min.js",
                   "vega.min.js", "d3.v4.min.js")
    listnames <- c("jquery", "p5", "plotly", "vega", "d3")
    lib_link <- filenames %>% 
      purrr::map(~system.file("js", .x, package = "rjs")) %>% 
      setNames(listnames)
  }
  lib_link
}


# ====================================== Functional =============================================
#' Add a list of div's to the HTML
#' @param my_html An HTML object; output from 'create_html'.
#' @param add_fun function; the add-html5-tag function to be called.
#' @param args_list a list of lists containing the arguments to pass to \code{add_fun}.
#' @param n integer; number of elements to add.
#' @param into characters; an identifier. It could be a tag name, an element id or a class name.
#' @param ... (Optional) Other parameters to pass to \code{add_fun}.
#' @examples
#' create_html() %>% map_add(add_row, list(id = make_id("row", 1:5)))
#' @export
map_add <- function(my_html, add_fun, args_list, n, into = "body", ...) {
  if (missing(n) && missing(args_list)) 
    stop("One of 'n' and 'list0' must be present.") 
  
  if (missing(args_list)) 
    args_list <- list(rep("", n))
  
  if (length(into) > 1) {
    args_list <- append(list(into = into), args_list)
    return(add_array(my_html, add_fun, args_list, ...))
  }
    
  add_array(my_html, add_fun, args_list, into = into, ...)
}

# Use `add_fun` to add an array of elements with `ids` into a specific tag `into`.
add_array <- function(my_html, add_fun, list0, ...) {
  preduce(list0, add_fun, .init = my_html, ...)
}
