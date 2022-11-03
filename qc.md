# Quality control (adapter/quality trimming and filtering) Illumina metagenome reads

## [BBDuk](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbduk-guide/)

1. Install BBDuk

```bash
$ conda create -n bbtools -c bioconda bbmap #bbmap contains various bioinformatic tools including BBDuk
$ conda activate bbtools
```

2. Navigate to a working directory and create links to fastq files

```bash
$ cd qc/
$ ln -s ../fastq/*.fastq.gz .
```

3. Run BBDuk on fastq.gz files

#Force-Trim Modulo - remove very inaccurate, low quality last base ('ftm=5' - read length is equal to zero modulo 5)

```bash
$ bbduk.sh -Xmx10g in=sample1_pass_1.fastq.gz in2=sample1_pass_2.fastq.gz out=sample1_pass_1.lastbase.fastq out2=sample1_pass_2.lastbase.fastq ftm=5 threads=20 >& sample1.lastbase.log.txt
```

#Adapter trimming - remove Illumina adapter sequences

```bash
$ bbduk.sh -Xmx10g in=sample1_pass_1.lastbase.fastq in2=sample1_pass_2.lastbase.fastq out=sample1_pass_1.adapter.fastq out2=sample1_pass_2.adapter.fastq ref=/bbmap-39.01-0/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo threads=20 >& sample1.adapter.log.txt
```

#Kmer filtering - remove all reads that have a k-mer match to PhiX (common Illumina spikein)

```bash
$ bbduk.sh -Xmx10g in=sample1_pass_1.adapter.fastq in2=sample1_pass_2.adapter.fastq out=sample1_pass_1.phix.fastq out2=sample1_pass_2.phix.fastq ref=/bbmap-39.01-0/resources/phix_adapters.fa.gz k=31 hdist=1 stats=sample1_stats.txt threads=20 >& $sample1.phix.log.txt
```

#Length/quality filtering - discard reads shorter than a specified length and below a specified quality 

```bash
$ bbduk.sh -Xmx10g in=sample1_pass_1.phix.fastq in2=sample1_pass_2.phix.fastq out=sample1_pass_1.qc.fastq out2=sample1_pass_2.qc.fastq qtrim=rl trimq=15 minlength=30 threads=20 >& sample1.quality.log.txt
```
