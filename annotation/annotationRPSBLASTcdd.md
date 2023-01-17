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
3. Navigate to a working directory containing links to gene-predictions from metagenome bins (cf. [Prodigal](https://github.com/dgittins/Metagenomics/blob/main/annotation/genepredictionProdigal.md) workflow) and run RPS-BLAST

```bash
$ cd annotation/cdd/

for f in ../*_proteins.faa
do
	sample=$(basename $f _proteins.faa)
	rpsblast -query ../${sample}_proteins.faa -db ~/software/rpsblast/cdd/Cdd -out ${sample}.cdd.blastout -evalue 1e-7 -outfmt '6 qseqid sseqid sacc evalue bitscore stitle' -num_threads 40 
done
```

<br/>

## Additional hydrogenase workflow

a. Parse out useful information, e.g., names/accessions of sequences (i.e., column 1) with 'hydrogenase' annotation

```bash
cd /annotation/hydrogenase/

for f in ../cdd/*.blastout
do 
	sample=$(basename $f .blastout)
	grep -hrw "hydrogenase" ../cdd/${sample}.blastout | awk '{print $1}' | awk '!seen[$0]++' > ${sample}.hydrogenase.acc.txt #last command removes duplicate sequence names/accessions
done
```

b. Extract fasta sequences using the sequence name/accession list (https://www.biostars.org/p/319099/)

```bash
for f in ../*_proteins.faa
do 
	sample=$(basename $f _proteins.faa)
	awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ../${sample}_proteins.faa | grep -w -A 1 -Ff ${sample}.cdd.hydrogenase.acc.txt --no-group-separator > ${sample}.hydrogenase.faa #first command converts a multiline fasta to a singleline fasta
done
```

```bash
# Concatenate all hydrogenase sequencess into one file to run through online HydDB hydrogenase classifier
$ cat *.hydrogenase.faa > sample1_all.hydrogenase.seqs.faa
```

c. Copy local HydDB output to server, then parse squences with hydrogenase annotation

```bash
$ awk -F '";"' '{ print $1"\t"$2 }' sample1_hyddb.results.csv > sample1_hyddb.hydrogenase.acc.txt #split text to columns by ";"
$ sed -i -e s/\"//g sample1_hyddb.hydrogenase.acc.txt #remove quotation marks added by HydDB
$ awk -i inplace '{ if ($2 != "NONHYDROGENASE") { print $1 } }' sample1_hyddb.hydrogenase.acc.txt #filter to column 1 (sequence name/accession) when column 2 does not equal 'NONHYDROGENASE'
```
