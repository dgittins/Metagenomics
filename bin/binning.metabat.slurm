#!/bin/bash
###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=50GB
#SBATCH --time=01:00:00
#SBATCH --partition=cpu2019,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate metabat2

###### Run your script ######

for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	mkdir ${sample}_metabat.out
	metabat2 -i ${sample}_final.contigs.fa -a ${sample}_bowtie.depth.txt -o ${sample}_metabat.out/${sample}_metabat --unbinned -t 40 >& ${sample}.metabat2.log.txt
done

##
echo "Job finished with exit code $? at: `date`"
##
