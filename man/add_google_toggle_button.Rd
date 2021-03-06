% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/html_extra.R
\name{add_google_toggle_button}
\alias{add_google_toggle_button}
\title{Add a toggle button with google material design}
\usage{
add_google_toggle_button(my_html, into = "body", widget_id,
  material_1 = "play_circle_outline", material_2 = "pause_circle_outline",
  ...)
}
\arguments{
\item{my_html}{An HTML object; output from 'create_html'.}

\item{into}{characters; an identifier. It could be a tag name, an element id or a class name.}

\item{widget_id}{character; an unique identifier for the widget.}

\item{material_1}{Material id from google material design, e.g. "play_circle_outline". More other options, see \url{https://material.io/icons/}.}

\item{material_2}{Material id from google material design, e.g. "pause_circle_outline". More other options, see \url{https://material.io/icons/}.}

\item{...}{Element contents and attributes for the widgets (div); attrbutes must be named. See references for 
HTML5-tags guides.}
}
\description{
Add a toggle button with google material design
}
\note{
The two material-icons should have the same size.
}
\examples{
\dontrun{ 
create_html() \%>\% 
  add_google_style() \%>\% 
  add_google_toggle_button(into = "body", widget_id = "gbutton_1") \%>\% 
  start_app()
}
}
\references{
Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
}
