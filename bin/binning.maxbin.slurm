#!/bin/bash
###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=160GB
#SBATCH --time=01:00:00
#SBATCH --partition=cpu2019,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate maxbin2

###### Run your script ######

for f in *_final.contigs.fa
do 
  sample=$(basename $f _final.contigs.fa)
  mkdir ${sample}_maxbin.out 
  run_MaxBin.pl -thread 40 -contig ${sample}_final.contigs.fa -abund_list ${sample}_abundance.list -out ${sample}_maxbin.out/${sample}_maxbin >& ${sample}.maxbin2.log.txt
done

##
echo "Job finished with exit code $? at: `date`"
##
