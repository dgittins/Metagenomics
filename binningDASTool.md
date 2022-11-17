# Calculate an optimized, non-redundant set of bins

## [DAS Tool](https://github.com/cmks/DAS_Tool)

1. Install DAS Tool

```bash
$ conda create -n dastool -c bioconda das_tool
$ conda activate dastool
```

\
2. Navigate to a working directory and create links to assembled contigs and copies of contigs to bin tables

```bash
$ cd binning/dastool/
$ ln -s ../../assembly/megahit/*/*_final.contigs.fa .
$ cp ../*/*.contigs2bin.tsv .

#Concoct contigs2bin.tsv may need to be editted to remove "flag=" "multi=" and "len=" values from contig names if they exist
for f in _concoct.contigs2bin.tsv
do
  sample=$(basename $f _concoct.contigs2bin.tsv)
  gawk -i inplace '{print $1 "\t" $5}' ${sample}_concoct.contigs2bin.tsv
done
```

\
3. Run DAS Tool

```bash


```

