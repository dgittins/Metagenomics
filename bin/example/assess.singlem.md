#!/bin/bash

###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=50GB
#SBATCH --time=05:00:00
#SBATCH --partition=cpu2019,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate singlem

###### Run your script ######

for f in ./*_pass_1.fastq.gz
do
	sample=$(basename $f _pass_1.fastq.gz)
	singlem pipe -1 ${sample}_pass_1.fastq.gz -2 ${sample}_pass_1.fastq.gz -p ${sample}.singlem.profile.tsv
done

##
echo "Job finished with exit code $? at: `date`"
##
