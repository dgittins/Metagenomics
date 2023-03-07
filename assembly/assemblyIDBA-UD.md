# Assemble QC reads

## [IDBA-UD](https://github.com/loneknightpy/idba)

1. Install IDBA-UD

```bash
$ conda create -n idba -c bioconda idba
$ conda activate idba
```

\
2. Navigate to a working directory and create links to quality controlled reads

```bash
$ cd assembly/idba/
$ ln -s ../../qc/*.qc.fastq .
```

\
3. Convert individual forward and reverse quality-controlled FASTQ read files into paired-end FASTA read files

IDBA series assemblers accept FASTA format reads. IDBA-UD, IDBA-Hybrid and IDBA-Tran require paired-end reads stored in the same FASTA file.

```bash
for f in *_pass_1.qc.fastq
do
   sample=$(basename $f _pass_1.qc.fastq)
   fq2fa --merge ${sample}_pass_1.qc.fastq ${sample}_pass_2.qc.fastq ${sample}.pe.fa
done
```

\
4. Run IDBA-UD

```bash
for f in *.pe.fa
do
  sample=$(basename $f .pe.fa)
  idba_ud -r ${sample}.pe.fa -o ${sample}_idba.assembly --num_threads 40 --min_contig 500 --pre_correction >& ${sample}_idba.assembly.log.txt
done

#Remove unnecessary files from output directories:
find . \( -name "kmer" -o -name "contig-*" -o -name "align-*" -o -name "graph-*" -o -name "local-*" \) -delete #use '-a -print' instead of -delete' to view files before deleting 
```

\
5. Add a prefix of the sample name to each of the 'final.contigs.fa' files in their respective directories, as well as each assembled contig within the respective .fa files.

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
6. Caluclate assembled sequence statistics using a custom perl script written by the bioinformatics wiz [Xiaoli Dong](https://github.com/xiaoli-dong)

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
