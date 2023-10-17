# Profile shotgun metagenomes 

Estimate the relative abundances of microbial community members

## [SingleM](https://wwood.github.io/singlem/)

Use the relative abundance of single copy marker genes in reads to estimate the relative abudance of communtity members. Compare with CoverM mapped reads to evaluate genome representation. 

1. Install SingleM

```bash
$ conda create -c bioconda --name singlem singlem
$ conda activate singlem
```

\
2. Navigate to a working directory and create links to raw Illumina reads

```bash
$ cd binning/singlem/

$ ln -s ../../fastq/*.fastq.gz .
```

\
3. Run SingleM

```bash
for f in ./*_pass_1.fastq.gz
do
	sample=$(basename $f _pass_1.fastq.gz)
	singlem pipe -1 ${sample}_pass_1.fastq.gz -2 ${sample}_pass_1.fastq.gz -p ${sample}.singlem.profile.tsv
done
```

