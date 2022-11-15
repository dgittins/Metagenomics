# Recovery of genomes from metagenomic datasets

## [CONCOCT](https://github.com/BinPro/CONCOCT) (workflow described here: https://github.com/BinPro/CONCOCT)

1. Install CONCOCT

```bash
$ conda create -n concoct -c bioconda concoct
$ conda activate concoct
```

\
2. Navigate to a working directory and create links to assembled contig files

```bash
$ cd binning/concoct/
$ ln -s ../../assembly/megahit/*/*_final.contigs.fa .
```

\
3. Cut contigs into smaller parts
```bash
for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	cut_up_fasta.py ${sample}_final.contigs.fa -c 10000 -o 0 --merge_last -b -a ${sample}_contigs.10K.bed > ${sample}_contigs.10K.fa
done
```
	
	${sample}_bowtie.depth.txt -o ${sample}.bin --unbinned -t 40 >& ${sample}.metabat2.log.txt
done
cut_up_fasta.py original_contigs.fa -c 10000 -o 0 --merge_last -b contigs_10K.bed > contigs_10K.fa



\
3. Run Metabat 2

```bash
for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	metabat2 -i ${sample}_final.contigs.fa -a ${sample}assembly.bbmap.depth.txt -o ${sample}.bin --unbinned -t 20 >& ${sample}.metabat2.log.txt
done
```
