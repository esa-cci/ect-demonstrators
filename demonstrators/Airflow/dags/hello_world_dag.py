from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.docker.operators.docker import DockerOperator
from datetime import datetime

default_args = {
    "owner": "airflow",
    "start_date": datetime(2025, 4, 10),
}

with DAG("build_and_run_hello_world_docker", default_args=default_args, schedule_interval=None, catchup=False) as dag:

    build_docker_image = BashOperator(
        task_id="build_docker_image",
        bash_command="docker build -t hello-world-demo -f "
                     "/change/absolute/path/to/Dockerfile "
                     "/change/absolute/path/to/root/where/dockerfile/exists"
    )

    run_docker_container = DockerOperator(
        task_id="run_hello_world_container",
        image="hello-world-demo",
        api_version="auto",
        docker_url="unix://var/run/docker.sock",
        network_mode="bridge"
    )

    build_docker_image >> run_docker_container
