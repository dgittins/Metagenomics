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
$ cd binning/maxbin2/
$ ln -s ../../assembly/megahit/*/*_final.contigs.fa .
$ ln -s ../../qc/*.qc.fastq . #optional - see below
$ ln -s ../../mapping/bowtie/*_bowtie.depth.txt . #optional - see below
```

\
3. **Option 1 - run MaxBin 2.0 without a contig abundance file** (MaxBin will use Bowtie2 to map the sequencing reads against contigs and generate abundance information)

Create a 'reads.list' file containing a list of all the QC fastq read files with their absolute paths:

```bash
$ ls -d "$PWD"/*.qc.fastq >> reads.list
```

```bash
$ less reads.list

/home/username/study/binning/maxbin2/sample1_pass_1.qc.fastq
/home/username/study/binning/maxbin2/sample1_pass_2.qc.fastq
/home/username/study/binning/maxbin2/sample2_pass_1.qc.fastq
/home/username/study/binning/maxbin2/sample2_pass_2.qc.fastq
/home/username/study/binning/maxbin2/sample3_pass_1.qc.fastq
/home/username/study/binning/maxbin2/sample3_pass_2.qc.fastq
...
```

Run MaxBin:
```bash
for f in *_final.contigs.fa
do 
  sample=$(basename $f _final.contigs.fa)
  run_MaxBin.pl -thread 20 -contig ${sample}_final.contigs.fa -reads_list reads.list -out ${sample} >& ${sample}.maxbin2.log.txt
done
```

\
3. **Option 2 - run MaxBin 2.0 with contig abundance files** (runs faster and with less resources if an abundance list file is provided)

Convert [MetaBAT - jgi_summarize_bam_contig_depths](https://bitbucket.org/berkeleylab/metabat/src/master/) file used for calculating coverage depth for each sequence in an assembly to an abundance file that can be inputted to MaxBin 2.0

Use [depthabundance.py](https://github.com/dgittins/Metagenomics/blob/main/bin/depthabundance.py) script to parse each coverage depth file:

```bash
$ wget https://github.com/dgittins/Metagenomics/raw/main/bin/depthabundance.py #download depthabundance.py

$ pip install pandas #depthabundance.py requires pandas tool

for f in *_bowtie.depth.txt
do 
  sample=$(basename $f _bowtie.depth.txt)
  python depthabundance.py ${sample}_bowtie.depth.txt
done
```

Create 'abundance.list' files containing lists of the abundance files for each assembly with their absolute paths:

```bash
for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	ls -d "$PWD"/*${sample}.bowtie.sorted.bam.txt >> ${sample}_abundance.list
done
```

```bash
$ less sample1_abundance.list

/home/username/study/binning/maxbin2/sample1_sample1assembly.sorted.bam.txt
/home/username/study/binning/maxbin2/sample2_sample1assembly.sorted.bam.txt
/home/username/study/binning/maxbin2/sample3_sample1assembly.sorted.bam.txt
...
```

Run MaxBin:
```bash
for f in *_final.contigs.fa
do 
  sample=$(basename $f _final.contigs.fa)
  mkdir ${sample}_maxbin.out 
  run_MaxBin.pl -thread 20 -contig ${sample}_final.contigs.fa -abund_list ${sample}_abundance.list -out ${sample}_maxbin.out/${sample}_maxbin >& ${sample}.maxbin2.log.txt
done
```

\
4. Generate contigs-to-bin table for DAS Tool bin refinement 

```bash

$ wget https://github.com/cmks/DAS_Tool/raw/master/src/Fasta_to_Contig2Bin.sh #script to convert genome bins in fasta format to contigs-to-bin table

for dir in */
do
	cd "$dir"
	sample=$(echo "$dir" | cut -d\_ -f1) #create a variable of the sample name from the directory name
	sh ../Fasta_to_Contig2Bin.sh -e fasta > ../${sample}_maxbin.contigs2bin.tsv #run Fasta_to_Contig2Bin script
	cd ../
done
```
