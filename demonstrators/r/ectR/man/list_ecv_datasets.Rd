\name{list_ecv_datasets}
\alias{list_ecv_datasets}
\title{List datasets for an essential climate variable}
\usage{
list_ecv_datasets(ecv, data_type = NULL, include_attrs = FALSE)
}
\arguments{
\item{ecv}{One non-empty ECV name, as returned by \code{list_ecvs()}.}
\item{data_type}{Optional ECT data type such as \code{"dataset"} or \code{"geodataframe"}.}
\item{include_attrs}{\code{FALSE}, \code{TRUE}, or a character vector naming metadata attributes to include.}
}
\value{
A character vector of dataset identifiers, or a list containing identifiers and attributes when \code{include_attrs} is enabled.
}
\description{
Lists ECT datasets associated with a selected essential climate variable.
}
