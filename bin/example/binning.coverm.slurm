#!/bin/bash
###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=100GB
#SBATCH --time=12:00:00
#SBATCH --partition=cpu2019,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate coverm

###### Run your script ######

for f in *_pass_1.qc.fastq
do
	sample=$(basename $f _pass_1.qc.fastq)
	coverm genome -1 ${sample}_pass_1.qc.fastq -2 ${sample}_pass_2.qc.fastq -d . -x .fa -p --min-read-percent-identity 95 --min-read-aligned-percent 75 --min-covered-fraction 0 -m relative_abundance mean trimmed_mean covered_bases variance length count reads_per_base rpkm -o ${sample}.coverm_out.tsv -t 20
done

##
echo "Job finished with exit code $? at: `date`"
##
