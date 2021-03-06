% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_plot.R
\name{add_plot}
\alias{add_plot}
\title{Add plot into a document object}
\usage{
add_plot(mydoc, plotstring, preprocessing = "", top = 2)
}
\arguments{
\item{mydoc}{A document object}

\item{plotstring}{String of an R code encoding a plot}

\item{preprocessing}{preprocessing}

\item{top}{top position of plot}
}
\value{
a document object
}
\description{
Add plot into a document object
}
\examples{
require(rrtable)
require(officer)
require(rvg)
require(magrittr)
read_pptx() \%>\% add_text(title="Plot") \%>\% add_plot("plot(iris)")
}
