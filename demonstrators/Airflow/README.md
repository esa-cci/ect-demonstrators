# Airflow Demonstrator

This is currently in development and experimental.
It has been tested on Linux environment.

Pre-requisites:

- Docker (use this [link](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) to install it if you do not have it already)
- Mamba (from [here](https://github.com/conda-forge/miniforge))

This demo consists of running a basic DAG (directed acyclic graph) on Airflow
with two simple steps:
1. Build a docker image that packages both the frontend and backend servers 
(a basic HTTP server and hello-world react app created from 
`npx create-react-app frontend`)
2. Start this container image.

The above demo is to show that we can trigger Docker containers using Airflow.

Steps:

1. Create a mamba environment where Airflow will run locally. To do that, run
```shell
    mamba env create
```
This should install all the libraries required. If there are some missing, 
please add them to the `environment.yml` file.

2. Export some variables 
```shell
    export AIRFLOW_HOME=$(pwd)
    export AIRFLOW__CORE__LOAD_EXAMPLES=false
```


3. Update the `hello_world_dag.py` where required.

4. Run Airflow
```shell
    airflow standalone
```
This will start an airflow server available at http://0.0.0.0:8080

5. Trigger the DAG.
Inside the DAGs tab in Airflow, you will find the DAG 
`build_and_run_hello_world_docker`, trigger it and wait for it to complete.

6. View the output from frontend and backend server at the URL provided in the 
`Logs` tab of the Airflow DAG execution.

Frontend will be available at port `8000`

Backend will be available at port `5000`

7. The current setup is really basic and simple. 
One has to make sure to mark the task as `Success` in Airflow UI in order to 
finish the DAG execution. 
This will be improved later. 
Keep in mind: This does not automatically shutdown the container. 
You would have to do that manually.