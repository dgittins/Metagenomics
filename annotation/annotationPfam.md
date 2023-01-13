# Annotating metagenome-assembled genomes (MAGs)

## HMM searches against [Pfam](https://academic.oup.com/nar/article/26/1/320/2379329)

Workflow assumes gene-predictions have been made - see [Prodigal workflow](https://github.com/dgittins/Metagenomics/blob/main/annotation/genepredictionProdigal.md)

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

\
3. Navigate to a working directory containing links to gene-predictions from metagenome bins and run hmmscan against Pfam HMMs

```bash
$ cd annotation/

for f in ../*_proteins.faa
do
	sample=$(basename $f _proteins.faa)
	hmmscan --tblout ${sample}.tblout --domtblout ${sample}.domtblout --noali --notextw --cut_tc --cpu 40 /work/ebg_lab/referenceDatabases/Pfam/Pfam-A.hmm ../${sample}_proteins.faa > ${sample}.hmmscan.tc.out
done
```




