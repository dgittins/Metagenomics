#!/bin/bash
###### Reserve computing resources ######
#SBATCH --mail-user=daniel.gittins@ucalgary.ca
#SBATCH --mail-type=END,FAIL,INVALID_DEPEND,REQUEUE,STAGE_OUT
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=160GB
#SBATCH --time=03:00:00
#SBATCH --partition=cpu2019,apophis-bf,pawson-bf,razi-bf

###### Set environment variables ######
echo "Starting run at : `date`"
source /home/daniel.gittins/miniconda3/etc/profile.d/conda.sh
conda activate concoct

###### Run your script ######

for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	
	cut_up_fasta.py ${sample}_final.contigs.fa -c 10000 -o 0 --merge_last -b ${sample}_contigs.10K.bed > ${sample}_contigs.10K.fa #cut contigs into smaller parts
	
	concoct_coverage_table.py ${sample}_contigs.10K.bed *${sample}.bowtie.sorted.bam > ${sample}_coverage.table.tsv #generate a table with coverage depth information per sample and subcontig
	
	mkdir ${sample}_concoct.out
	concoct --composition_file ${sample}_contigs.10K.fa --coverage_file ${sample}_coverage.table.tsv -t 40 -b ${sample}_concoct.out/ #run concoct
	
	merge_cutup_clustering.py ${sample}_concoct.out/clustering_gt1000.csv > ${sample}_concoct.out/clustering.merged.csv #merge subcontig clustering into original contig clustering
	
	mkdir ${sample}_concoct.out/fasta.bins
	extract_fasta_bins.py ${sample}_final.contigs.fa ${sample}_concoct.out/clustering.merged.csv --output_path ${sample}_concoct.out/fasta.bins #extract bins as individual FASTA
	
done

##
echo "Job finished with exit code $? at: `date`"
##
