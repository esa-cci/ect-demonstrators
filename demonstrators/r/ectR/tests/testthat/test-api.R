# These tests access the live ESA CCI stores and require an internet connection.
# They are intended for occasional checks, not for regular test runs.

library(testthat)
library(ectR)

test_that("ect_open", {
  dataset <- ect_open(
    paste0(
      "ESACCI-OC-L3S-OC_PRODUCTS-MERGED-8D_DAILY_4km_",
      "GEO_PML_OCx_QAA-2022-fv6.0.zarr"
    ),
    data_store_id = "esa-cci-zarr",
    time_range = c("2022-01-01", "2022-01-31"),
    region = c(96.4, 16.2, 96.5, 16.3),
    var_names = "atot_412"
  )

  expect_true(reticulate::py_has_attr(dataset, "data_vars"))
  expect_error(ect_open(""))
})

test_that("list_ecvs", {
  ecvs <- list_ecvs()

  expect_gt(length(ecvs), 0L)
  expect_true("GHG" %in% unlist(ecvs))
})

test_that("list_ecv_datasets", {
  datasets <- list_ecv_datasets("GHG")

  expect_gt(length(datasets), 0L)
  expect_error(list_ecv_datasets(""))
})
