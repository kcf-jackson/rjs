#' Add a grid of div's to the HTML
#' @param my_html An HTML object; output from 'create_html'.
#' @param nr integer; number of rows to add.
#' @param nc integer; number of columns to add.
#' @param first "row" or "column"; if "row" first, then create `nr` rows, then in each row
#' make `nc` columns, and vice versa.
#' @param into Characters; an identifier. It could be a tag name, an element id or a class name.
#' @export
#' @examples
#' create_html() %>% add_grid(3, 4, first = "row")
add_grid <- function(my_html, nr, nc, first = "row", into = "body") {
  assertthat::assert_that((nc >= 1) && (nr >= 1))
  if (first == "row") {
    param <- list(fst = "row", fst_fun = add_row, snd = "col", snd_fun = add_column)
    dimn <- c(nr, nc)
  } else {
    param <- list(fst = "col", fst_fun = add_column, snd = "row", snd_fun = add_row)
    dimn <- c(nc, nr)
  }
  fst_ids <- paste0(param$fst, "_", seq(dimn[1]))
  my_html %<>% map_add(param$fst_fun, args_list = list(id = fst_ids), into = into)
  for (i in fst_ids) {
    snd_ids <- paste0(i, "_", param$snd, "_", seq(dimn[2]))
    my_html %<>% map_add(param$snd_fun, args_list = list(id = snd_ids), into = i)
  }
  my_html
}


#=============================================================================================
# Widgets
#=============================================================================================
#' Google style button
#' @description Adds google material-design icon / button.
#' @param my_html An HTML object; output from 'create_html'.
#' @param material_id Material id from google material design, e.g. "play_circle_outline". More other options, see \url{https://material.io/icons/}.
#' @param ... Element contents and attributes; attrbutes must be named. See references for
#' HTML5-tags guides.
#' @param into characters; an identifier. It could be a tag name, an element id or a class name.
#' @note The default cursor over the icon is set to be a pointer. Use "style = 'cursor: xxx'" for other
#' options. A list of options can be found at
#' \url{https://www.w3schools.com/cssref/playit.asp?filename=playcss_cursor&preval=pointer}.
#' @export
add_google_style_button <- function(my_html, material_id, ..., into = "body") {
  tag_append <- htmltools::tagAppendAttributes
  button_html <- htmltools::tag("i", material_id) %>%
    tag_append(class = "material-icons")

  if (!missing(...)) {
    if (!("style" %in% names(list(...)))) {
      button_html %<>% tag_append(style = "cursor: pointer;")
    }
    button_html %<>% tag_append(...)
  }

  add_elements(my_html, into, button_html)
}


