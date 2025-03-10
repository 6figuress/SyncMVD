#!/bin/bash
#SBATCH --partition=Dance
#SBATCH --job-name=syncmvd
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=4G
#SBATCH --time=02:00:00
#SBATCH --gres=gpu:1

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

# Print Python and environment information
echo "Testing container Python environment:"
apptainer exec --nv image.sif bash -c "source /opt/conda/activate_env.sh && which python && python --version && echo PYTHONPATH=\$PYTHONPATH"

# Log the command being executed
echo "Executing: apptainer run --nv image.sif --config $@"

# Execute apptainer with explicit environment sourcing
apptainer run --nv \
    --env PYTHONPATH=/opt/conda/envs/syncmvd/lib/python3.8/site-packages \
    --bind $(pwd)/data:/opt/SyncMVD/data \
    --bind $(pwd)/logs:/opt/SyncMVD/logs \
    image.sif --config "$@"

# Print job completion information
echo "Job completed at $(date)"
