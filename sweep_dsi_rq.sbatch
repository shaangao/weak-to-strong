#!/bin/bash
#SBATCH --job-name=w2s
#SBATCH --output=/home/shangao/weak-to-strong/results/logs/%u/%A.out
#SBATCH --error=/home/shangao/weak-to-strong/results/logs/%u/%A.err
#SBATCH --time=12:00:00
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --gres=gpu:1
#SBATCH --constraint=a100
#SBATCH --mem-per-cpu=64G

#SBATCH --mail-type=ALL  # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=shangao@uchicago.edu  # mail notification for the job
#SBATCH --open-mode=append # So that outcomes are appended, not rewritten
#SBATCH --signal=SIGUSR1@90
echo $SLURM_RESTART_COUNT



# set dir to weak-to-strong folder and call this script in command line with:
#   sbatch sweep_dsi_rq.sbatch

# or to run interactively, request session with:
#   srun -p general -t "12:00:00" --mem "64G" --cpus-per-task 2 --gres gpu:1 --constraint a100 --pty /bin/bash



# run training
srun python sweep.py \
    --model_sizes gpt2,gpt2-xl \
    --ds_name anthropic_hh
    # --ds_name amazon_polarity



# Requeue job if job didn't finish within the requested time limit
if [ $? -eq 0 ]; then   # check if the last executed command executed successfully
    echo "Job completed successfully"
else
    echo "Requeuing the job"
    scontrol requeue $SLURM_JOB_ID
fi