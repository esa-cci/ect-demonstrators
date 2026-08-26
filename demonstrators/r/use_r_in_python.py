"""Open ESA CCI data in Python and visualize the reduced result with R."""

from pathlib import Path

import pandas as pd
from esa_climate_toolbox import core, ops
from rpy2 import robjects
from rpy2.robjects import conversion, default_converter, pandas2ri


DATASET_ID = (
    "ESACCI-OC-L3S-OC_PRODUCTS-MERGED-8D_DAILY_4km_GEO_PML_OCx_QAA-2022-fv6.0.zarr"
)
DATA_STORE_ID = "esa-cci-zarr"
ATOT_VARIABLES = [
    "atot_412",
    "atot_443",
    "atot_490",
    "atot_510",
    "atot_560",
    "atot_665",
]


def open_time_series() -> pd.DataFrame:
    """Open the lazy raster cube and compute only the selected point series."""
    print(f"Opening dataset from {DATA_STORE_ID} ...")
    ocean_colour_ds, opened_from_store = core.open_data(
        dataset_id=DATASET_ID,
        data_store_id=DATA_STORE_ID,
    )
    print(f"Opened from store: {opened_from_store}")

    atot_ds = ops.select_var(ds=ocean_colour_ds, var=ATOT_VARIABLES)
    atot_ds = ops.subset_temporal(
        ds=atot_ds,
        time_range=["2015-01-01", "2015-12-31"],
    )
    atot_ts = ops.tseries_point(ds=atot_ds, point="96.44,16.23")

    # This is the deliberate computation boundary. Only the reduced dataset
    # with one point, six variables, and 46 time steps is loaded into memory.
    absorption_table = (
        atot_ts.to_dataframe()
        .reset_index()
        [["time", *ATOT_VARIABLES]]
    )
    absorption_table["time"] = pd.to_datetime(absorption_table["time"])
    return absorption_table


def analyze_with_r(
    absorption_table: pd.DataFrame,
    output_file: Path,
) -> pd.DataFrame:
    """Pass a Pandas table to R, create a plot, and return an R summary."""
    with conversion.localconverter(default_converter + pandas2ri.converter):
        robjects.globalenv["absorption_table"] = conversion.py2rpy(
            absorption_table
        )

    robjects.globalenv["output_file"] = robjects.StrVector([str(output_file)])

    robjects.r(
        r'''
        library(ggplot2)

        atot_variables <- c(
          "atot_412", "atot_443", "atot_490",
          "atot_510", "atot_560", "atot_665"
        )

        absorption_long <- data.frame(
          time = rep(
            absorption_table$time,
            times = length(atot_variables)
          ),
          wavelength = rep(
            sub("^atot_", "", atot_variables),
            each = nrow(absorption_table)
          ),
          absorption = unlist(
            absorption_table[atot_variables],
            use.names = FALSE
          )
        )

        absorption_long$wavelength <- factor(
          absorption_long$wavelength,
          levels = sub("^atot_", "", atot_variables)
        )
        absorption_long <- absorption_long[
          !is.na(absorption_long$absorption),
        ]

        wavelength_labels <- setNames(
          paste0(
            "Total absorption at ",
            sub("^atot_", "", atot_variables),
            " nm"
          ),
          sub("^atot_", "", atot_variables)
        )

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
            subtitle = "ESA CCI Ocean Colour, 2015",
            x = NULL,
            y = expression(a[tot] ~ (m^{-1}))
          ) +
          theme_minimal() +
          theme(
            panel.grid.minor = element_blank(),
            strip.text = element_text(face = "bold")
          )

        ggsave(
          filename = output_file[[1]],
          plot = absorption_plot,
          width = 10,
          height = 8,
          units = "in",
          dpi = 150
        )

        absorption_summary <- aggregate(
          absorption ~ wavelength,
          data = absorption_long,
          FUN = mean
        )
        names(absorption_summary)[2] <- "mean_absorption"
        '''
    )

    with conversion.localconverter(default_converter + pandas2ri.converter):
        return conversion.rpy2py(robjects.globalenv["absorption_summary"])


def main() -> None:
    output_file = Path("output/absorption_time_series_use_r_in_python.png")
    output_file.parent.mkdir(parents=True, exist_ok=True)

    absorption_table = open_time_series()
    print(f"Passing {len(absorption_table)} rows from Python to R ...")
    absorption_summary = analyze_with_r(absorption_table, output_file)

    print(f"Plot written to: {output_file.resolve()}")
    print("Summary returned from R to Python:")
    print(absorption_summary.to_string(index=False))


if __name__ == "__main__":
    main()
