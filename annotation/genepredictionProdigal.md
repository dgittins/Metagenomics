# Protein-coding gene prediction

## [Prodigal](https://github.com/hyattpd/Prodigal)

1. Create a conda environment with Prodigal installed

```bash
$ conda create -n prodigal -c bioconda prodigal
$ conda activate prodigal
```

\
2. Navigate to a working directory and create links to 'good' / '[medium-quality draft](https://www.nature.com/articles/nbt.3893)' bins (completeness >50%, contamination <10%) based on [Checkm2 workflow](https://github.com/dgittins/Metagenomics/edit/main/binning/assessCheckM2.md) results

```bash
$ cd annotation/
$ cat ../binning/dastool/*_DASTool_bins/*_checkm2/quality_report_good.list > dastool_goodbins.list #concatenate the lists of good bins
$ awk 'NR > 1{ print $1 }' dastool_goodbins.list | xargs -I{} sh -c 'ln -s ../binning/dastool/*/{}' . #create a sym link to good bins. NB add 'sh -c' to make xargs respect wildcards in searches, otherwise sym link path is literal
```

\
3. Run Prodigal

```bash
$ cd annotation/

for f in *.fa
do 
    sample=$(basename $f .fa)
    prodigal -i ${sample}.fa -o ${sample}_gene.coords.gbk -a ${sample}_proteins.faa -d ${sample}_nucleotides.fa -p meta
done
```
