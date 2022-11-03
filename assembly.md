# Assemble QC reads

## [MEGAHIT](https://academic.oup.com/bioinformatics/article/31/10/1674/177884)

1. Install MEGAHIT

```bash
$ conda create -n megahit -c bioconda megahit
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
for f in *_pass_1.qc.fastq
do
  sample=$(basename $f _pass_1.qc.fastq)
  megahit -1 ${sample}_pass_1.qc.fastq -2 ${sample}_pass_2.qc.fastq -t 20 -m 0.5 --min-contig-len 500 -o ${sample}_megahit_assembly  >& ${sample}_megahit.log.txt
done

megahit -1 sample1_pass_1.qc.fastq,sample2_pass_1.qc.fastq,sample3_pass_1.qc.fastq -2 sample1_pass_2.qc.fastq,sample2_pass_2.qc.fastq,sample3_pass_2.qc.fastq -t 20 -m 0.5 --min-contig-len 500 -o megahit_coassembly >& megahit_coassembly.log.txt
```

\
4. Add a prefix of the sample name to the final.contigs.fa file and each assembled contig within the file

```bash
$ cd sample1_megahit_assembly

$ sample=$(basename "$PWD" _megahit_assembly) #create a variable of the sample name from the directory name
$ mv final.contigs.fa ${sample}_final.contigs.fa #add sample name to file name
$ sed -i "s/>/>${sample}/g" ${sample}_final.contigs.fa #add sample name to each contig
```

