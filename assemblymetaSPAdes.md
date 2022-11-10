# Assemble QC reads

## [metaSPAdes](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5411777/)

1. Install metaSPAdes

```bash
$ conda create -n metaspades -c bioconda spades
$ conda activate metaspades
```

\
2. Navigate to a working directory and create links to quality controlled reads

```bash
$ cd assembly/metaspades/
$ ln -s ../../qc/*.qc.fastq .
```

\
3. Run metaSPAdes

```bash
#Individual assembly
for f in *_pass_1.qc.fastq
do
  sample=$(basename $f _pass_1.qc.fastq)
  metaspades.py -1 ${sample}_pass_1.qc.fastq -2 ${sample}_pass_1.qc.fastq -t 48 -m 180 -o ${sample}.metaspades.assembly >& ${sample}.metaspades.log.txt
done

#Co-assembly (not recommended - https://github.com/ablab/spades/issues/656)
cat *_pass_1.qc.fastq > all_pass_1.qc.fastq #concatenate forward reads into a single file
cat *_pass_2.qc.fastq > all_pass_2.qc.fastq #concatenate reverse reads into a single file

metaspades.py -1 all_pass_1.qc.fastq -2 all_pass_2.qc.fastq -t 48 -m 180 -o metaspades.coassembly >& metaspades.coassembly.log.txt
```

\
4. Add a prefix of the sample name to each of the 'final.contigs.fa' files from the previous command and each assembled contig within the respective files. Repeat the commands below for each assembly. 

```bash
#Individual assembly
$ cd sample1_megahit_assembly

$ sample=$(basename "$PWD" _megahit_assembly) #create a variable of the sample name from the directory name
$ mv final.contigs.fa ${sample}_final.contigs.fa #add sample name to file name
$ sed -i "s/>/>${sample}_/g" ${sample}_final.contigs.fa #add sample name to the beginning of each contig

...

#Co-assembly
$ cd megahit_coassembly

$ mv final.contigs.fa coassembly_final.contigs.fa
$ sed -i 's/>/>coassembly/g' coassembly_final.contigs.fa
```