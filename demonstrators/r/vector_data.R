dataset_id <- paste0(
  "esacci.GHG.satellite-orbit-frequency.L2.CO2.multi-sensor.",
  "multi-platform.EMMA.v2-2a.r1"
)
data_store_id <- "esa-cci"
time_range <- c("2010-06-01", "2010-06-30")

output_dir <- "output"
geoparquet_file <- file.path(output_dir, "xco2_june_2010.parquet")
plot_file <- file.path(output_dir, "xco2_june_2010.png")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

suppressPackageStartupMessages(library(reticulate))
use_condaenv(
  "ect-r",
  conda = Sys.which("conda"),
  required = TRUE
)

message("Python configuration:")
print(py_config())

ect_core <- import("esa_climate_toolbox.core", convert = FALSE)

message("Opening vector dataset:")
message("  ID:    ", dataset_id)
message("  store: ", data_store_id)
message("  time:  ", paste(time_range, collapse = " to "))

data_store <- ect_core$get_store(data_store_id)

ghg_gdf <- data_store$open_data(
  data_id = dataset_id,
  variable_names = r_to_py(list("xco2"), convert = FALSE),
  time_range = r_to_py(as.list(time_range), convert = FALSE)
)

message("Dataset opened successfully: ", dataset_id)

# Keep only the measurement and geometry used by the R visualization. The
# explicit conversion creates a Python list for GeoPandas column selection.
selected_columns <- r_to_py(
  list("xco2", "geometry"),
  convert = FALSE
)
xco2_gdf <- ghg_gdf$`__getitem__`(selected_columns)
xco2_gdf <- xco2_gdf$dropna(subset = selected_columns)

source_crs <- "EPSG:4326"

geoparquet_path <- normalizePath(
  geoparquet_file,
  mustWork = FALSE
)
invisible(
  xco2_gdf$to_parquet(
    geoparquet_path,
    index = FALSE
  )
)

message("Reduced vector data written to: ", geoparquet_path)

suppressPackageStartupMessages(library(arrow))
suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(maps))

xco2_arrow <- arrow::read_parquet(geoparquet_path)
xco2_table <- as.data.frame(xco2_arrow)

required_columns <- c("xco2", "geometry")
missing_columns <- setdiff(required_columns, names(xco2_table))
if (length(missing_columns) > 0) {
  stop(
    "GeoParquet result is missing required columns: ",
    paste(missing_columns, collapse = ", "),
    call. = FALSE
  )
}

xco2_geometry <- st_as_sfc(
  structure(xco2_table$geometry, class = "WKB"),
  EWKB = TRUE,
  crs = source_crs
)

xco2_sf <- st_sf(
  xco2_table[setdiff(names(xco2_table), "geometry")],
  geometry = xco2_geometry
)

xco2_sf <- xco2_sf[is.finite(xco2_sf$xco2), ]

if (nrow(xco2_sf) == 0) {
  stop("No finite xco2 observations are available for the plot.", call. = FALSE)
}

message("Observations transferred to R: ", nrow(xco2_sf))
print(xco2_sf)

world_map <- map_data("world")

xco2_plot <- ggplot() +
  geom_polygon(
    data = world_map,
    aes(x = long, y = lat, group = group),
    fill = "grey95",
    colour = "grey55",
    linewidth = 0.25
  ) +
  geom_sf(
    data = xco2_sf,
    aes(colour = xco2),
    size = 1,
    alpha = 0.8
  ) +
  scale_colour_viridis_c(
    name = expression(XCO[2] ~ (ppm)),
    option = "C"
  ) +
  coord_sf(
    crs = st_crs(4326),
    default_crs = st_crs(4326),
    xlim = c(-180, 180),
    ylim = c(-90, 90),
    expand = FALSE
  ) +
  labs(
    title = expression("Satellite observations of atmospheric " * XCO[2]),
    subtitle = "ESA CCI GHG EMMA v2.2a, June 2010",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal() +
  theme(
    panel.grid.minor = element_blank(),
    legend.position = "right"
  )

ggsave(
  filename = plot_file,
  plot = xco2_plot,
  width = 11,
  height = 6,
  units = "in",
  dpi = 150
)

message("Plot written to: ", normalizePath(plot_file))
