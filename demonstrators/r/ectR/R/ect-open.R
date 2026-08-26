.ect_core <- function() {
  conda <- Sys.which("conda")
  if (!nzchar(conda)) {
    stop("Conda is not available on PATH.", call. = FALSE)
  }

  reticulate::use_condaenv(
    "ect-r",
    conda = conda,
    required = TRUE
  )
  reticulate::import(
    "esa_climate_toolbox.core",
    convert = FALSE
  )
}

#' Open data with the ESA CCI Toolbox
#'
#' Open data through the Python-based ESA CCI Toolbox. The result remains a
#' Python object and is not converted to R.
#'
#' @param dataset_id Non-empty ECT dataset identifier.
#' @param data_store_id Optional ECT data-store identifier.
#' @param ... Additional parameters passed to ECT's `open_data()`, such as
#'   `time_range`, `region`, or `var_names`.
#'
#' @return A Python object such as an `xarray.Dataset` or
#'   `geopandas.GeoDataFrame` proxy.
#' @export
#'
#' @examples
#' \dontrun{
#' ocean_colour <- ect_open(
#'   paste0(
#'     "ESACCI-OC-L3S-OC_PRODUCTS-MERGED-8D_DAILY_4km_",
#'     "GEO_PML_OCx_QAA-2022-fv6.0.zarr"
#'   ),
#'   data_store_id = "esa-cci-zarr"
#' )
#'
#' xco2 <- ect_open(
#'   paste0(
#'     "esacci.GHG.satellite-orbit-frequency.L2.CO2.multi-sensor.",
#'     "multi-platform.EMMA.v2-2a.r1"
#'   ),
#'   data_store_id = "esa-cci",
#'   var_names = "xco2",
#'   time_range = c("2010-06-01", "2010-06-30")
#' )
#' }
ect_open <- function(dataset_id, data_store_id = NULL, ...) {
  if (!is.character(dataset_id) ||
      length(dataset_id) != 1L ||
      is.na(dataset_id) ||
      !nzchar(dataset_id)) {
    stop("`dataset_id` must be one non-empty string.", call. = FALSE)
  }

  if (!is.null(data_store_id) &&
      (!is.character(data_store_id) ||
       length(data_store_id) != 1L ||
       is.na(data_store_id) ||
       !nzchar(data_store_id))) {
    stop("`data_store_id` must be NULL or one non-empty string.", call. = FALSE)
  }

  ect_core <- .ect_core()
  opened <- do.call(
    ect_core$open_data,
    c(
      list(
        dataset_id = dataset_id,
        data_store_id = data_store_id
      ),
      list(...)
    )
  )

  reticulate::py_get_item(opened, 0L)
}
