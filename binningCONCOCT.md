# Recovery of genomes from metagenomic datasets

## [CONCOCT](https://github.com/BinPro/CONCOCT)

1. Install CONCOCT

```bash
$ conda create -n concoct -c bioconda concoct
$ conda activate concoct
```

\
2. Navigate to a working directory and create links to assembled contig files and depth files created during [mapping](https://github.com/dgittins/Metagenomics/blob/main/mappingBBMap.md)

```bash
$ cd binning/concoct/
$ ln -s ../../assembly/*/.contigs.fa .
$ ln -s ../../mapping/bbmap/*.bbmap.depth.txt .
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
