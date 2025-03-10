#!/bin/bash
#SBATCH --partition=Dance        # Partition to run the job on
#SBATCH --job-name=hunyuan3d     # create a short name for your job
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=20       # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G per cpu-core is default)
#SBATCH --time=00:10:00          # total run time limit (HH:MM:SS)
#SBATCH --gres=gpu:1             # number of gpus per node

# Print job details for debugging
echo "Job started at $(date)"
echo "Running on $(hostname)"
echo "GPU information:"
nvidia-smi

# Check if we received any command-line arguments
if [ $# -eq 0 ]; then
    echo "No arguments provided. Usage: sbatch $0 [config_file] [additional_args...]"
    echo "Example: sbatch $0 data/face/config.yaml"
    exit 1
fi

# Create output directory for logs
mkdir -p logs

# Log the command being executed
echo "Executing: apptainer run --nv syncmvd.sif --config $@"

# Execute apptainer with all the arguments passed to this script
apptainer run --nv \
    --bind $(pwd)/data:/opt/SyncMVD/data \
    --bind $(pwd)/logs:/opt/SyncMVD/logs \
    image.sif --config "$@"

# Print job completion information
echo "Job completed at $(date)"
