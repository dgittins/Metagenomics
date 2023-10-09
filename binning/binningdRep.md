# de-replicate a genome set - best representative genome

## [dRep](https://github.com/MrOlm/drep)

1. Install dRep

```bash
$ conda create -n dRep -c bioconda dRep
$ conda activate dRep
```

\
2. Navigate to a working directory and create links to assembled contigs and copies of contigs to bin tables

```bash
$ cd binning/dastool/
$ ln -s ../../assembly/megahit/*/*_final.contigs.fa .
$ cp ../*/*.contigs2bin.tsv .

#Concoct contigs2bin.tsv may need to be editted to remove "flag=" "multi=" and "len=" values from contig names if they exist
$ gawk -i inplace '{print $1 "\t" $5}' *_concoct.contigs2bin.tsv
```

\
3. Run DAS Tool

```bash
for f in *_final.contigs.fa 
do
	sample=$(basename $f _final.contigs.fa)
	DAS_Tool -i ${sample}_concoct.contigs2bin.tsv,${sample}_maxbin.contigs2bin.tsv,${sample}_metabat.contigs2bin.tsv -c ${sample}_final.contigs.fa -o ${sample} --write_bin_evals --write_bins --write_unbinned -t 20 >& ${sample}_dastool.log.txt
done
```


dRep dereplicate output_directory -g path/to/genomes/*.fasta
