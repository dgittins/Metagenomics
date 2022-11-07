# Map quality controlled reads to the assemblies (contigs)

To generate 'coverage' information for improved binning, each QC read pair should be mapped to each assembly and the coassembly - if a study has four read pair files (metagenomes), four assemblies and one coassembly, mapping will need to be performed 4 x 5 (20) times.

## [Bowtie 2](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3322381/)

1. Install Bowtie 2

```bash
$ conda create -n bowtie2 -c bioconda bowtie2
$ conda activate bowtie2
$ conda install -c bioconda samtools #reuired for processing sam files
```

\
2. Navigate to a working directory and create links to QC fastq files, assemblies and coassemblies

```bash
$ cd mapping/bowtie2/
$ ln -s ../../qc/*.qc.fastq .
$ ln -s ../../assembly/*/*_final.contigs.fa .
```

\
3. Build a Bowtie index of the assembly

```bash
#Build an index of the assembly
$ bowtie2-build -f SRR10302630_final.contigs.fa SRR10302630_bowtie2_contigs --threads 20

#Map quality controlled reads to the indexed assembly
$ bowtie2 -x SRR10302630_bowtie2_contigs -1 SRR10302630_pass_1.qc.fastq -2 SRR10302630_pass_1.qc.fastq --threads 20 -q --sensitive-local | samtools view -b -S --threads 20 | samtools sort -m 10G --threads 20 -o SRR10302630_SRR10302630assembly.bbmap_sorted.bam

#Index the sorted bam file
$ samtools index -m 10G --threads 20 SRR4293331_SRR4293331assembly.bowtie.sorted.bam
```

