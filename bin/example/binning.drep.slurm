#!/bin/bash
###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=50GB
#SBATCH --time=05:00:00
#SBATCH --partition=cpu2019,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate dRep

###### Run your script ######

for f in *_final.contigs.fa 
do
	sample=$(basename $f _final.contigs.fa)
	DAS_Tool -i ${sample}_concoct.contigs2bin.tsv,${sample}_maxbin.contigs2bin.tsv,${sample}_metabat.contigs2bin.tsv -c ${sample}_final.contigs.fa -o ${sample} --write_bin_evals --write_bins --write_unbinned -t 40 >& ${sample}_dastool.log.txt
done

##
echo "Job finished with exit code $? at: `date`"
##
