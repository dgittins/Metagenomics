# Recovery of genomes from metagenomic datasets

## [MaxBin 2.0](https://academic.oup.com/bioinformatics/article/32/4/605/1744462?login=true)

1. Install MaxBin 2.0

```bash
$ conda create -n maxbin2
$ conda activate maxbin2
```

Install dependencies one-by-one (full install using conda, e.g., conda install -c bioconda maxbin2, did not work - problem solving the environment. Using an environment .yml file (https://github.com/bioconda/bioconda-recipes/blob/master/recipes/maxbin2/meta.yaml) didn't work either, but provided a list of dependencies to download)

```bash
$ conda install -c bioconda fraggenescan
$ conda install -c bioconda bowtie2
$ conda install -c bioconda hmmer
$ conda install -c bioconda idba
$ conda install -c conda-forge perl=5.26
$ conda install -c bioconda perl-lwp-simple
$ conda install -c conda-forge r-base
$ conda install -c bioconda r-gplots
$ conda install -c conda-forge tar
$ conda install -c bioconda maxbin2
```

\
2. Navigate to a working directory and create links to quality controlled reads, assembled contigs and [MetaBAT - jgi_summarize_bam_contig_depths](https://bitbucket.org/berkeleylab/metabat/src/master/) files

```bash
$ cd ./binning/maxbin2/
$ ln -s ../assembly/*/*final.contigs.fa .
$ ln -s ../qc/*.qc.fastq . #optional - see below
$ ln -s ../mapping/*assembly.depth.txt . #optional - see below
```

\
3. **Option 1 - run MaxBin 2.0 without a contig abundance file** (MaxBin will use Bowtie2 to map the sequencing reads against contigs and generate abundance information)

Create a 'reads.list' file containing a list of all the QC fastq read files with their absolute paths:

```bash
$ ls -d "$PWD"/*.qc.fastq >> reads.list
```

Run MaxBin command:
```bash
run_MaxBin.pl -thread 20 -contig coassembly_final.contigs.fa -reads_list reads.list -out coassembly >& coassembly.maxbin2.log.txt

for f in *_final.contigs.fa
do new=$(basename $f _final.contigs.fa)
run_MaxBin.pl -thread 20 -contig ${new}_final.contigs.fa -reads_list reads.list -out ${new} >& ${new}.maxbin2.log.txt
done
```

\
3. **Option 2 - run MaxBin 2.0 with contig abundance files** (runs faster and with less resources if an abundance list file is provided)

Convert [MetaBAT - jgi_summarize_bam_contig_depths](https://bitbucket.org/berkeleylab/metabat/src/master/) file used for calculating coverage depth for each sequence in an assembly to an abundance file that can be inputted to MaxBin 2.0

Use [depthabundance.py](https://github.com/dgittins/Metagenomics/blob/main/depthabundance.py) script to parse each coverage depth file:

```bash
depthabundance.py coassembly.depth.txt

for f in *.depth.txt
do new=$(basename $f .depth.txt)
python depthabundance.py ${new}.depth.txt
done
```

Create 'abundance.list' files conataining lists of the abundance files for each assembly with their absolute paths:

```bash
$ ls -d "$PWD"/*coassembly.bbmap* >> coassembly_abundance.list
$ ls -d "$PWD"/*sample1assembly.bbmap* >> sample1_abundance.list
$ ls -d "$PWD"/*sample2assembly.bbmap* >> sample2_abundance.list
$ ls -d "$PWD"/*sample3assembly.bbmap* >> sample3_abundance.list
```

Run MaxBin command:
```bash
run_MaxBin.pl -thread 20 -contig coassembly_final.contigs.fa -abund_list coassembly_abundance.list -out coassembly >& coassembly.maxbin2wdepth.log.txt

for f in *_final.contigs.fa
do new=$(basename $f _final.contigs.fa)
run_MaxBin.pl -thread 20 -contig ${new}_final.contigs.fa -abund_list ${new}_abundance.list -out ${new} >& ${new}.maxbin2wdepth.log.txt
done
```

