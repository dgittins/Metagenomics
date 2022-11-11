# Recovery of genomes from metagenomic datasets

## [MetaBAT 2](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6662567/)

1. Install MetaBAT 2

```bash
$ conda create -n metabat2 -c bioconda metabat2
$ conda activate metabat2
```

\
2. Navigate to a working directory and create links to assembled contig files and depth files created during [mapping](https://github.com/dgittins/Metagenomics/blob/main/mappingBBMap.md)

```bash
$ cd binning/metabat2/
$ ln -s ../../assembly/megahit/*/*.contigs.fa .
$ ln -s ../../mapping/bowtie/*_bowtie.depth.txt .
```

\
3. Run Metabat 2

```bash
for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	metabat2 -i ${sample}_final.contigs.fa -a ${sample}assembly.bbmap.depth.txt -o ${sample}.bin --unbinned -t 20 >& ${sample}.metabat2.log.txt
done
```
