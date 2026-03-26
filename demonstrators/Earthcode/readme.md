## EarthCODE Demonstrator

This Demonstrator serves to show how a workflow that works on CCI Data and uses the operations provided by the ESA CCI Toolbox to create a new product can be published to the Open Science Catalog provided by EarthCODE. 
This work was undertaken on DeepESDL, an EO platform that is part of the EarthCODE ecosystem.
The demonstrator thereby serves not only to showcase the capabilities of the ESA CCI Toolbox, but also of EarthCODE, which aims at providing scientists platforms for collaborative development as well as means to make their results and workflows accessible to others.

The structure of this demonstrator is as follows:

In the folder named `workflow` you will find
 * another readme, describing the workflow
 * a notebook that computes global sea surface salinity anomalies
 * an environment.yml file that describes the environment in which the notebook was executed
This folder has the content that will later be referenced from the Open Science Catalog.

In the folder `publishing` you will find yet another readme that describes the publishing process in detail. You will also find a notebook that puts the dataset resulting from the workflow onto a s3 bucket, and the configuration files that were used for the publishing process. 

