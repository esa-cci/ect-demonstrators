# Airflow Demonstrator

This demonstrator has been tested on a Linux environment.

It shows how Apache Airflow can be used to run a workflow including functionality from the ESA Climate Toolbox. 
As stated on their [website](https://airflow.apache.org/), Apache Airflow is a platform created by the community to programmatically author, schedule and monitor workflows.
Workflows are defined once and may be rerun multiple times.
They come in the form of Directed Acyclic Graphs (DAGs).
For this demonstrator, we have set up such a dag, which can be seen in the file `dag_config.yaml` in the dags folder.
You can read more about specifics of how a configuration file can be set up [here](https://github.com/bcdev/gaiaflow/blob/main/%7B%7B%20cookiecutter.folder_name%20%7D%7D/dags/change_me_config.yml).
We explain the particularities of the DAG in the following section, if you want to run the demonstrator immediately, go to [Prerequisites]((#prerequisites-to-run-the-demonstrator)).

## The Directed Acyclic Graph (DAG)

The dag is specified in the section `esa_climate_toolbox_ops_dag`. This is the name under which the dag will later be found in the UI.

In this section, there are sub-sections `task_groups` and `tasks`.
Task Groups are helpful to group tasks, which can come in handy for large processes.
Here, we only specify one group, `ect_tasks`.
In `tasks`, we dfine the actual sub processes.
There are three of them:
- `chain` runs a chain of ESA Climate Toolbox Operations on a dataset and writes the result to disk
- `plot` creates a plot from this result
- `delete_folder` deletes the folder that included the data written by the `chain` task

Tasks `chain` and `plot` are Python tasks - and hence use a PythonOperator - whilst `delete_folder` merely executs a bash command, so it uses a `BashOperator`, as can be seen in the respective task's entries for the field `operator`. 
Besides these, there is a large sum of operators, many of whom have been designed to cater to specific tasks (if you are interested, you can find a full list [here](https://registry.astronomer.io/modules?typeName=Operators&_gl=1*1s3aunx*_up*MQ..*_ga*NTEyMzEyNy4xNzQ3ODMyNDM2*_ga_W97HK48NPT*czE3NDc4MzI0MzUkbzEkZzAkdDE3NDc4MzI0MzUkajAkbDAkaDA.*_ga_14DHW7X721*czE3NDc4MzI0MzUkbzEkZzAkdDE3NDc4MzI0MzUkajAkbDAkaDA.)).

Python operators must point to a specific Python function. This function can either be provided by a package (as is the case in the `chain` task, where we point to the `execute_operations` function from the ESA CCI Toolbox, which allows to run multiple operations consecutively (and which is documented [here](https://esa-climate-toolbox.readthedocs.io/en/latest/api_reference.html#esa_climate_toolbox.core.execute_operations))) or as a dedicated Python function, which we did for the `plot` task, where the function `plot_chain_output` is provided in the module `plot_functions.py` in the `dags/functions` folder.
Note that it would have been possible to add the plotting operation to the chain, but for the purposes of this demonstrator, we wanted to show two different approaches.
Both Python operators receive their parameters from the `op_kwargs` sections in the tasks. 
For the `chain` task, you see that we pick an aerosol dataset as input, create temporal, spatial, and thematic subsets, and ultimately write the result to an output_folder.
This provides a way to run ESA Climate Toolbox operations without interacting with Python directly.
For the `plot` task, we pick one of the variables of the dataset to plot and pick a name for the output file (for visualisation purposes, we here choose a region that is slightly larger than the subset region defined in `chain`).
What's further of importance to point out for the tasks is that it is here where we specify the pertinence of a task to a task group (in `task_group_name`) and define dependencies between tasks in dependencies. 
The dependency `[ chain ]` in `plot` says that the task `plot` will not start before the task `chain` has finished.
Finally, `do_xcom_push` is set to False, which means that no information is passed between tasks.

The last task, `delete_folder`, ultimately executes the bash command which deletes the folder with the output from `chain`. Remove this task if you want to keep the result.

## Prerequisites to run the Demonstrator

To run this demonstrator, you need mamba (from [here](https://github.com/conda-forge/miniforge)), alternatively conda.
When you have mamba configured, you can create a dedicated environment using the provided file `environment.yml`.
To do that, run
```shell
    mamba env create -f environment.yml
```
This will install all the libraries required.
Next, export the following environment variables 
```shell
    export AIRFLOW_HOME=$(pwd)
    export AIRFLOW__CORE__LOAD_EXAMPLES=false
```
The first one will make the current folder the working directory, so that all outputs are written there.
The second one will prevent other dags from being loaded in, which makes it easier to keep an overview.
Next, switch to the environment you had just created.
```shell
    mamba activate airflow-ect
```
You can now run Airflow as a stand-alone server.
```shell
    airflow standalone
```

Running this will create a long output. In this output, you will find a username (which is admin) and a password which changes on every restart.
Also, this will start an airflow server available at http://0.0.0.0:8080 .
Open this address in your browser, where you will be asked for the username and password.
After providing the credentials, you will see the start screen, with the DAG `esa_climate_toolbox_ops_dag` loaded in.
At the far right, there is a green arrow which allows to trigger the DAG.
If you then click on the name of the DAG, you are brought to a page where you can see the state of processing.
In the `graph` view, you can see the individual tasks, grouped in the task group. 
If you select one of the tasks and then `Logs`, you see information on the progress.
If all tasks have finished, in your working directory there will be a file `airflow_plot.png` showing aerosol optical thickness at 550 nm over Europe on May 20th, 2002.

