# R Demonstrators

This folder contains functionality to show how the ESA CCI Toolbox can be used together with the R programming language. R is widely used, in particular in scientific communities, for statistical purposes and data visualization. As it stands alongside Python as a very popular language, over time numerous methods to bridge the gap between these languages have been developed. In consequence, we are able to show several different methods. Our focus here rather is on covering a broad scope than an in-depth examination of one method. 

To be concrete, we show the following:

1. Two R-Scripts that internally call the ESA CCI Toolbox Python Package. Data is opened, operations are performed, and the resulting data is visualized using R functionality. There is one script for a gridded dataset and one for a vector dataset.

2. An R package ectR that is a wrapper around core functions of the Toolbox Python Package.

3. A Jupyter Notebook in which both Python and R code is executed (this re-uses the example with gridded data from #1).

4. A Python Module in which R code is executed (this re-uses the example with gridded data from #1).

## Preparation

To run the different parts of the demonstrator, it is necessary to install the environment ect-r defined in environment.yml. This environment will install both Python and R packages. 

Of these, the following are of particular importance for this demonstrator:
- rpy2(https://rpy2.github.io/doc/latest/html/introduction.html): A Python package that allows to run R code and access R objects from Python
- pyarrow(https://arrow.apache.org/docs/python/index.html): Python Bindings to the Apache Airflow Package, a system to store and move data
- r-arrow(https://arrow.apache.org/docs/r/): R Bindings to the Apache Airflow Package, a system to store and move data
- r-ggplot2(https://ggplot2.tidyverse.org/): R package for creating visualisation
- r-maps(https://cran.r-project.org/web/packages/maps/index.html): R package to display maps
- r-reticulate(https://rstudio.github.io/reticulate/): R package to access Python in R scripts
- r-sf(https://r-spatial.github.io/sf/): R-package for handling of vector data (simple feature)

To install the environment, use 

```
$ conda env create -f environment.yml
$ conda activate ect-r
```

## 1. Use Python in R Scripts

This is exemplified through scripts `raster_data.r` and `vector_data.r` which show the handling of different types of data. 

In `raster_data.r`, the following steps are taken:
1. The core package of the Toolbox Python Package is imported
2. A gridded dataset from the Ocean Colour ECV is loaded ("ESACCI-OC-L3S-OC_PRODUCTS-MERGED-8D_DAILY_4km_GEO_PML_OCx_QAA-2022-fv6.0.zarr") using the imported package
3. The ops package (containing the operations) is imported.
4. The `select_var` and `subset_temporal` operations are used to make the dataset smaller (we are looking at six variables depicting total absorption coefficients at different wavelengths in the year 2015)
5. The `tseries_point` operation is used to extract a time series for a location south of the Irawaddy Delta, Myanmar
6. After transfer to an R object and minor preprocessing, the time series for the six variables are plotted using the ggplot2 package.
7. The plot is saved in the output folder as `absorption_time_series.png`

In `vector_data.r`, the following occurs:
1. The core package of the Toolbox Python Package is imported
2. A vector dataset from the Green House Gases ECV is loaded ("esacci.GHG.satellite-orbit-frequency.L2.CO2.multi-sensor.multi-platform.EMMA.v2-2a.r1") using the imported package. The dataset is already imported with the restrictions to show only the column-average dry-air mole fraction of atmospheric carbon dioxide (xco2) in June 2010
3. The resulting geopandas geodataframe is written as a geoparquet file `xco2_june_2010.parquet`
4. The file is read back in as r simple features object
5. The data is plotted onto a world map
6. The world map is saved in the output folder as `xco2_june_2010.png`

Both examples can be run from the command line with Rscript:

```
$ Rscript raster_data.r
```

and

```
$ Rscript vector_data.r
```

## 2. Have an R Wrapper around the Python Package

A wrapper provides a more convenient way to access the Toolbox Python Package. It removes the need to use the reticulate package and allows to use the toolbox functions as regular r functions. This procedure, however, requires that each API function must be wrapped individually. Therefore, for the sake of sticking to the concept of a demonstrator, we only converted the functions:
- `open_data` -> `ect_core`
- `list_ecvs` -> `list_ecvs`
- `list_ecv_datasets` -> `list_ecv_datasets`

To use the package, it must be installed with:

```bash
R CMD INSTALL ectR
```

The setup of the `ectR` folder is as follows:
- DESCRIPTION; Describes the Package and its dependencies
- LICENSE: License File
- NAMESPACE: publishes the R-functions provided by the package
- R: Contains files `ect-open.R` and `list.R` which provides the actual wrappings around the Python functions, along with validation checks and extensive annotations
- man: Contains documentation files extracted from the annotations in the `R` folder
- tests: Contains tests of the R functions. The tests may be executed with
```
Rescript tests/testthat/test-api.R
```

## 3. Accessing R and the Toolbox from a Jupyter Notebook

The steps undertaken in the aforementioned `raster_data.R` are provided in the Jupyter Notebook `ect_r_demo.ipynb`. The main difference is that the first cells are executed purely in Python, i.e., without the use of the `reticulate` package. Instead, the rpy2 package is used. It allows to set an annotation `%%R` to specify cells which are to be interpreted as R files. In the notebook, this concept is used to run a cell which creates a visualisation and saves it to the output folder. Lastly, it shows how results from the R computation are returned as Python objects and may be used as such in the further execution of the notebook.

## 4. Using R in Python Scripts

This last part of the demonstrator once more uses the workflow from `raster_data.R`. It is a pure Python module, which uses the rpy2 package. The difference to the notebook approach is that not annotations are used but sube-packages and modules. In the module, processing steps are divided into a function that performs the Python step (`open_time_series`) and a function that performs the R step (`analyze_with_r`). The resulting figure is saved to the output folder as `absorption_time_series_use_r_in_python.png`.

