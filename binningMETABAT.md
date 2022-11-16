# Recovery of genomes from metagenomic datasets

## [MetaBAT 2](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6662567/)

1. Install MetaBAT 2

```bash
$ conda create -n metabat2 -c bioconda metabat2
$ conda activate metabat2
```

\
2. Navigate to a working directory and create links to assembled contig files and depth files created during [mapping](https://github.com/dgittins/Metagenomics/blob/main/mappingBowtie.md)

```bash
$ cd binning/metabat2/
$ ln -s ../../assembly/megahit/*/*_final.contigs.fa .
$ ln -s ../../mapping/bowtie/*_bowtie.depth.txt .
```

\
3. Run Metabat 2

```bash
for f in *_final.contigs.fa
do 
	sample=$(basename $f _final.contigs.fa)
	mkdir ${sample}_metabat.out
	metabat2 -i ${sample}_final.contigs.fa -a ${sample}_bowtie.depth.txt -o ${sample}_metabat.out/${sample}_metabat --unbinned -t 20 >& ${sample}.metabat2.log.txt
done
```

\
4. Prepare output for DAS Tool bin refinement 

```bash

$ wget https://github.com/cmks/DAS_Tool/raw/master/src/Fasta_to_Contig2Bin.sh #script to convert genome bins in fasta format to contigs-to-bin table


for dir in */
do
	cd "$dir"
	sample=$(echo "$dir" | cut -d\_ -f1) #create a variable of the sample name from the directory name
	sh ../Fasta_to_Contig2Bin.sh -e [0-99].fa > ../${sample}_metabat.contigs2bin.tsv #run Fasta_to_Contig2Bin script
	cd ../	
done
```
