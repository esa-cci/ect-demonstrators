#' List essential climate variables
#'
#' @return A character vector containing the ECV names served by ECT.
#' @export
list_ecvs <- function() {
  ect_core <- .ect_core()
  reticulate::py_to_r(ect_core$list_ecvs())
}

#' List datasets for an essential climate variable
#'
#' @param ecv One non-empty ECV name, as returned by [list_ecvs()].
#' @param data_type Optional ECT data type such as `"dataset"` or
#'   `"geodataframe"`.
#' @param include_attrs `FALSE`, `TRUE`, or a character vector naming metadata
#'   attributes to include.
#'
#' @return A character vector of dataset identifiers. If `include_attrs` is
#'   enabled, a list containing dataset identifiers and attribute lists is
#'   returned instead.
#' @export
list_ecv_datasets <- function(
    ecv,
    data_type = NULL,
    include_attrs = FALSE) {
  if (!is.character(ecv) ||
      length(ecv) != 1L ||
      is.na(ecv) ||
      !nzchar(ecv)) {
    stop("`ecv` must be one non-empty string.", call. = FALSE)
  }

  if (!is.null(data_type) &&
      (!is.character(data_type) ||
       length(data_type) != 1L ||
       is.na(data_type) ||
       !nzchar(data_type))) {
    stop("`data_type` must be NULL or one non-empty string.", call. = FALSE)
  }

  if (!is.logical(include_attrs) && !is.character(include_attrs)) {
    stop("`include_attrs` must be logical or a character vector.", call. = FALSE)
  }
  if (is.logical(include_attrs) && length(include_attrs) != 1L) {
    stop("Logical `include_attrs` must have length one.", call. = FALSE)
  }

  ect_core <- .ect_core()
  result <- ect_core$list_ecv_datasets(
    ecv = ecv,
    data_type = data_type,
    include_attrs = include_attrs
  )
  reticulate::py_to_r(result)
}
