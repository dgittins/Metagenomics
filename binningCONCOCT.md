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
3. Cut contigs into smaller parts

```bash
for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	cut_up_fasta.py ${sample}_final.contigs.fa -c 10000 -o 0 --merge_last -b ${sample}_contigs.10K.bed > ${sample}_contigs.10K.fa
done
```

\
4. Generate table with coverage depth information per sample and subcontig
 
```bash
for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	concoct_coverage_table.py ${sample}_contigs.10K.bed *${sample}.bowtie.sorted.bam > ${sample}_coverage.table.tsv
done
```

\
5. Run concoct

```bash
for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	mkdir ${sample}_concoct.output
	concoct --composition_file ${sample}_contigs.10K.fa --coverage_file ${sample}_coverage.table.tsv -b ${sample}_concoct.output/ >& ${sample}_concoct.log.txt
done
```

\
6. Merge subcontig clustering into original contig clustering

```bash
for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	merge_cutup_clustering.py ${sample}_concoct.output/clustering_gt1000.csv > ${sample}_concoct.output/clustering.merged.csv
done
```

\
7. Extract bins as individual FASTA
```bash
for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	mkdir ${sample}_concoct.output/fasta.bins
	extract_fasta_bins.py ${sample}_final.contigs.fa ${sample}_concoct.output/clustering.merged.csv --output_path ${sample}_concoct.output/fasta.bins
done
```

