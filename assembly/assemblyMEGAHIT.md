# Assemble QC reads

## [MEGAHIT](https://academic.oup.com/bioinformatics/article/31/10/1674/177884)

1. Install MEGAHIT

```bash
$ conda create -n megahit -c bioconda megahit
$ conda activate megahit
```

\
2. Navigate to a working directory and create links to quality controlled reads

```bash
$ cd assembly/megahit/
$ ln -s ../../qc/*.qc.fastq .
```

\
3. Run MEGAHIT

```bash
#Individual assembly
for f in *_pass_1.qc.fastq
do
  sample=$(basename $f _pass_1.qc.fastq)
  megahit -1 ${sample}_pass_1.qc.fastq -2 ${sample}_pass_2.qc.fastq -t 20 -m 0.5 --min-contig-len 500 -o ${sample}_megahit.assembly  >& ${sample}_megahit.log.txt
done

#Co-assembly
reads1=$(echo `ls ${prefix}*_pass_1.qc.fastq` | sed 's/ /,/g') #create a comma seperated list of forward reads
reads2=$(echo `ls ${prefix}*_pass_2.qc.fastq` | sed 's/ /,/g') #create a comma seperated list of reverse reads

megahit -1 ${reads1} -2 ${reads2} -t 20 -m 0.5 --min-contig-len 500 -o <study>_megahit.coassembly >& <study>_megahit.coassembly.log.txt
```

\
4. Add a prefix of the sample name to each of the 'final.contigs.fa' files in their respective directories, as well as each assembled contig within the respective .fa files.

```bash
for dir in */
do
	cd "$dir"
	sample=$(basename "$PWD" | cut -d\_ -f1) #create a variable of the sample name from the directory name
	mv final.contigs.fa ${sample}_final.contigs.fa #add sample name to file name
	sed -i "s/>/>${sample}_/g" ${sample}_final.contigs.fa #add sample name to the beginning of each contig
	cd ../
done
```

\
5. Caluclate assembled sequence statistics using a custom perl script written by the bioinformatics wiz [Xiaoli Dong](https://github.com/xiaoli-dong)

```bash
$ wget https://raw.githubusercontent.com/xiaoli-dong/metagenomics_crash_course/master/bin/seqStats.pl

for dir in */
do
	cd "$dir"
	sample=$(basename "$PWD" | cut -d\_ -f1)
	perl ../seqStats.pl -f fasta -s ${sample}_final.contigs.fa > ${sample}_final.contigs.seqStats
	cd ../
done

$ grep "" ./*/*_final.contigs.seqStats #useful for copying/parsing the output
```
