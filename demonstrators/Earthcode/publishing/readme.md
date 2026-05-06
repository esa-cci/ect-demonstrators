## Publishing to EarthCODE

This folder compiles the functionality that is required to publish a dataset and a workflow onto EarthCODE (or, to be concise, the [Open Science Catalog](https://opensciencedata.esa.int/)).

### Pushing the Dataset

Before we publish, we first put the dataset in a place where it can be publically accessed. 
For this, we have the notebook `Publish_dataset.ipynb` which you can find in this folder. 
This notebook first establishes access to the s3 storage that is available for the team. 
We then open the dataset that has been created in the process described in the `workflow` folder.
We adjust a few of the properties (such as the dataset title and the attributes of the anomalies variable), then we write the dataset as a zarr file to the s3 bucket.

While our dataset is in a good condition now, the teams storage is still not public. 
Therefore, we contacted deep-esdl support and ask them to move the dataset to the main `deep-esdl` bucket.
Also, while we were at it, we asked to include it in the [ESDL Viewer](https://viewer.earthsystemdatalab.net/) so it can be immediately accessed from the outside.

### Creating the Configuration Files

The actual publishing process can be performed in several manners (as indicated in the [EarthCODE Documentation](https://esa-earthcode.github.io/documentation/Technical%20Documentation/Open%20Science%20Catalog/Contributing%20to%20the%20Open%20Science%20Catalog)).
For this, we may use the OSC Publishing GUI or build a STAC collection manually.
For the purposes of this demonstrator and given the fact that we are working on DeepESDL, we will use [deep-code](https://deepesdl.github.io/deep-code/), which is a Python package aimed at facilitating the publishing process.
The basic principle is to use command line commands and provide all required information for the publishing process in configuration files.

Template files for the configuration can be created with the command

```
deep-code generate-config
```

In this folder, we include both the templates that were used to create the configurations (`dataset_config_template.yaml` and `workflow_config_template.yaml`) and the actual configurations (`actual_dataset_config.yaml` and `actual_workflow_config.yaml`).

In the dataset confguration, you will see that we put as link to the documentation a link to the CEDA catalogue entry of the original dataset. 
We also added a description of the anomaly variable.
We set the parameter `stac_catalog_s3_root` to be next to the data in the s3 bucket, DeepESDL support provided us with keys for `STAC_S3_KEY` and `STAC_S3_SECRET` which we then set as environment variables.
Furthermore, we set the project to `Knowledge Exchange`, which causes the project to be established on the Open Science Catalog.
Lastly, for the visualisation link we add the link to the dataset in the DeepESDL Viewer.

For the workflow configuration, we created a tag of the current version of the notebook and environment named `ect-demo`.
You can see it in the links to the environment file (https://github.com/esa-cci/ect-demonstrators/blob/ect-demo/demonstrators/Earthcode/workflow/environment.yml) and the jupyter notebook (https://github.com/esa-cci/ect-demonstrators/blob/ect-demo/demonstrators/Earthcode/workflow/sss-anomalies.ipynb).

### Publishing the Data and the Workflow

We now were mostly set to actually publish, the one last thing to do was to set a file `.gitaccess` to include our github name along with a Personal Access Token, as described in the `Getting Started` section of the [deep-code documentation](https://deepesdl.github.io/deep-code/getting-started/) (this file is not included in this demonstrator, as its sole purpose is to contain private credentials).
Afterwards, we could run the publishing command:

```
deep-code publish actual_dataset_config.yml actual_workflow_config.yml
```

During the publishing process, we were asked to provide a link to a GCMD keyword describing the variable. From the [EarthData GCMD Keyviewer](https://gcmd.earthdata.nasa.gov/KeywordViewer/scheme/all?gtm_scheme=all), we looked up the link to [Ocean Salinity](https://gcmd.earthdata.nasa.gov/KeywordViewer/scheme/all/1a4e5774-7d4a-4ce7-9a4c-e2c72c8c377f?gtm_keyword=OCEAN%20SALINITY&gtm_scheme=sciencekeywords).
In this publishing routine, a STAC structure is created.
Ultimately, the publishing process finished, and a pull request was created at https://github.com/ESA-EarthCODE/open-science-catalog-metadata/pull/499 .
An automatic check is performed (if something should go wrong here, you might have a look at the results from the GitHub Action) or, which is recommended, ask DeepESDL support.
If the check is successful, the PR is reviewed by ESA EarthCODE personnel, giving a few more suggestions on what to change so the entries appear correctly in the Catalog.

The entries are as follows:
The [workflow](https://opensciencedata.esa.int/stac-browser/#/workflows/sss-cci-global-anomalies/record.json) entry describes the steps taken to derive at the result.
The [experiment](https://opensciencedata.esa.int/experiments/sss-cci-global-anomalies/record) describes the application of the workflow to derive at the application's output.
The [product](https://opensciencedata.esa.int/stac-browser/#/products/sss-monthly-anomalies/collection.json) then shows the actual dataset that has been created.
Also, we created a [project](https://opensciencedata.esa.int/stac-browser/#/projects/knowledge-exchange/collection.json) site for the CS CCI Knowledge Exchange project.
