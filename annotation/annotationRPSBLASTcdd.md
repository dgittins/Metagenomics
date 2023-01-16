# Annotating metagenome-assembled genomes (MAGs)

## RPS-BLAST (Reverse Position-Specific BLAST) search against the [Conserved Domain Database](https://www.ncbi.nlm.nih.gov/Structure/cdd/cdd_help.shtml#RPSBFtpDat) (CDD)

This search uses RPS-BLAST to compare query protein sequences against conserved domain models that have been collected from the SMART, Pfam, COGs, TIGRFAMs, PRK, KOGs and LOAD source databases.

1. Create a conda environment and install NCBIs BLAST tool

```bash
$ conda create -n blast -c bioconda blast
$ conda activate blast
```

\
2. Download preformatted CDD search database: https://www.ncbi.nlm.nih.gov/cdd 
 
Navigate to https://ftp.ncbi.nih.gov/pub/mmdb/cdd/little_endian/ - the "little_endian" subdirectory contains a pre-formatted search database for use with the standalone RPS-BLAST executable

```bash
$ cd ~/software/rpsblast/cdd

$ wget https://ftp.ncbi.nih.gov/pub/mmdb/cdd/little_endian/Cdd_LE.tar.gz
$ tar -xvzf Cdd_LE.tar.gz
$ rm Cdd_LE.tar.gz
```

\
3. Navigate to a working directory containing links to gene-predictions from metagenome bins and run RPS-BLAST

```bash
$ cd annotation/cdd/

for f in ../*_proteins.faa
do
	sample=$(basename $f _proteins.faa)
	rpsblast -query ../${sample}_proteins.faa -db ~/software/rpsblast/cdd/Cdd -out ${sample}.cdd.blastout -evalue 1e-7 -outfmt '6 qseqid sseqid sacc evalue bitscore stitle' -num_threads 40 
done
```
