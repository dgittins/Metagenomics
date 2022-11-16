# Recovery of genomes from metagenomic datasets

## [CONCOCT](https://github.com/BinPro/CONCOCT) 

Workflow described here: https://github.com/BinPro/CONCOCT

1. Install CONCOCT

```bash
$ conda create -n concoct -c bioconda concoct
$ conda activate concoct
```

\
2. Navigate to a working directory and create links to assembled contig files

```bash
$ cd binning/concoct/
$ ln -s ../../assembly/megahit/*/*_final.contigs.fa .
$ ln -s ../../mapping/bowtie/*.bowtie.sorted.bam .
$ ln -s ../../mapping/bowtie/*.bowtie.sorted.bam.bai .
```

\
3. Run CONCOCT

```bash
for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	
	cut_up_fasta.py ${sample}_final.contigs.fa -c 10000 -o 0 --merge_last -b ${sample}_contigs.10K.bed > ${sample}_contigs.10K.fa #cut contigs into smaller parts
	
	concoct_coverage_table.py ${sample}_contigs.10K.bed *${sample}.bowtie.sorted.bam > ${sample}_coverage.table.tsv #generate a table with coverage depth information per sample and subcontig
	
	mkdir ${sample}_concoct.out
	concoct --composition_file ${sample}_contigs.10K.fa --coverage_file ${sample}_coverage.table.tsv -t 40 -b ${sample}_concoct.out/ > /dev/null 2>&1 #run concoct (redirect stderr and stdout to avoid large output files)
	
	merge_cutup_clustering.py ${sample}_concoct.out/clustering_gt1000.csv > ${sample}_concoct.out/clustering.merged.csv #merge subcontig clustering into original contig clustering
	
	mkdir ${sample}_concoct.out/fasta.bins
	extract_fasta_bins.py ${sample}_final.contigs.fa ${sample}_concoct.out/clustering.merged.csv --output_path ${sample}_concoct.out/fasta.bins #extract bins as individual FASTA
	
done
```

\
4. Add a prefix of the sample name to each of the '.fa' bin files in their respective directories

```bash
for dir in */fasta.bins/
do
	cd "$dir"
	sample=$(echo "$dir" | cut -d\_ -f1) #create a variable of the sample name from the directory name
	
	for f in *
	do
		mv $f ${sample}.$f #add sample name to file name
	done
	
	cd ../../
done
```

