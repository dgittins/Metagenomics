#!/bin/bash
###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=160GB
#SBATCH --cpus-per-task=20
#SBATCH --time=05:00:00
#SBATCH --partition=cpu2019,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate metaspades

###### Run your script ######

#Individual assembly
for f in *_pass_1.qc.fastq
do
  sample=$(basename $f _pass_1.qc.fastq)
  metaspades.py -1 ${sample}_pass_1.qc.fastq -2 ${sample}_pass_1.qc.fastq -t 40 -m 160 -o ${sample}_metaspades.assembly >& ${sample}_metaspades.log.txt
done

#Co-assembly
cat *_pass_1.qc.fastq > all_pass_1.qc.fastq #concatenate forward reads into a single file
cat *_pass_2.qc.fastq > all_pass_2.qc.fastq #concatenate reverse reads into a single file

metaspades.py -1 all_pass_1.qc.fastq -2 all_pass_2.qc.fastq -t 40 -m 160 -o Song_metaspades.coassembly >& Song_metaspades.coassembly.log.txt

##
echo "Job finished with exit code $? at: `date`"
##

