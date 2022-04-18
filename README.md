Maxwell is a multi-GPU implementation of finite-difference frequency domain solver.
This code is intended to be used in conjunction with SPINS (github.com/stanfordnqp/spins-b).

Overview
========
Maxwell is implemented as a server to which SPINS can send simulations to be run.
This allows the actual simulation server (i.e. where the GPUs are) to be located separately
from where the rest of the optimization code is running, though it is recommended to keep
SPINS and Maxwell on the same machine if possible.

At its core, running Maxwell involves running two separate services:
1. A webserver `maxwell-server/webserver.py` that manages sending and receiving simulation data over HTTP.
2. A simserver `maxwell-server/simserver.py` that manages running the simulations.
Both services must be up and running for Maxwell to function properly.

Maxwell can run in the follow methods:
1) Use the Dockerfile provided. This is the preferred mechanism as it creates an isolated environment for Maxwell.
2) Manually launching the webserver and simserver. This allows for most fine-grain control.


Docker
======
We have Dockerized the Maxwell solver to make solver maintenance easier.
In addition to CUDA Toolkit, all other Maxwell dependencies are listed in the Dockerfile.

Installation
------------
1. Install Docker (http://docker.com).
2. Install CUDA 10.0 Toolkit (https://developer.nvidia.com/cuda-10.0-download-archive).
3. Install NVIDIA-Docker (https://github.com/NVIDIA/nvidia-docker).

Usage
-----
The Dockerfile is contained the root Maxwell directory.
We have also provided a script to build and launch the Docker container:

$ ./run_docker

To change the number of GPUs used per simulation, edit the `run_docker` script and set `NGPUS` to the desired value.

Docker Quick Reference
----------------------
To list all running containers,

$ docker ps ls

To kill a container,

$ docker kill [container-name-or-id]

To clean up all containers (dead containers still take up disks space),

$ docker system prune --volumes

To examine the container state, launch an interactive bash session:

$ docker exec -it [container-name-or-id] bash


Manual Installation
===================
Maxwell can be manually installed. Follow the installation procedure listed in
`Dockerfile` for the installation procedure. See `./start_maxwell` for an
example of how to launch Maxwell manually.

```bash
" Install system packages
sudo apt-get update
sudo apt-get install -y python3-pip
sudo apt-get install -y python3-setuptools 
sudo apt-get install -y libhdf5-serial-dev 
sudo apt-get install -y mpich

" Create virtual environment
python3 -m venv venv/

" Load virtual environment
source venv/bin/activate

" Install dependencies
pip3 install -r requirements.txt

" Run program
bash start_maxwell.sh &
```


Options
=======

1. Work directory: Maxwell requires a folder to store temporary data.
   This location is specified by the environment variable `MAXWELL_SERVER_FILES`
   that must be set for Maxwell to run. Maxwell must have permissions to read
   and write to this directory.
2. Port number: The webserver by default runs on port 9041. This can be changed
   by changing the argument passed to `webserver.py`
   (e.g. `python webserver.py 9042). If using Docker, change the `PORT` variable
   in `./run_docker`. Note that the port number change must be reflected in
   `spins` as well in order for this to work.
3. Number of GPUs per solve: By default, Maxwell will attempt to use 1 GPU
   per simulation. For larger simulations, it may be beneficial to use multiple
   GPUs per simulation. This can be used by changing the `NGPUS` value.


Troubleshooting
===============
1. Check the Maxwell server log files.

Maxwell consists of two separate servers: `webserver.py` manages sending and receiving data
and `simserver.py` manages running the actual simulations. Both servers save logs named `webserver.log` and
`simserver.log` respectively.

2. Check the individual simulation log files.

Every simulation maintains its own log file. This can be found under `$MAXWELL_SERVER_FILES` directory.
By default, the Docker sets this location to be `/mnt/maxwell-server-files` in the container.


Acknowledgements
================
This code is primarily based off of https://github.com/JesseLu/maxwell-solver.
