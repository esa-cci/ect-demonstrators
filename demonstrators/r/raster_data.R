dataset_id <- paste0(
  "ESACCI-OC-L3S-OC_PRODUCTS-MERGED-8D_DAILY_4km_",
  "GEO_PML_OCx_QAA-2022-fv6.0.zarr"
)
data_store_id <- "esa-cci-zarr"

suppressPackageStartupMessages(library(reticulate))
use_condaenv(
  "ect-r",
  conda = Sys.which("conda"),
  required = TRUE
)

# Disable automatic return-value conversion so that the large xarray object
# stays in Python and retains its lazy Dask arrays.
ect_core <- import("esa_climate_toolbox.core", convert = FALSE)

message("Opening dataset:")
message("  ID:    ", dataset_id)

opened <- ect_core$open_data(
  dataset_id = dataset_id,
  data_store_id = data_store_id
)

# ECT returns (data_object, data_store_id). Because `opened` remains a Python
# tuple, its indices are zero-based. Use py_get_item() to make that explicit.
ocean_colour_ds <- py_get_item(opened, 0L)
opened_from_store <- py_to_r(py_get_item(opened, 1L))

message("Dataset opened successfully from store: ", opened_from_store)

ect_ops <- import("esa_climate_toolbox.ops", convert = FALSE)

atot_variables <- c(
    "atot_412",
    "atot_443",
    "atot_490",
    "atot_510",
    "atot_560",
    "atot_665"    
)

atot_ds <- ect_ops$select_var(
    ds = ocean_colour_ds, 
    var = atot_variables
)

print(atot_ds)

time_range <- c(
    "2015-01-01",
    "2015-12-31"
)

atot_ds <- ect_ops$subset_temporal(
    ds = atot_ds, 
    time_range = time_range
)

print(atot_ds)

irawaddy_delta <- "96.44,16.23"

atot_ts = ect_ops$tseries_point(
    ds = atot_ds,
    point = irawaddy_delta,
)

print(atot_ts)

atot_table <- py_to_r(
  atot_ts$to_dataframe()$reset_index()
)

# Convert the six value columns from wide to long format for ggplot2. Using
# base R here keeps the example independent of an additional tidyr package.
absorption_long <- data.frame(
  time = rep(atot_table$time, times = length(atot_variables)),
  wavelength = rep(
    sub("^atot_", "", atot_variables),
    each = nrow(atot_table)
  ),
  absorption = unlist(atot_table[atot_variables], use.names = FALSE)
)

absorption_long$wavelength <- factor(
  absorption_long$wavelength,
  levels = sub("^atot_", "", atot_variables)
)

# Remove missing observations so that each line connects all available
# measurements. This does not interpolate or otherwise replace missing values.
absorption_long <- absorption_long[!is.na(absorption_long$absorption), ]

wavelength_labels <- setNames(
  paste0(
    "Total absorption at ",
    sub("^atot_", "", atot_variables),
    " nm"
  ),
  sub("^atot_", "", atot_variables)
)

suppressPackageStartupMessages(library(ggplot2))

absorption_plot <- ggplot(
  absorption_long,
  aes(x = time, y = absorption, group = 1)
) +
  geom_line(linewidth = 0.6, colour = "#2166ac") +
  geom_point(size = 1.2, colour = "#2166ac") +
  facet_wrap(
    vars(wavelength),
    ncol = 2,
    scales = "fixed",
    labeller = as_labeller(wavelength_labels)
  ) +
  labs(
    title = "Total absorption at the Irrawaddy Delta",
    subtitle = "ESACCI-OC-L3S-OC_PRODUCTS-MERGED-8D_DAILY_4km_GEO_PML_OCx_QAA-2022-fv6.0.zarr, 2015",
    x = NULL,
    y = expression(a[tot] ~ (m^{-1}))
  ) +
  theme_minimal() +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold")
  )

output_dir <- "output"
output_file <- file.path(output_dir, "absorption_time_series.png")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

ggsave(
  filename = output_file,
  plot = absorption_plot,
  width = 10,
  height = 8,
  units = "in",
  dpi = 150
)

message("Plot written to: ", normalizePath(output_file))
