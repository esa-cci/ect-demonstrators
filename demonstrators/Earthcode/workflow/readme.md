
## About the Workflow

This is a workflow showcasing how the ESA CCI Toolbox can be used to create a dataset that can be published to EarthCODE.
To run the notebook, you need to have a conda environment, for which you can use the `environment.yml` file included in this folder.

The notebook lists all `Sea Surface Salinity` Datasets available through the Toolbox, one of them, which is available in the Kerchunk format, is selected.
As it is provided in a temporal resolution of 15-Days, it is temporally aggregated to a monthly resolution. Afterwards, a climatology is built and the deviations of the data from this climatology are determined, i.e., the anomalies are determined.
All these steps use operations provided by the toolbox.

The result is visualised, the climatology and the anomalies dataset are written to an output folder.