#' Add a toggle button with google material design
#' @param my_html An HTML object; output from 'create_html'.
#' @param into characters; an identifier. It could be a tag name, an element id or a class name.
#' @param widget_id character; an unique identifier for the widget.
#' @param material_1 Material id from google material design, e.g. "play_circle_outline". More other options, see \url{https://material.io/icons/}.
#' @param material_2 Material id from google material design, e.g. "pause_circle_outline". More other options, see \url{https://material.io/icons/}.
#' @param ... Element contents and attributes for the widgets (div); attrbutes must be named. See references for
#' HTML5-tags guides.
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
#' @examples
#' \dontrun{
#' create_html() %>%
#'   add_google_style() %>%
#'   add_google_toggle_button(into = "body", widget_id = "gbutton_1") %>%
#'   start_app()
#' }
#' @note The two material-icons should have the same size.
#' @export
add_google_toggle_button <- function(my_html, into = "body", widget_id,
                                     material_1 = "play_circle_outline",
                                     material_2 = "pause_circle_outline", ...) {
  id_1 <- make_id(widget_id, material_1)
  id_2 <- make_id(widget_id, material_2)
  onclick_call <- sprintf("toggle_%s()", widget_id)
  onclick_run <- sprintf("
function toggle_%s() {
  var state = document.getElementById('%s').style.display;
  if (state != 'none') {
    document.getElementById('%s').style.display = 'inline';
    document.getElementById('%s').style.display = 'none';
  } else {
    document.getElementById('%s').style.display = 'inline';
    document.getElementById('%s').style.display = 'none';
  }
}", widget_id, id_1, id_2, id_1, id_1, id_2)

  my_html %>%
    add_div(into = into, id = widget_id, style = "justify-content:center;", ...) %>%
    add_google_style_button(into = widget_id, material_id = material_1, id = id_1,
                            style = "display:inline; cursor:pointer;",
                            onclick = onclick_call) %>%
    add_google_style_button(into = widget_id, material_id = material_2, id = id_2,
                            style = "display:none; cursor:pointer;",
                            onclick = onclick_call) %>%
    add_script(onclick_run)
}


#' Counter widget
#' A counter widget consists of a label and a counter (<label> + <span>).
#' @param my_html An HTML object; output from 'create_html'.
#' @param into characters; an identifier. It could be a tag name, an element id or a class name.
#' @param widget_id character; an unique identifier for the widget.
#' @param label (optional) character; the label text.
#' @param label_id (optional) character; an unique identifier for the label.
#' Default to be "XXX_label", where XXX is the widget_id.
#' @param counter (optional) numeric; starting value of the counter.
#' @param counter_id (optional) character; an unique identifier for the counter.
#' Default to be "XXX_counter", where XXX is the widget_id.
#' @examples
#' \dontrun{
#' create_html() %>%
#'   add_counter(widget_id = "counter_1") %>%
#'   start_app()
#' }
#' @export
add_counter <- function(my_html, into = "body", widget_id,
                        label = "My Counter", label_id,
                        counter = 0, counter_id) {
  if (missing(label_id)) label_id <- paste(widget_id, "label", sep = "_")
  if (missing(counter_id)) counter_id <- paste(widget_id, "counter", sep = "_")
  my_html %>%
    add$div(into = into, id = widget_id) %>%
      add$label(into = widget_id, label, id = label_id, "for" = counter_id) %>%
      add$span(into = widget_id, counter, id = counter_id)
}


#' Slider widget
#' A slider widget consists of 2 labels and a slider (<span> + <label> + <input>)
#' @param my_html An HTML object; output from 'create_html'.
#' @param into characters; an identifier. It could be a tag name, an element id or a class name.
#' @param widget_id character; an unique identifier for the widget.
#' @param label (optional) character; the label text.
#' @param label_id (optional) character; an unique identifier for the label.
#' Default to be "XXX_label", where XXX is the widget_id.
#' @param value (optional) numeric; starting value of the slider.
#' @param slider_id (optional) character; an unique identifier for the counter.
#' Default to be "XXX_slider", where XXX is the widget_id.
#' @param ... Element contents and attributes for the slider; attrbutes must be named.
#' See references for HTML5-tags guides.
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
#' @examples
#' \dontrun{
#' create_html() %>%
#'   add_slider_with_text(widget_id = "slider_1") %>%
#'   start_app()
#' }
#' @export
add_slider_with_text <- function(my_html, into = "body", widget_id,
                       label = "My Slider", label_id,
                       value = 50, slider_id, ...) {
  if (missing(label_id)) label_id <- paste(widget_id, "label", sep = "_")
  if (missing(slider_id)) slider_id <- paste(widget_id, "slider", sep = "_")
  output_id <- paste(widget_id, "output", sep = "_")
  change_script <- sprintf("%s.value = value", output_id)
  my_html %>%
    add$div(into = into, id = widget_id) %>%
      add$span(into = widget_id, label, id = label_id) %>%
      add$output(into = widget_id, value, id = output_id, "for" = slider_id) %>%
      add$input(into = widget_id, id = slider_id, type = "range",
                oninput = change_script, value = value, ...)
}


#' Radio button group
#' @param my_html An HTML object; output from 'create_html'.
#' @param into characters; an identifier. It could be a tag name, an element id or a class name.
#' @param widget_id character; an unique identifier for the widget.
#' @param values vector; the underlying values of the selections.
#' @param labels character vector; the labels shown in the app.
#' @param stack T or F; if TRUE, the radio buttons are stacked vertically.
#' @param ... Element contents and attributes for the radio widget; attrbutes must be named.
#' See references for HTML5-tags guides.
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
#' @export
add_radio_button_group <- function(my_html, into, widget_id, values, labels, stack = T, ...) {
  stack_radio_button <- function(my_html, into, ...) {
    my_html %>%
      add_radio_button(into = into, ...) %>%
      add$br(into = into)
  }
  add_radio_fun <- if_else(stack, stack_radio_button, add_radio_button)
  map_add(my_html, add_radio_fun, into = into, name = widget_id,
          list(value = values, labels), ...)
}
