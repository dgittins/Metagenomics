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

megahit -1 ${reads1} -2 ${reads2} -t 20 -m 0.5 --min-contig-len 500 -o megahit.coassembly >& megahit.coassembly.log.txt
```

\
4. Add a prefix of the sample name to each of the 'final.contigs.fa' files from the previous command and each assembled contig within the respective files. Repeat the commands below for each assembly. 

```bash
#Individual assembly
$ cd sample1_megahit_assembly

$ sample=$(basename "$PWD" _megahit.assembly) #create a variable of the sample name from the directory name
$ mv final.contigs.fa ${sample}_final.contigs.fa #add sample name to file name
$ sed -i "s/>/>${sample}_/g" ${sample}_final.contigs.fa #add sample name to the beginning of each contig

...

#Co-assembly
$ cd megahit.coassembly

$ mv final.contigs.fa coassembly_final.contigs.fa
$ sed -i 's/>/>coassembly/g' coassembly_final.contigs.fa
```

