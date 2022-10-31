# Recovery of genomes from metagenomic datasets

## [MaxBin 2.0](https://academic.oup.com/bioinformatics/article/32/4/605/1744462?login=true)

1. Install MaxBin 2.0

```bash
$ conda create -n maxbin2
$ conda activate maxbin2
```

Install dependencies one-by-one (full install using conda, e.g., conda install -c bioconda maxbin2, did not work - problem solving the environment. Using an environment .yml file (https://github.com/bioconda/bioconda-recipes/blob/master/recipes/maxbin2/meta.yaml) didn't work either, but provided a list of dependencies to download)

```bash
conda install -c bioconda fraggenescan
conda install -c bioconda bowtie2
conda install -c bioconda hmmer
conda install -c bioconda idba
conda install -c conda-forge perl=5.26
conda install -c bioconda perl-lwp-simple
conda install -c conda-forge r-base
conda install -c bioconda r-gplots
conda install -c conda-forge tar
conda install -c bioconda maxbin2
```

```bash
conda activate maxbin2
```

2. Navigate to a working directory and create links to quality controlled reads and assembled contigs

```bash
cd ./binning/maxbin2/
ln -s ../qc/*.qc.fastq .
ln -s ../assembly/*/*final.contigs.fa .
```

<br/>
3. Option 1 - run MaxBin 2.0 **without a contig abundance file** (MaxBin will use Bowtie2 to map the sequencing reads against contigs and generate abundance information)

```bash
for f in *_final.contigs.fa
do new=$(basename $f _final.contigs.fa)
run_MaxBin.pl -thread 40 -contig ${new}_final.contigs.fa -reads ${new}_pass_1.qc.fastq -reads2 ${new}_pass_2.qc.fastq -out ${new} >& ${new}.maxbin2.log.txt
done

run_MaxBin.pl -thread 40 -contig coassembly_final.contigs.fa -reads_list reads_list -out coassembly >& coassembly.maxbin2.log.txt
```

<br/>
3. Option 2 - run MaxBin 2.0 **with a contig abundance file** (runs faster and with less resources if an abundance list file is provided)

Convert [MetaBAT](https://bitbucket.org/berkeleylab/metabat/src/master/) jgi_summarize_bam_contig_depths file used for calculating coverage depth for each sequence in an assembly to an abundance file that can be inputted to MaxBin 2.0

```bash
[depthabundance.py](https://github.com/dgittins/Metagenomics/blob/main/depthabundance.py) assembly.depth_bbmap.txt
```

```bash
for f in *_final.contigs.fa
do new=$(basename $f _final.contigs.fa)
run_MaxBin.pl -thread 40 -contig ${new}_final.contigs.fa -abund_list ${new}assembly.abund_list.txt -out ${new}wdepth >& ${new}.maxbin2wdepth.log.txt
done

run_MaxBin.pl -thread 40 -contig coassembly_final.contigs.fa -abund_list coassembly.abund_list.txt -out coassemblywdepth >& coassembly.maxbin2wdepth.log.txt
```

