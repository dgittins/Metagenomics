# Annotating metagenome-assembled genomes (MAGs) with HMM searches against Pfam

## [Pfam](https://academic.oup.com/nar/article/26/1/320/2379329)

1. Create a conda environment with HMMER installed

```bash
$ conda create -n hmmer -c bioconda hmmer
$ conda activate hmmer
```

\
2. Download and prepare Pfam database 

```bash
$ cd /work/lab/ReferenceDatabases/Pfam

$ wget http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
$ gunzip Pfam-A.hmm.gz

$ hmmpress Pfam-A.hmm
```
