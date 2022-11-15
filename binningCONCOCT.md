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
	

