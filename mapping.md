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
$ cd mapping/
$ ln -s ../qc/*.qc.fastq .
$ ln -s ../assembly/*/*_final.contigs.fa .
```

3. Run BBMap to generate sorted, indexed bam files

```bash
for f in *_final.contigs.fa
do
	contig=$f
	contign=$(basename $f _final.contigs.fa)
	
	for r in *_pass_1.qc.fastq
	do
		sample=$(basename $r _pass_1.qc.fastq)
		bbmap.sh -Xmx10g ref=${contig} nodisk in=${sample}_pass_1.qc.fastq in2=${sample}_pass_2.qc.fastq threads=20 out=${sample}_${contign}contigs.bbmap.bam bs=bs.sh; sh bs.sh >& ${sample}_${contign}contigs.bbmap.log.txt
	done
done
```
