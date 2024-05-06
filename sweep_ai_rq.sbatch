#!/bin/bash
#SBATCH --job-name=w2s
#SBATCH --output=/net/scratch/shangao/weak-to-strong/results/logs/%A.out
#SBATCH --error=/net/scratch/shangao/weak-to-strong/results/logs/%A.err
#SBATCH --time=04:00:00  # hrs:min:sec
#SBATCH --partition=next-gen  # Specify partition; general* written as general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --gres=gpu:1
# SBATCH --nodelist=l001
# SBATCH --constraint=a100
#SBATCH --mem=64G
# SBATCH --mem-per-cpu=64G
# SBATCH --mem-per-gpu=48G

# SBATCH --mail-type=ALL  # Mail events (NONE, BEGIN, END, FAIL, ALL)
# SBATCH --mail-user=shangao@uchicago.edu  # mail notification for the job
# SBATCH --open-mode=append # So that outcomes are appended, not rewritten
# SBATCH --signal=SIGUSR1@90
echo $SLURM_RESTART_COUNT



# set dir to weak-to-strong folder and call this script in command line with:
#   sbatch sweep_ai_rq.sbatch

# or to run interactively, request session with:
#   srun -p general -t "04:00:00" --mem "64G" --cpus-per-task 2 --gres gpu:1 --pty /bin/bash
# and then run script with:
#   python sweep.py --model_sizes gpt2,gpt2-xl --ds_name anthropic_hh


# run training
srun python sweep.py \
    --model_sizes gpt2,gpt2-xl \
    --ds_name anthropic_hh
    # --ds_name boolq
    # --batch_size 16
    # --ds_name amazon_polarity



# Requeue job if job didn't finish within the requested time limit
if [ $? -eq 0 ]; then   # check if the last executed command executed successfully
    echo "Job completed successfully"
else
    echo "Requeuing the job"
    scontrol requeue $SLURM_JOB_ID
fi