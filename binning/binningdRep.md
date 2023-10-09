# de-replicate a genome set - best representative genome

## [dRep](https://github.com/MrOlm/drep)

1. Install dRep

```bash
$ conda create -n dRep -c bioconda dRep
$ conda activate dRep

$ dRep check_dependencies
```

\
2. Navigate to a working directory and create links to genome bins

```bash
$ cd binning/drep/
$ ln -s /work/ebg_lab/gm/gapp/dgittins/ReservoirMicrobiology/Metagenomes/Christman2020/binning/dastool/*_DASTool_bins/*[0-9].fa .
```

\
3. Run dRep (default 95% ANI, 10% minimum alignment coverage)

```bash
for f in *_final.contigs.fa 
do
	sample=$(basename $f _final.contigs.fa)
	dRep dereplicate drep_out -g path/to/genomes/*.fasta
done
```


dRep dereplicate output_directory -g path/to/genomes/*.fasta
