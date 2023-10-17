#!/bin/bash
###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=50GB
#SBATCH --time=05:00:00
#SBATCH --partition=cpu2019,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate checkm2

###### Run your script ######

for dir in *_DASTool_bins/
do
	cd "$dir"
	sample=$(echo "$dir" | cut -d\_ -f1) #create a variable of the sample name from the directory name
	mkdir ${sample}_checkm2 #create a checkm2 output directory
	checkm2 predict --threads 40 --input . -x fa --output-directory ./${sample}_checkm2 #run CheckM2 script
	cd ../
done

##
echo "Job finished with exit code $? at: `date`"
##
