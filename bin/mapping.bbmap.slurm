#!/bin/bash
###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=180GB
#SBATCH --cpus-per-task=20
#SBATCH --time=12:00:00
#SBATCH --partition=cpu2019,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate bbtools

###### Run your script ######

for f in *_final.contigs.fa
do
	contig=$f
	contign=$(basename $f _final.contigs.fa)
	
	for r in *_pass_1.qc.fastq
	do
		sample=$(basename $r _pass_1.qc.fastq)
		
		bbmap.sh -Xmx10g ref=${contig} nodisk in=${sample}_pass_1.qc.fastq in2=${sample}_pass_2.qc.fastq minid=0.95 threads=40 outm=${sample}_${contign}.bbmap.bam bs=bs.sh; sh bs.sh >& ${sample}_${contign}.bbmap.log.txt
	done
done

##
echo "Job finished with exit code $? at: `date`"
##
