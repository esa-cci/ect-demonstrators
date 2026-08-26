\name{ect_open}
\alias{ect_open}
\title{Open data with the ESA Climate Toolbox}
\usage{
ect_open(
  dataset_id,
  data_store_id = NULL,
  ...
)
}
\arguments{
\item{dataset_id}{Non-empty ECT dataset identifier.}
\item{data_store_id}{Optional ECT data-store identifier.}
\item{...}{Additional parameters passed to the corresponding ECT opener.}
}
\value{
A Python object such as an \code{xarray.Dataset} or \code{geopandas.GeoDataFrame} proxy. The object is not converted to R.
}
\description{
Opens raster or vector data through the Python-based ESA Climate Toolbox using the \code{ect-r} Conda environment.
}
