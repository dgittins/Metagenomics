# Annotating metagenome-assembled genomes (MAGs)

## RPS-BLAST (Reverse Position-Specific BLAST) search against the [Conserved Domain Database](https://www.ncbi.nlm.nih.gov/Structure/cdd/cdd_help.shtml#RPSBFtpDat) (CDD)

This search uses RPS-BLAST to compare a query protein sequence against conserved domain models that have been collected from the SMART, Pfam, COGs, TIGRFAMs, PRK, KOGs and LOAD source databases.

1. Create a conda environment and install NCBIs BLAST tool

```bash
$ conda create -n blast -c bioconda blast
$ conda activate blast
```

\
2. Download preformatted CDD search database: https://www.ncbi.nlm.nih.gov/cdd 
 
Navigate to https://ftp.ncbi.nih.gov/pub/mmdb/cdd/little_endian/ - the "little_endian" subdirectory contains a pre-formatted search database for use with the standalone RPS-BLAST executable

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
	hmmscan --tblout ${sample}.tblout --domtblout ${sample}.domtblout --noali --notextw --cut_tc --cpu 40 /work/lab/ReferenceDatabases/Pfam/Pfam-A.hmm ../${sample}_proteins.faa > ${sample}.hmmscan.tc.out
done
```
