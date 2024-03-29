# Map quality controlled reads to the assemblies (contigs)

To generate 'coverage' information for improved binning, each QC read pair should be mapped to each assembly and the coassembly - if a study has four read pair files (metagenomes), four assemblies and one coassembly, mapping will need to be performed 4 x 5 (20) times.

## [Bowtie 2](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3322381/)

1. Install Bowtie 2

```bash
$ conda create -n bowtie2 -c bioconda bowtie2
$ conda activate bowtie2
$ conda install -c bioconda samtools #required for processing sam files
```

\
2. Navigate to a working directory and create links to QC fastq files, assemblies and coassemblies

```bash
$ cd mapping/bowtie2/
$ ln -s ../../qc/*.qc.fastq .
$ ln -s ../../assembly/megahit/*/*_final.contigs.fa . #contigs assembled using MEGAHIT or metaSPAdes, or scaffolds from IDBA-ud
```

\
3. Build a Bowtie index of the assembly

```bash
#Build an index of the assembly

for f in *_final.contigs.fa
do
	sample=$(basename $f _final.contigs.fa)
	bowtie2-build -f ${sample}_final.contigs.fa ${sample}.bowtie.contigs --threads 20
done


#Map quality controlled reads to the indexed assembly

for f in *.bowtie.contigs.1.bt2
do
	contig=$(basename $f .bowtie.contigs.1.bt2)
	
	for r in *_pass_1.qc.fastq
	do
		read=$(basename $r _pass_1.qc.fastq)
		bowtie2 -x ${contig}.bowtie.contigs -1 ${read}_pass_1.qc.fastq -2 ${read}_pass_2.qc.fastq --threads 20 --local | samtools view -bS --threads 20 | samtools sort --threads 20 -o ${read}_${contig}.bowtie.sorted.bam
	done
done


#Index the sorted bam file

for f in *.bowtie.sorted.bam
do
	samtools index -@ 20 $f
done
```

\
4. Calculate coverage depth for each sequence in the assembly (and coassembly) using [MetaBAT - jgi_summarize_bam_contig_depths](https://bitbucket.org/berkeleylab/metabat/src/master/)

Install [MetaBAT 2](https://bitbucket.org/berkeleylab/metabat/src/master/)
```bash
$ conda create -n metabat2 -c bioconda metabat2
$ conda activate metabat2
```

Calculate coverage depth
```bash
for f in *_final.contigs.fa
do
	sample=$(basename $f _final.contigs.fa)
	jgi_summarize_bam_contig_depths --outputDepth ${sample}_bowtie.depth.txt *${sample}.bowtie.sorted.bam
done
```
