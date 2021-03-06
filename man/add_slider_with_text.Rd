% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/html_extra.R
\name{add_slider_with_text}
\alias{add_slider_with_text}
\title{Slider widget
A slider widget consists of 2 labels and a slider (<span> + <label> + <input>)}
\usage{
add_slider_with_text(my_html, into = "body", widget_id, label = "My Slider",
  label_id, value = 50, slider_id, ...)
}
\arguments{
\item{my_html}{An HTML object; output from 'create_html'.}

\item{into}{characters; an identifier. It could be a tag name, an element id or a class name.}

\item{widget_id}{character; an unique identifier for the widget.}

\item{label}{(optional) character; the label text.}

\item{label_id}{(optional) character; an unique identifier for the label. 
Default to be "XXX_label", where XXX is the widget_id.}

\item{value}{(optional) numeric; starting value of the slider.}

\item{slider_id}{(optional) character; an unique identifier for the counter. 
Default to be "XXX_slider", where XXX is the widget_id.}

\item{...}{Element contents and attributes for the slider; attrbutes must be named. 
See references for HTML5-tags guides.}
}
\description{
Slider widget
A slider widget consists of 2 labels and a slider (<span> + <label> + <input>)
}
\examples{
\dontrun{
create_html() \%>\% 
  add_slider_with_text(widget_id = "slider_1") \%>\% 
  start_app()
}
}
\references{
Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
}
