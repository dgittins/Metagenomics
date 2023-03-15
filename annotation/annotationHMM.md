# Annotating metagenome-assembled genomes (MAGs)

## HMM searches against [Pfam](https://academic.oup.com/nar/article/26/1/320/2379329) or a custom set of HMMs

1. Create a conda environment with HMMER installed

```bash
$ conda create -n hmmer -c bioconda hmmer
$ conda activate hmmer
```

\
2a. Download and prepare Pfam database

```bash
$ cd /work/lab/ReferenceDatabases/Pfam

$ wget http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
$ gunzip Pfam-A.hmm.gz

$ hmmpress Pfam-A.hmm
```

\
2b. Download custom HMM profiles

```bash
$ cd /work/lab/ReferenceDatabases/hydrogenaseHMM

$ wget https://github.com/banfieldlab/metabolic-hmms/raw/master/Hydrogenase_Group_1.hmm
```

\
3. Navigate to a working directory containing links to gene-predictions from metagenome bins (cf. [Prodigal](https://github.com/dgittins/Metagenomics/blob/main/annotation/genepredictionProdigal.md) workflow) and run hmmscan or hmmsearch against Pfam HMMs or custom HMMs

```bash
$ cd annotation/

#hmmscan
for f in ../*_proteins.faa
do
	sample=$(basename $f _proteins.faa)
	hmmscan --tblout ${sample}.tblout --domtblout ${sample}.domtblout --noali --notextw --cut_tc --cpu 40 /work/lab/ReferenceDatabases/Pfam/Pfam-A.hmm ../${sample}_proteins.faa > ${sample}.hmmscan.tc.out
done

#hmmsearch
for f in ../*_proteins.faa
do
	sample=$(basename $f _proteins.faa)
	hmmsearch --domT 0 --tblout ${sample}.tblout /work/lab/ReferenceDatabases/hydrogenaseHMM/Hydrogenase_Group_1.hmm ../${sample}_proteins.faa
done
```
