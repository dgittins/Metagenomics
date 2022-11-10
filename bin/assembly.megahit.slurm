#!/bin/bash
###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=50GB
#SBATCH --cpus-per-task=20
#SBATCH --time=5:00:00
#SBATCH --partition=cpu2019,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate megahit

###### Run your script ######

#Individual assembly
for f in *_pass_1.qc.fastq
do
  sample=$(basename $f _pass_1.qc.fastq)
  megahit -1 ${sample}_pass_1.qc.fastq -2 ${sample}_pass_2.qc.fastq -t 40 -m 0.5 --min-contig-len 500 -o ${sample}_megahit.assembly  >& ${sample}_megahit.log.txt
done

#Co-assembly
reads1=$(echo `ls ${prefix}*_pass_1.qc.fastq` | sed 's/ /,/g') #create a comma seperated list of forward reads
reads2=$(echo `ls ${prefix}*_pass_2.qc.fastq` | sed 's/ /,/g') #create a comma seperated list of reverse reads

megahit -1 ${reads1} -2 ${reads2} -t 40 -m 0.5 --min-contig-len 500 -o Song_megahit.coassembly >& Song_megahit.coassembly.log.txt

##
echo "Job finished with exit code $? at: `date`"
##
