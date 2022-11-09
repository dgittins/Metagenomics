# Map quality controlled reads to the assemblies (contigs)

To generate 'coverage' information for improved binning, each QC read pair should be mapped to each assembly and the coassembly - if a study has four read pair files (metagenomes), four assemblies and one coassembly, mapping will need to be performed 4 x 5 (20) times.

## [BBMap](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbmap-guide/)

1. Install BBMap

```bash
$ conda create -n bbtools -c bioconda bbmap
$ conda activate bbtools
```

\
2. Navigate to a working directory and create links to QC fastq files, assemblies and coassemblies

```bash
$ cd mapping/bbmap/
$ ln -s ../../qc/*.qc.fastq .
$ ln -s ../../assembly/*/*_final.contigs.fa .
```

\
3. Run BBMap to generate sorted, indexed bam files

```bash
for f in *_final.contigs.fa
do
	contig=$f
	contign=$(basename $f _final.contigs.fa)
	
	for r in *_pass_1.qc.fastq
	do
		sample=$(basename $r _pass_1.qc.fastq)
		bbmap.sh -Xmx10g ref=${contig} nodisk in=${sample}_pass_1.qc.fastq in2=${sample}_pass_2.qc.fastq minid=0.95 threads=20 outm=${sample}_${contign}contigs.bbmap.bam bs=bs.sh; sh bs.sh >& ${sample}_${contign}contigs.bbmap.log.txt
	done
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
#Individual assembly
for f in *_final.contigs.fa
do
sample=$(basename $f _final.contigs.fa)
jgi_summarize_bam_contig_depths --outputDepth ${sample}assembly.depth_bbmap.txt *${sample}assembly.bbmap_sorted.bam
done

#Co-assembly
jgi_summarize_bam_contig_depths --outputDepth coassembly.depth_bbmap.txt *coassembly.bbmap_sorted.bam
```
