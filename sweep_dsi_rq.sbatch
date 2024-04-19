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
# sbatch sweep_dsi_rq.sbatch

# or to run interactively, request session with:
# srun -p general -t "12:00:00" --mem "64G" --cpus-per-task 2 --gres gpu:1 --constraint a100 --pty /bin/bash



# run training
srun python sweep.py \
    --model_sizes gpt2,gpt2-xl \
    --ds_name amazon_polarity

# srun python scripts/train.py \
#                  --data-path /net/projects/fermi-2/CHEP2023.gnn.h5 \
#                  --version ${log_name} \
#                  --semantic \
#                  --filter \
#                  --vertex \
#                  --vertex-aggr ${vtx_aggr} \
#                  --vertex-lstm-feats ${vtx_lstm_features} \
#                  --vertex-mlp-feats ${vtx_mlp_features} \
#                  --epochs ${epochs} \
#                  --resume "${logdir}/Vertex_Decoder_Search/${log_name}/checkpoints" \
#                  --logdir ${logdir} \
#                  --name  "Vertex_Decoder_Search"\
#                 #  --limit_train_batches ${lim_train_batches}\
#                 #  --limit_val_batches ${lim_val_batches}\
#                 #  --num_nodes 4 \


# Requeue job if job didn't finish within the requested time limit
if [ $? -eq 0 ]; then   # check if the last executed command executed successfully
    echo "Job completed successfully"
else
    echo "Requeuing the job"
    scontrol requeue $SLURM_JOB_ID
fi