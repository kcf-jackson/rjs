% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/html_extra.R
\name{add_counter}
\alias{add_counter}
\title{Counter widget
A counter widget consists of a label and a counter (<label> + <span>).}
\usage{
add_counter(my_html, into = "body", widget_id, label = "My Counter",
  label_id, counter = 0, counter_id)
}
\description{
Counter widget
A counter widget consists of a label and a counter (<label> + <span>).
}
\examples{
create_html() \%>\% 
  add_counter(widget_id = "counter_1") \%>\% 
  start_app()
}