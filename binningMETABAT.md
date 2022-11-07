# Recovery of genomes from metagenomic datasets

## [MetaBAT 2](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6662567/)

1. Install MetaBAT 2

```bash
$ conda create -n metabat2 -c bioconda metabat2
$ conda activate metabat2
```

\
2. Navigate to a working directory and create links to assembled contig files

```bash
$ cd binning/metabat2/
$ ln -s ../../assembly/*/.contigs.fa .
```

\
3. Generate contig depth profiles from sorted bam files created during [mapping](https://github.com/dgittins/Metagenomics/blob/main/mappingBBMap.md) (there should be one depth file for each assembly, plus one for the coassembly)

```bash


