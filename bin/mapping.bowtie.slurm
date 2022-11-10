#!/bin/bash
###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=180GB
#SBATCH --time=48:00:00
#SBATCH --partition=cpu2021,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate bowtie2

###### Run your script ######

#Build an index of the assembly

for f in *_final.contigs.fa
do
	sample=$(basename $f _final.contigs.fa)
	bowtie2-build -f ${sample}_final.contigs.fa ${sample}.bowtie.contigs --threads 48
done


#Map quality controlled reads to the indexed assembly

for f in *.bowtie.contigs.1.bt2
do
	contig=$(basename $f .bowtie.contigs.1.bt2)
	
	for r in *_pass_1.qc.fastq
	do
		read=$(basename $r _pass_1.qc.fastq)
		bowtie2 -x ${contig}.bowtie.contigs -1 ${read}_pass_1.qc.fastq -2 ${read}_pass_2.qc.fastq --threads 48 -q --local | samtools view -bS --threads 48 | samtools sort --threads 48 -o ${read}_${contig}.bowtie.sorted.bam
	done
done


#Index the sorted bam file

for f in *.bowtie.sorted.bam
do
	samtools index -@ 48 $f
done

##
echo "Job finished with exit code $? at: `date`"
##
