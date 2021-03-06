% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/documentation.R, R/html_builder.R
\name{add_styles}
\alias{add_styles}
\alias{add_style}
\alias{add_style_from_link}
\alias{add_style_from_file}
\alias{add_google_style}
\alias{add_bootstrap_style}
\title{Helper functions to add element to HTML}
\usage{
add_style(...)

add_style_from_link(...)

add_style_from_file(my_html, href, ...)

add_google_style(...)

add_bootstrap_style(...)
}
\arguments{
\item{...}{Takes three arguments for \code{add_style} and \code{add_style_from_link}.

\code{my_html} An HTML object, e.g. output from create_html().  

\code{into} Characters; an identifier. It could be a tag name, an element id or a class name. 
Default is set to "head".  

\code{...} Element contents and attributes; attrbutes must be named. See references for 
HTML5-tags guides.}

\item{my_html}{An HTML object, e.g. output from create_html().}

\item{href}{character; path to the local css file.}
}
\description{
Three ways to add style to HTML: \code{add_style}, \code{add_style_from_link} and
\code{add_style_from_file}.

Adds inline style to the HTML object.

Adds style from external links.

Adds a style script from local file; currently this is done inline.
}
\references{
Quick guide to HTML tags \url{https://www.nobledesktop.com/html-quick-guide/}
}
