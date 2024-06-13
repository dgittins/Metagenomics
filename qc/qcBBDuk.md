# Quality control (adapter/quality trimming and filtering) Illumina metagenome reads

## [BBDuk](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbduk-guide/)

1. Install BBDuk

```bash
$ conda create -n bbtools -c bioconda bbmap #bbmap contains various bioinformatic tools including BBDuk
$ conda activate bbtools
```

\
2. Navigate to a working directory and create links to fastq files

```bash
$ cd qc/
$ ln -s ../fastq/*.fastq.gz .
```

\
3. Run BBDuk on fastq.gz files

When dealing with paired reads in 2 files they should always be processed together, not one at a time. Pairs are always kept together – either both reads are kept, or both are discarded.

**Force-Trim Modulo** - remove very inaccurate, low quality last base ('ftm=5' - read length is equal to zero modulo 5)

```bash
$ bbduk.sh -Xmx10g in1=sample1_pass_1.fastq.gz in2=sample1_pass_2.fastq.gz out1=sample1_pass_1.lastbase.fastq out2=sample1_pass_2.lastbase.fastq ftm=5 threads=20 >& sample1.lastbase.log.txt
```

**Adapter trimming** - remove Illumina adapter sequences

```bash
$ bbduk.sh -Xmx10g in1=sample1_pass_1.lastbase.fastq in2=sample1_pass_2.lastbase.fastq out1=sample1_pass_1.adapter.fastq out2=sample1_pass_2.adapter.fastq ref=/bbmap-39.01-0/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo threads=20 >& sample1.adapter.log.txt
```

**Kmer filtering** - remove all reads that have a k-mer match to PhiX (common Illumina spikein)

```bash
$ bbduk.sh -Xmx10g in1=sample1_pass_1.adapter.fastq in2=sample1_pass_2.adapter.fastq out1=sample1_pass_1.phix.fastq out2=sample1_pass_2.phix.fastq ref=/bbmap-39.01-0/resources/phix_adapters.fa.gz k=31 hdist=1 stats=sample1_stats.txt threads=20 >& $sample1.phix.log.txt
```

**Length/quality filtering** - discard reads shorter than a specified length and below a specified quality 

```bash
$ bbduk.sh -Xmx10g in1=sample1_pass_1.phix.fastq in2=sample1_pass_2.phix.fastq out1=sample1_pass_1.qc.fastq out2=sample1_pass_2.qc.fastq qtrim=rl trimq=15 minlength=30 threads=20 >& sample1.quality.log.txt
```

\
As a for loop:

```bash
for f in *_pass_1.fastq.gz
do 
  sample=$(basename $f _pass_1.fastq.gz)

  bbduk.sh -Xmx10g in1=${sample}_pass_1.fastq.gz in2=${sample}_pass_2.fastq.gz out1=${sample}_pass_1.lastbase.fastq out2=${sample}_pass_2.lastbase.fastq ftm=5 threads=40 >& ${sample}.lastbase.log.txt
  bbduk.sh -Xmx10g in1=${sample}_pass_1.lastbase.fastq in2=${sample}_pass_2.lastbase.fastq out1=${sample}_pass_1.adapter.fastq out2=${sample}_pass_2.adapter.fastq ref=/bbmap-39.01-0/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo threads=40 >& ${sample}.adapter.log.txt
  bbduk.sh -Xmx10g in1=${sample}_pass_1.adapter.fastq in2=${sample}_pass_2.adapter.fastq out1=${sample}_pass_1.phix.fastq out2=${sample}_pass_2.phix.fastq ref=/bbmap-39.01-0/resources/phix_adapters.fa.gz k=31 hdist=1 stats=${sample}_stats.txt threads=40 >& ${sample}.phix.log.txt
  bbduk.sh -Xmx10g in1=${sample}_pass_1.phix.fastq in2=${sample}_pass_2.phix.fastq out1=${sample}_pass_1.qc.fastq out2=${sample}_pass_2.qc.fastq qtrim=rl trimq=15 minlength=30 threads=40 >& ${sample}.quality.log.txt

done
```

\
  4. Remove intermediate files to save storage space

```bash
$ rm *.lastbase.fastq
$ rm *.adapter.fastq
$ rm *.phix.fastq
```

\
5. Assess quality using [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

Install FastQC

```bash
$ conda create -n fastqc -c bioconda fastqc
$ conda activate fastqc
```

Run FastQC on the quality controlled reads

```bash
for f in *.qc.fastq
do 
  fastqc $f -t 20 -f fastq -o .
done
```

\
6. Caluclate sequence statistics using a custom perl script written by the bioinformatics wiz [Xiaoli Dong](https://github.com/xiaoli-dong)

```bash
$ wget https://raw.githubusercontent.com/xiaoli-dong/metagenomics_crash_course/master/bin/seqStats.pl

for f in *.fastq.gz
do 
	sample=$(basename $f .fastq.gz)
	perl seqStats.pl -f fastq -s ${sample}.fastq.gz > ${sample}.seqStats
done

$ grep "" *_pass_1.seqStats #useful for copying/parsing the output
```

