#!/bin/sh
#SBATCH -J maxwell-sim
#SBATCH --nodelist=g001
#SBATCH -c 2
#SBATCH --mem=8GB

# Clear the environment from any previously loaded modules
module purge > /dev/null 2>&1

# Load the module environment suitable for the job
module load gcc/9.2.0
module load cuda/11.4
module load mpich/4.0

export PATH=/usr/local/cuda-11.4/targets/x86_64-linux/lib:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-11.4/lib64:$LD_LIBRARY_PATH

export OMP_NUM_THREADS=2
export MAXWELL_SERVER_FILES=/tmp/maxwell-server-files

python maxwell-server/simserver.py 1 &> simserver.log

module unload mpich/4.0
module unload cuda/11.4
module unload gcc/9.2.0
