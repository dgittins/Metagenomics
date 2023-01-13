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
3. Navigate to a working directory and create links to 'good' / '[medium-quality draft](https://www.nature.com/articles/nbt.3893)' bins (completeness >50%, contamination <10%) based on [Checkm2 workflow](https://github.com/dgittins/Metagenomics/edit/main/binning/assessCheckM2.md) results

```bash
$ cd annotation/
$ cat ../binning/dastool/*_DASTool_bins/*_checkm2/quality_report_good.list > dastool_goodbins.list #concatenate the lists of good bins
$ awk 'NR > 1{ print $1 }' dastool_goodbins.list | xargs -I{} sh -c 'ln -s ../binning/dastool/*/{}' . #create a sym link to good bins. NB add 'sh -c' to make xargs respect wildcards in searches, otherwise sym link path is literal
```

\
4. Run hmmscan against Pfam HMMs

```bash
for f in *_proteins.faa
do new=$(basename $f _proteins.faa)
hmmscan --cut_tc --notextw --cpu 40 --tblout ${new}.tblout --domtblout ${new}.domtblout --noali Pfam-A.hmm ${new}_proteins.faa > ${new}.hmmscan.tc.out
done
```




