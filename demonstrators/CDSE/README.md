# CDSE Demonstrators

In this folder, we present how the [ESA CCI Toolbox](https://github.com/esa-cci/esa-climate-toolbox) 
can be used together with Data from the Copernicus Dataspace Ecosystem (CDSE). 
The CDSE provides Data and Services from the Copernicus Sentinel Missions.
As such, it suggests itself to show how to match it against ECV Data that 
has been derived from Sentinel missions.
We also show how operations from the ESA CCI Toolbox or the underlying Python 
technology stack may be applied to improve the display or combination of data.

The demonstrator consists of two Jupyter Notebooks:
In the first one, we show how to match a FIRE dataset against single Sentinel-2 Observations,
in the other one, we match LST Data with a Data Cube created from Sentinel-3 SLSTR Data.
In both cases, the CDSE Data is accessed using xcube data stores which are included in the 
xcube-stac plugin. 
To obtain this - and other - required Python packages, please consider the environments.yml file
which comes with the demonstrator and which may assist you with building a dedicated 
environment.
If you already have an environment, make sure you have the following components installed:
- esa-climate-toolbox
- xcube-stac
- jupyterlab
- libgdal-netcdf

Also, while access to the CDSE is free, you still need to register.
In particular, to use the stores, you will need to provide a set of credentials.
To do see, please go to https://documentation.dataspace.copernicus.eu/APIs/S3.html#registration

When you have the credentials, you are set to execute the demonstrators.
