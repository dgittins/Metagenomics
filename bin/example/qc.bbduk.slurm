#!/bin/bash
###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20GB
#SBATCH --cpus-per-task=10
#SBATCH --time=2:00:00
#SBATCH --partition=cpu2019,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate bbtools

###### Run your script ######

for f in *_pass_1.fastq.gz
do 
  sample=$(basename $f _pass_1.fastq.gz)

  bbduk.sh -Xmx10g in=${sample}_pass_1.fastq.gz in2=${sample}_pass_2.fastq.gz out=${sample}_pass_1.lastbase.fastq out2=${sample}_pass_2.lastbase.fastq ftm=5 threads=40 >& ${sample}.lastbase.log.txt
  bbduk.sh -Xmx10g in=${sample}_pass_1.lastbase.fastq in2=${sample}_pass_2.lastbase.fastq out=${sample}_pass_1.adapter.fastq out2=${sample}_pass_2.adapter.fastq ref=/home/daniel.gittins/miniconda3/envs/bbtools/opt/bbmap-39.01-0/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo threads=40 >& ${sample}.adapter.log.txt
  bbduk.sh -Xmx10g in=${sample}_pass_1.adapter.fastq in2=${sample}_pass_2.adapter.fastq out=${sample}_pass_1.phix.fastq out2=${sample}_pass_2.phix.fastq ref=/home/daniel.gittins/miniconda3/envs/bbtools/opt/bbmap-39.01-0/resources/phix_adapters.fa.gz k=31 hdist=1 stats=${sample}_stats.txt threads=40 >& ${sample}.phix.log.txt
  bbduk.sh -Xmx10g in=${sample}_pass_1.phix.fastq in2=${sample}_pass_2.phix.fastq out=${sample}_pass_1.qc.fastq out2=${sample}_pass_2.qc.fastq qtrim=rl trimq=15 minlength=30 threads=40 >& ${sample}.quality.log.txt
done

rm *.lastbase.fastq
rm *.adapter.fastq
rm *.phix.fastq

##
echo "Job finished with exit code $? at: `date`"
##
