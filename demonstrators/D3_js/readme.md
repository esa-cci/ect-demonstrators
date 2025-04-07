# D3.js Demonstrators

In this folder, we present how the [ESA CCI Toolbox](https://github.com/esa-cci/esa-climate-toolbox) 
can be used together with D3.js.
D3.js, or D3, is short for Data Driven Documents.
It is a open-source JavaScript library for visualizing data.
It was originally created in 2011 and has since been found ample use,
and it has been extended by many contributors.
D3.js is a low-level library. 
It is extremely flexible, allowing users to define exactly the kind of visualisation 
they have in mind.
Whilst this approach makes sense for organizations that receive very large audiences 
or that have a large team of editors behind it, in most cases it makes sense to use
one of the many visualisation libraries or tools that have been built on top of D3.js.
Such libraries have been designed to provide a fast and user-friendly means to create
customizable and re-usable designs.
For the purpose of this demonstrator, we found it makes sense to use these libraries,
as they show the easiest way to use D3.js with CCI Data accessed through and processed 
by the CCI Toolbox, thereby allowing and encouraging users to create their own 
visualisations - due to the flexibility of D3.js, these may be of arbitrary complexity.

## Vega/Altair

We will use two different libraries built on D3.js. 
The first one is [Altair](https://altair-viz.github.io/). 
Altair is a declarative visualisation library which provides a Python API for 
[Vega-Lite](https://vega.github.io/vega-lite/), a high-level grammar of interactive 
graphics. Vega-Lite in turn is based on [Vega](https://vega.github.io/vega/), which 
is a language for visualisation designs that 
[heavily uses D3.js](https://vega.github.io/vega/about/vega-and-d3/). 
Vega and Vega-Lite are used by the 
[xcube-viewer](https://github.com/xcube-dev/xcube-viewer), so for more examples on the
visualisations that can be achieved with D3.js, we'd like to refer you to the 
sections of the ESA CCI Toolbox Documentation that handle the usage of the xcube viewer
with the Toolbox:

https://esa-climate-toolbox.readthedocs.io/en/latest/notebooks/Advanced_Functionality/1-ECT_Using_xcube_viewer.html

https://esa-climate-toolbox.readthedocs.io/en/latest/viewer.html

## Plotly

The other library introduced in this demonstrator is 
[plotly](https://plotly.com/python/).
Plotly is the Python version of the high-level charting library plotly.js, which bases
directly on D3.js. 
Plotly offers a range of charts and visualisation types that may be used in Jupyter 
Notebooks or HTML pages.

## Notebooks

Using these libraries, we created three notebooks.
In the first one, we show an advanced example on the change of **land cover** class 
membership. The second notebook portrays how uncertainties may be visualised, based on
__cloud__ data, whilst the last one handles the issue of multi-dimensional data, exemplified 
by __ozone__ data with a profile dimension.
