#' Helper functions to add element to HTML
#' @name add_family
#' @description The add_* functions are divided into 6 categories. See 
#' \link{add_containers}, \link{add_texts}, \link{add_widgets}, \link{add_scripts}, 
#' \link{add_styles} and \link{add_svgs}.
#' @param ... Takes three arguments: 
#' 
#' \code{my_html} An HTML object, e.g. output from create_html(). 
#' 
#' \code{into} Characters; an identifier. It could be a tag name, an element id or a class name.  
#' 
#' \code{...} Element contents and attributes; attrbutes must be named. See references for 
#' HTML5-tags guides. 
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
NULL


#' Helper functions to add element to HTML
#' @name add_containers
#' @description A container is either a <span> tag or a <div> tag. 
#' General usage: <span> is for inline elements, and <div> is for elements that occupy an entire line.
#' \code{add_X} is \code{add_div} with class initialised to be \code{X}. 
#' See \link{add_grid} for adding many containers at once.
#' @param ... Takes three arguments.
#' 
#' \code{my_html} An HTML object, e.g. output from create_html().
#' 
#' \code{into} Characters; an identifier. It could be a tag name, an element id or a class name. 
#' 
#' \code{...} (Optional) Element contents and attributes; attrbutes must be named. See references for 
#' HTML5-tags guides. 
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
#' @examples
#' \dontrun{
#' create_html() %>% 
#'   add_span("I am a span") %>% 
#'   add_span("I am a span 2") %>% 
#'   start_app()
#' 
#' create_html() %>% 
#'   add_div("I am a div") %>% 
#'   add_div("I am a div2") %>% 
#'   start_app()
#'
#' create_html() %>% 
#'   add_row("I am row 1", id = "row_1", style = "margin-left:50px") %>% 
#'   add_row("I am row 2", id = "row_2", style = "margin-top: 50px") %>% 
#'     add_div(into = "row_1", "Content 1") %>% 
#'     add_div(into = "row_2", "Content 2") %>% 
#'   start_app()
#' }
NULL


#' Helper functions to add element to HTML
#' @name add_svgs
#' @param my_html An HTML object, e.g. output from create_html().
#' @param into Characters; an identifier. It could be a tag name, an element id or a class name. 
#' @param ... Element contents and attributes; attrbutes must be named. See references for 
#' HTML5-tags guides. 
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
NULL


#' Helper functions to add element to HTML
#' @name add_texts
#' @description There are two functions in this class: \code{add_text} and \code{add_title}.
#' \code{add_text} is <span> tag and \code{add_title} is a <hX> tag, X from 1 to 6.
#' @param my_html An HTML object, e.g. output from create_html().
#' @param into Characters; an identifier. It could be a tag name, an element id or a class name. 
#' @param ... Element contents and attributes; attrbutes must be named. See references for 
#' HTML5-tags guides. 
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
#' @examples 
#' \dontrun{
#' create_html() %>% 
#'   add_title("This is a title") %>% 
#'   add_title("This is a subtitle", size = 4) %>% 
#'   add_text("Some description of your website here") %>% 
#'   start_app()
#' }
NULL


#' Helper functions to add element to HTML
#' @name add_widgets
#' @description A widget is a <input> tag most of the time. Currently support
#' \code{add_button}, \code{add_slider} and \code{add_radio_button}. 
#' Other types can be added via the general \code{add$input(type = "XXX")} syntax.
#' Compound widgets can be formed using primitive widgets, see for example 
#' \link{add_google_style_button}, \link{add_google_toggle_button}, 
#' \link{add_counter}, \link{add_slider_with_text} and \link{add_radio_button_group}.
#' @param ... Takes three arguments.
#' 
#' \code{my_html} An HTML object, e.g. output from create_html().
#' 
#' \code{into} Characters; an identifier. It could be a tag name, an element id or a class name. 
#' 
#' \code{...} Element contents and attributes; attrbutes must be named. See references for 
#' HTML5-tags guides. 
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
#' @examples 
#' \dontrun{
#' create_html() %>% 
#'   add_title("Button demo") %>% 
#'   add_button(value = "A Button") %>% 
#'   start_app()
#' 
#' create_html() %>% 
#'   add_title("Slider demo") %>% 
#'   add_slider() %>% 
#'   start_app()
#' 
#' create_html() %>% 
#'   add_title("Radio button demo") %>% 
#'   add_radio_button("A option") %>% 
#'   start_app()
#' }
NULL


#' Helper functions to add element to HTML
#' @name add_scripts
#' @description Four ways to add script to HTML: \code{add_script}, \code{add_script_from_link}, 
#' \code{add_script_from_file} and \code{add_js_library}.
#' @param ... Takes three arguments for \code{add_script} and \code{add_script_from_link}.
#' 
#' \code{my_html} An HTML object, e.g. output from create_html().
#' 
#' \code{into} Characters; an identifier. It could be a tag name, an element id or a class name. 
#' 
#' \code{...} Element contents and attributes; attrbutes must be named. See references for 
#' HTML5-tags guides. 
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
NULL


#' Helper functions to add element to HTML
#' @name add_styles
#' @description Three ways to add style to HTML: \code{add_style}, \code{add_style_from_link} and
#' \code{add_style_from_file}.
#' @param ... Takes three arguments for \code{add_style} and \code{add_style_from_link}.  
#'
#' \code{my_html} An HTML object, e.g. output from create_html().  
#'
#' \code{into} Characters; an identifier. It could be a tag name, an element id or a class name. 
#' Default is set to "head".  
#'
#' \code{...} Element contents and attributes; attrbutes must be named. See references for 
#' HTML5-tags guides.  
#' @references Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
NULL
